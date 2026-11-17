using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MyBookingsPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // session check: this page is for logged-in users only
        if (Session["UserId"] == null)
        {
            Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
            return;
        }

        if (Session["LoginTime"] != null)
        {
            litSession.Text = "Logged in as " + Server.HtmlEncode(Convert.ToString(Session["Username"])) +
                              " since " + ((DateTime)Session["LoginTime"]).ToString("hh:mm tt") + ".";
        }

        if (!IsPostBack)
        {
            LoadBookings();
        }
    }

    private int UserId
    {
        get { return Convert.ToInt32(Session["UserId"]); }
    }

    // RETRIEVE
    private void LoadBookings()
    {
        DataTable bookings = Db.GetTable(
            "SELECT b.BookingId, c.Name + ' ' + CAST(c.ModelYear AS NVARCHAR(4)) AS CarName, b.Branch, " +
            "b.PickupDate, b.ReturnDate, b.Extras, b.PaymentMethod, b.TotalPrice " +
            "FROM Bookings b INNER JOIN Cars c ON b.CarId = c.CarId " +
            "WHERE b.UserId = @user ORDER BY b.PickupDate DESC",
            Db.P("@user", UserId));

        rptBookings.DataSource = bookings;
        rptBookings.DataBind();
        rptBookings.Visible = bookings.Rows.Count > 0;
        pnlEmpty.Visible = bookings.Rows.Count == 0;
    }

    protected void rptBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int bookingId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "DeleteBooking")
        {
            // DELETE (the user can only delete his own booking)
            int rows = Db.Execute("DELETE FROM Bookings WHERE BookingId = @id AND UserId = @user",
                                  Db.P("@id", bookingId), Db.P("@user", UserId));
            ShowMessage(rows == 1 ? "Booking #" + bookingId + " was cancelled." : "The booking was not found.", rows == 1);
            pnlEdit.Visible = false;
            LoadBookings();
        }
        else if (e.CommandName == "EditBooking")
        {
            OpenEditForm(bookingId);
        }
    }

    private void OpenEditForm(int bookingId)
    {
        DataTable table = Db.GetTable(
            "SELECT b.BookingId, b.Branch, b.PickupDate, b.ReturnDate, b.Extras, " +
            "c.Name + ' ' + CAST(c.ModelYear AS NVARCHAR(4)) AS CarName " +
            "FROM Bookings b INNER JOIN Cars c ON b.CarId = c.CarId " +
            "WHERE b.BookingId = @id AND b.UserId = @user",
            Db.P("@id", bookingId), Db.P("@user", UserId));

        if (table.Rows.Count != 1)
        {
            ShowMessage("The booking was not found.", false);
            return;
        }

        DataRow row = table.Rows[0];
        hfBookingId.Value = bookingId.ToString();
        litEditId.Text = bookingId.ToString();
        litEditCar.Text = Server.HtmlEncode(row["CarName"].ToString());
        editBranch.SelectedValue = row["Branch"].ToString();
        editPickup.Text = ((DateTime)row["PickupDate"]).ToString("yyyy-MM-dd");
        editReturn.Text = ((DateTime)row["ReturnDate"]).ToString("yyyy-MM-dd");

        string extras = row["Extras"].ToString();
        editGps.Checked = extras.Contains("GPS");
        editSeat.Checked = extras.Contains("Child Seat");
        editInsurance.Checked = extras.Contains("Full Insurance");

        lblMessage.Visible = false;
        pnlEdit.Visible = true;
    }

    // UPDATE
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int bookingId = Convert.ToInt32(hfBookingId.Value);
        DateTime pickup, ret;
        bool okPickup = DateTime.TryParseExact(editPickup.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out pickup);
        bool okReturn = DateTime.TryParseExact(editReturn.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out ret);

        if (!okPickup || !okReturn)
        {
            ShowMessage("Please enter both dates.", false);
            return;
        }
        if (pickup < DateTime.Today)
        {
            ShowMessage("Pick-up date cannot be in the past.", false);
            return;
        }
        if (ret <= pickup)
        {
            ShowMessage("Return date must be after the pick-up date.", false);
            return;
        }
        if (PriceCalculator.GetDays(pickup, ret) > 60)
        {
            ShowMessage("The maximum rental period is 60 days.", false);
            return;
        }

        List<string> extras = new List<string>();
        if (editGps.Checked) extras.Add("GPS");
        if (editSeat.Checked) extras.Add("Child Seat");
        if (editInsurance.Checked) extras.Add("Full Insurance");
        string extrasText = string.Join(", ", extras.ToArray());

        object price = Db.Scalar(
            "SELECT c.PricePerDay FROM Bookings b INNER JOIN Cars c ON b.CarId = c.CarId " +
            "WHERE b.BookingId = @id AND b.UserId = @user",
            Db.P("@id", bookingId), Db.P("@user", UserId));
        if (price == null)
        {
            ShowMessage("The booking was not found.", false);
            return;
        }

        decimal total = PriceCalculator.Calculate(Convert.ToDecimal(price), PriceCalculator.GetDays(pickup, ret), extrasText);

        Db.Execute(
            "UPDATE Bookings SET Branch = @branch, PickupDate = @pickup, ReturnDate = @return, " +
            "Extras = @extras, TotalPrice = @total WHERE BookingId = @id AND UserId = @user",
            Db.P("@branch", editBranch.SelectedValue),
            Db.P("@pickup", pickup),
            Db.P("@return", ret),
            Db.P("@extras", extrasText),
            Db.P("@total", total),
            Db.P("@id", bookingId),
            Db.P("@user", UserId));

        pnlEdit.Visible = false;
        ShowMessage("Booking #" + bookingId + " was updated. New total: " + total.ToString("0.##") + " SAR.", true);
        LoadBookings();
    }

    protected void btnCancelEdit_Click(object sender, EventArgs e)
    {
        pnlEdit.Visible = false;
        lblMessage.Visible = false;
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = text;
        lblMessage.CssClass = success ? "success-box" : "error-box";
        lblMessage.Visible = true;
    }
}
