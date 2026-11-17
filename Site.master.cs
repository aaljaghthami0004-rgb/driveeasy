using System;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // the menu changes when the user is logged in (session)
        bool loggedIn = Session["UserId"] != null;
        phGuest.Visible = !loggedIn;
        phMember.Visible = loggedIn;
        if (loggedIn)
        {
            litUserName.Text = Server.HtmlEncode(Convert.ToString(Session["Username"]));
        }
    }
}
