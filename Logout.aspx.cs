using System;
using System.Web.UI;

public partial class LogoutPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // end the session (the "Remember me" cookie stays so the username is filled next time)
        Session.Clear();
        Session.Abandon();
        Response.Redirect("Default.aspx");
    }
}
