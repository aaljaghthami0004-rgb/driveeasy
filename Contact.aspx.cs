using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;

public partial class ContactPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // if the user is logged in, fill the name from the session
            if (Session["FullName"] != null)
            {
                fbName.Text = Session["FullName"].ToString();
                object mail = Db.Scalar("SELECT Email FROM Users WHERE UserId = @id", Db.P("@id", Session["UserId"]));
                if (mail != null)
                {
                    fbEmail.Text = mail.ToString();
                }
            }
            LoadFeedback();
        }
    }

    // RETRIEVE the last 5 messages
    private void LoadFeedback()
    {
        DataTable list = Db.GetTable("SELECT TOP 5 Name, Rating, Message FROM Feedback ORDER BY CreatedAt DESC, FeedbackId DESC");
        rptFeedback.DataSource = list;
        rptFeedback.DataBind();
    }

    protected string RatingText(object value)
    {
        switch (Convert.ToInt32(value))
        {
            case 5: return "Excellent";
            case 4: return "Good";
            case 3: return "Average";
            default: return "Poor";
        }
    }

    // RECEIVING AND PROCESSING FORM DATA + INSERT
    protected void btnSend_Click(object sender, EventArgs e)
    {
        List<string> errors = new List<string>();
        if (!Validator.IsValidName(fbName.Text)) errors.Add("Name must be at least 3 letters.");
        if (!Validator.IsValidEmail(fbEmail.Text)) errors.Add("Please enter a valid email.");
        if (fbSubject.SelectedValue == "") errors.Add("Please choose a subject.");
        if (rating.SelectedIndex < 0) errors.Add("Please choose a rating.");
        if (fbMessage.Text.Trim().Length < 10) errors.Add("Message must be at least 10 characters.");
        if (fbMessage.Text.Length > 500) errors.Add("Message must be 500 characters or less.");

        if (errors.Count > 0)
        {
            lblMessage.Text = string.Join("<br />", errors.ToArray());
            lblMessage.CssClass = "error-box";
            lblMessage.Visible = true;
            return;
        }

        Db.Execute("INSERT INTO Feedback (Name, Email, Subject, Rating, Message) VALUES (@name, @mail, @subject, @rating, @message)",
            Db.P("@name", fbName.Text.Trim()),
            Db.P("@mail", fbEmail.Text.Trim()),
            Db.P("@subject", fbSubject.SelectedValue),
            Db.P("@rating", int.Parse(rating.SelectedValue)),
            Db.P("@message", fbMessage.Text.Trim()));

        lblMessage.Text = "Thank you " + Server.HtmlEncode(fbName.Text.Trim()) + "! Your feedback was saved.";
        lblMessage.CssClass = "success-box";
        lblMessage.Visible = true;

        fbSubject.SelectedIndex = 0;
        rating.ClearSelection();
        fbMessage.Text = "";
        LoadFeedback();
    }
}
