using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class DefaultPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ShowVisitMessage();
            LoadPrices();
        }
    }

    // uses the session (logged-in user) and a cookie (date of the last visit)
    private void ShowVisitMessage()
    {
        string message;
        if (Session["UserId"] != null)
        {
            message = "Hello <strong>" + Server.HtmlEncode(Convert.ToString(Session["FullName"])) +
                      "</strong>, you are logged in. <a href=\"MyBookings.aspx\">See your bookings</a>.";
        }
        else
        {
            message = "You are browsing as a guest. <a href=\"Login.aspx\">Log in</a> to book a car.";
        }

        HttpCookie lastVisit = Request.Cookies["LastVisit"];
        if (lastVisit != null && !string.IsNullOrEmpty(lastVisit.Value))
        {
            message += "<br />Welcome back! Your last visit was on " + Server.HtmlEncode(lastVisit.Value) + ".";
        }
        else
        {
            message += "<br />This is your first visit. Welcome to DriveEasy!";
        }
        litVisit.Text = message;

        // save the time of this visit for the next time (cookie lives 30 days)
        HttpCookie cookie = new HttpCookie("LastVisit", DateTime.Now.ToString("dd/MM/yyyy hh:mm tt"));
        cookie.Expires = DateTime.Now.AddDays(30);
        cookie.HttpOnly = true;
        Response.Cookies.Add(cookie);
    }

    // retrieve the cars and their prices from the database
    private void LoadPrices()
    {
        DataTable cars = Db.GetTable(
            "SELECT Name, ModelYear, Category, PricePerDay, " +
            "CAST(ROUND(PricePerDay * 7 * 0.9, 0) AS DECIMAL(10,0)) AS WeekPrice " +
            "FROM Cars ORDER BY PricePerDay");
        rptPrices.DataSource = cars;
        rptPrices.DataBind();
    }
}
