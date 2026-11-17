using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class LoginPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // already logged in -> no need to see the login form
            if (Session["UserId"] != null)
            {
                Response.Redirect("MyBookings.aspx");
                return;
            }

            if (Request.QueryString["registered"] == "1")
            {
                ShowMessage("Your account was created successfully. Please log in.", true);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["ReturnUrl"]))
            {
                ShowMessage("Please log in first to continue.", false);
            }

            // cookie: fill the username if the user chose "Remember me" last time
            HttpCookie remember = Request.Cookies["RememberUser"];
            if (remember != null && !string.IsNullOrEmpty(remember.Value))
            {
                loginUser.Text = remember.Value;
                rememberMe.Checked = true;
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string user = loginUser.Text.Trim();
        string password = loginPassword.Text;

        if (user.Length < 3 || password.Length == 0)
        {
            ShowMessage("Please enter your username (or email) and your password.", false);
            return;
        }

        // RETRIEVE the user by username or email and compare the password hash
        DataTable result = Db.GetTable(
            "SELECT UserId, FullName, Username FROM Users " +
            "WHERE (Username = @user OR Email = @user) AND PasswordHash = @hash",
            Db.P("@user", user),
            Db.P("@hash", PasswordHelper.Hash(password)));

        if (result.Rows.Count != 1)
        {
            ShowMessage("Wrong username or password.", false);
            return;
        }

        // SESSION: save the user's data for the other pages
        Session["UserId"] = result.Rows[0]["UserId"];
        Session["FullName"] = result.Rows[0]["FullName"];
        Session["Username"] = result.Rows[0]["Username"];
        Session["LoginTime"] = DateTime.Now;

        // COOKIE: remember the username for 30 days, or delete the cookie
        HttpCookie remember = new HttpCookie("RememberUser");
        if (rememberMe.Checked)
        {
            remember.Value = result.Rows[0]["Username"].ToString();
            remember.Expires = DateTime.Now.AddDays(30);
        }
        else
        {
            remember.Expires = DateTime.Now.AddDays(-1);
        }
        remember.HttpOnly = true;
        Response.Cookies.Add(remember);

        Response.Redirect(GetSafeReturnUrl());
    }

    // only go back to a page of this website
    private string GetSafeReturnUrl()
    {
        string url = Request.QueryString["ReturnUrl"];
        if (!string.IsNullOrEmpty(url) && url.StartsWith("/") && !url.StartsWith("//") && !url.Contains("://"))
        {
            return url;
        }
        return "Default.aspx";
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = text;
        lblMessage.CssClass = success ? "success-box" : "error-box";
        lblMessage.Visible = true;
    }
}
