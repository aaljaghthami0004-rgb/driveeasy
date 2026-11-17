using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BookingPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // only logged-in users can book (session check)
        if (Session["UserId"] == null)
        {
            Response.Redirect("Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
            return;
        }

        DataTable cars = Db.GetTable("SELECT CarId, Name, ModelYear, PricePerDay FROM Cars ORDER BY Name");
        WriteCarPricesScript(cars);

        string today = DateTime.Today.ToString("yyyy-MM-dd");
        pickupDate.Attributes["min"] = today;
        returnDate.Attributes["min"] = today;

        if (!IsPostBack)
        {
            FillCars(cars);
            FillUserData();

            // cookie: the branch the user chose last time
            HttpCookie branchCookie = Request.Cookies["PreferredBranch"];
            if (branchCookie != null && branch.Items.FindByValue(branchCookie.Value) != null)
            {
                branch.SelectedValue = branchCookie.Value;
            }
        }
    }

    // writes { "1": 180, "2": 120, ... } so the JavaScript can show the price before submit
    private void WriteCarPricesScript(DataTable cars)
    {
        StringBuilder json = new StringBuilder("{");
        for (int i = 0; i < cars.Rows.Count; i++)
        {
            if (i > 0)
            {
                json.Append(", ");
            }
            json.Append("\"" + cars.Rows[i]["CarId"] + "\": " +
                Convert.ToDecimal(cars.Rows[i]["PricePerDay"]).ToString("0.##", CultureInfo.InvariantCulture));
        }
        json.Append("}");
        litCarPrices.Text = json.ToString();
    }

    private void FillCars(DataTable cars)
    {
        car.Items.Clear();
        car.Items.Add(new ListItem("-- Select a car --", ""));
        foreach (DataRow row in cars.Rows)
        {
            string text = row["Name"] + " " + row["ModelYear"] + " (" +
                          Convert.ToDecimal(row["PricePerDay"]).ToString("0") + " SAR/day)";
            car.Items.Add(new ListItem(text, row["CarId"].ToString()));
        }

        // the car chosen on the Cars page, e.g. Booking.aspx?carId=3
        string carId = Request.QueryString["carId"];
        if (!string.IsNullOrEmpty(carId) && car.Items.FindByValue(carId) != null)
        {
            car.SelectedValue = carId;
        }
    }

    // fills name, email and phone from the user's account
    private void FillUserData()
    {
        DataTable user = Db.GetTable("SELECT FullName, Email, Phone FROM Users WHERE UserId = @id",
                                     Db.P("@id", Session["UserId"]));
        if (user.Rows.Count == 1)
        {
            fullName.Text = user.Rows[0]["FullName"].ToString();
            email.Text = user.Rows[0]["Email"].ToString();
            phone.Text = user.Rows[0]["Phone"].ToString();
        }
    }

    // RECEIVING AND PROCESSING FORM DATA + INSERT
    protected void btnBook_Click(object sender, EventArgs e)
    {
        List<string> errors = new List<string>();

        if (!Validator.IsValidName(fullName.Text)) errors.Add("Please enter a valid full name (letters only, at least 3).");
        if (!Validator.IsValidPhone(phone.Text)) errors.Add("Mobile number must be 10 digits and start with 05.");
        if (!Validator.IsValidEmail(email.Text)) errors.Add("Please enter a valid email.");
        if (car.SelectedValue == "") errors.Add("Please choose a car.");
        if (branch.SelectedValue == "") errors.Add("Please choose a pick-up branch.");

        DateTime pickup, ret;
        bool pickupOk = DateTime.TryParseExact(pickupDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out pickup);
        bool returnOk = DateTime.TryParseExact(returnDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out ret);
        if (!pickupOk) errors.Add("Please choose the pick-up date.");
        else if (pickup < DateTime.Today) errors.Add("Pick-up date cannot be in the past.");
        if (!returnOk) errors.Add("Please choose the return date.");
        else if (pickupOk && ret <= pickup) errors.Add("Return date must be after the pick-up date.");
        else if (pickupOk && PriceCalculator.GetDays(pickup, ret) > 60) errors.Add("The maximum rental period is 60 days.");

        if (payment.SelectedIndex < 0) errors.Add("Please choose a payment method.");
        if (!terms.Checked) errors.Add("You must agree to the rental policy.");

        if (errors.Count > 0)
        {
            lblError.Text = string.Join("<br />", errors.ToArray());
            lblError.Visible = true;
            return;
        }

        // the price is always taken from the database (never trusted from the browser)
        object priceValue = Db.Scalar("SELECT PricePerDay FROM Cars WHERE CarId = @id", Db.P("@id", int.Parse(car.SelectedValue)));
        if (priceValue == null)
        {
            lblError.Text = "The selected car was not found.";
            lblError.Visible = true;
            return;
        }

        List<string> extras = new List<string>();
        if (extraGps.Checked) extras.Add("GPS");
        if (extraSeat.Checked) extras.Add("Child Seat");
        if (extraInsurance.Checked) extras.Add("Full Insurance");
        string extrasText = string.Join(", ", extras.ToArray());

        int days = PriceCalculator.GetDays(pickup, ret);
        decimal total = PriceCalculator.Calculate(Convert.ToDecimal(priceValue), days, extrasText);

        object newId = Db.Scalar(
            "INSERT INTO Bookings (UserId, CarId, Branch, PickupDate, ReturnDate, Extras, PaymentMethod, Notes, TotalPrice) " +
            "VALUES (@user, @car, @branch, @pickup, @return, @extras, @payment, @notes, @total); " +
            "SELECT CAST(SCOPE_IDENTITY() AS INT);",
            Db.P("@user", Session["UserId"]),
            Db.P("@car", int.Parse(car.SelectedValue)),
            Db.P("@branch", branch.SelectedValue),
            Db.P("@pickup", pickup),
            Db.P("@return", ret),
            Db.P("@extras", extrasText),
            Db.P("@payment", payment.SelectedValue),
            Db.P("@notes", notes.Text.Trim()),
            Db.P("@total", total));

        // cookie: remember the branch for the next booking (60 days)
        HttpCookie branchCookie = new HttpCookie("PreferredBranch", branch.SelectedValue);
        branchCookie.Expires = DateTime.Now.AddDays(60);
        Response.Cookies.Add(branchCookie);

        // session: remember the last booking of this visit
        Session["LastBookingId"] = newId;

        litDone.Text = "Thank you " + Server.HtmlEncode(fullName.Text.Trim()) + "! Your booking number <strong>#" + newId +
                       "</strong> is confirmed: " + Server.HtmlEncode(car.SelectedItem.Text) + ", " + days + " day(s), from " +
                       pickup.ToString("dd/MM/yyyy") + " to " + ret.ToString("dd/MM/yyyy") +
                       ". Total price: <strong>" + total.ToString("0.##") + " SAR</strong>.";
        pnlForm.Visible = false;
        pnlDone.Visible = true;
    }
}
