using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI;

public partial class SignupPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        suBirth.Attributes["max"] = DateTime.Today.ToString("yyyy-MM-dd");
    }

    // RECEIVING AND PROCESSING FORM DATA + INSERT a new user
    protected void btnSignup_Click(object sender, EventArgs e)
    {
        List<string> errors = new List<string>();

        string name = suName.Text.Trim();
        string mail = suEmail.Text.Trim();
        string mobile = suPhone.Text.Trim();
        string username = suUser.Text.Trim();
        string password = suPassword.Text;

        if (!Validator.IsValidName(name)) errors.Add("Name must be at least 3 letters (letters and spaces only).");
        if (!Validator.IsValidEmail(mail)) errors.Add("Please enter a valid email.");
        if (!Validator.IsValidPhone(mobile)) errors.Add("Mobile number must be 10 digits and start with 05.");

        DateTime birth;
        if (!DateTime.TryParseExact(suBirth.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out birth))
        {
            errors.Add("Please enter your date of birth.");
        }
        else if (Validator.GetAge(birth) < 21)
        {
            errors.Add("You must be at least 21 years old to rent a car.");
        }

        if (suCity.SelectedValue == "") errors.Add("Please choose your city.");
        if (gender.SelectedIndex < 0) errors.Add("Please choose your gender.");
        if (!Validator.IsValidUsername(username)) errors.Add("Username: 4-20 letters, numbers or _ only.");
        if (!Validator.IsStrongPassword(password)) errors.Add("Password needs 8+ characters with upper case, lower case and a number.");
        if (password != suConfirm.Text) errors.Add("Passwords do not match.");
        if (!suTerms.Checked) errors.Add("You must accept the rental policy.");

        // the username and the email must not be used before
        if (errors.Count == 0)
        {
            int usedUser = Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM Users WHERE Username = @u", Db.P("@u", username)));
            int usedMail = Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM Users WHERE Email = @e", Db.P("@e", mail)));
            if (usedUser > 0) errors.Add("This username is already taken. Please choose another one.");
            if (usedMail > 0) errors.Add("There is already an account with this email.");
        }

        if (errors.Count > 0)
        {
            lblError.Text = string.Join("<br />", errors.ToArray());
            lblError.Visible = true;
            return;
        }

        Db.Execute(
            "INSERT INTO Users (FullName, Email, Phone, Username, PasswordHash, BirthDate, City, Gender) " +
            "VALUES (@name, @mail, @phone, @user, @hash, @birth, @city, @gender)",
            Db.P("@name", name),
            Db.P("@mail", mail),
            Db.P("@phone", mobile),
            Db.P("@user", username),
            Db.P("@hash", PasswordHelper.Hash(password)),
            Db.P("@birth", birth),
            Db.P("@city", suCity.SelectedValue),
            Db.P("@gender", gender.SelectedValue));

        Response.Redirect("Login.aspx?registered=1");
    }
}
