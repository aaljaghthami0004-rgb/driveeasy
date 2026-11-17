<%@ Page Title="DriveEasy Car Rental | Sign Up" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Signup.aspx.cs" Inherits="SignupPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .strength-track {
            height: 8px;
            background-color: #e3e8ee;
            border-radius: 4px;
            margin-top: 6px;
            overflow: hidden;
        }
        #strengthBar { height: 100%; width: 0; background-color: #c0392b; }
        #strengthText { font-size: 13px; }
        .radio-list label { font-weight: normal; margin: 0 14px 0 4px; }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-title">
        <div class="container">
            <h1>Create an Account</h1>
            <p style="margin:0;">It is free and takes less than a minute.</p>
        </div>
    </section>

    <main class="container page-section">
        <asp:Panel ID="pnlSignup" runat="server" CssClass="card form-box shadow-box" DefaultButton="btnSignup">
            <h2>Sign Up</h2>
            <asp:Label ID="lblError" runat="server" CssClass="error-box" Visible="false" />

            <fieldset>
                <legend>Personal Information</legend>
                <div class="form-row">
                    <label for="suName">Full Name *</label>
                    <asp:TextBox ID="suName" runat="server" MaxLength="100" />
                    <span class="error-msg" id="suNameError"></span>
                </div>
                <div class="two-cols">
                    <div class="form-row">
                        <label for="suEmail">Email *</label>
                        <asp:TextBox ID="suEmail" runat="server" TextMode="Email" MaxLength="100" placeholder="name@example.com" />
                        <span class="error-msg" id="suEmailError"></span>
                    </div>
                    <div class="form-row">
                        <label for="suPhone">Mobile Number *</label>
                        <asp:TextBox ID="suPhone" runat="server" TextMode="Phone" MaxLength="10" placeholder="05XXXXXXXX" />
                        <span class="error-msg" id="suPhoneError"></span>
                    </div>
                </div>
                <div class="two-cols">
                    <div class="form-row">
                        <label for="suBirth">Date of Birth *</label>
                        <asp:TextBox ID="suBirth" runat="server" TextMode="Date" />
                        <span class="error-msg" id="suBirthError"></span>
                    </div>
                    <div class="form-row">
                        <label for="suCity">City *</label>
                        <asp:DropDownList ID="suCity" runat="server">
                            <asp:ListItem Value="" Text="-- Select a city --" />
                            <asp:ListItem Value="Jeddah" Text="Jeddah" />
                            <asp:ListItem Value="Makkah" Text="Makkah" />
                            <asp:ListItem Value="Madinah" Text="Madinah" />
                            <asp:ListItem Value="Riyadh" Text="Riyadh" />
                            <asp:ListItem Value="Other" Text="Other" />
                        </asp:DropDownList>
                        <span class="error-msg" id="suCityError"></span>
                    </div>
                </div>
                <div class="form-row">
                    <label>Gender *</label>
                    <asp:RadioButtonList ID="gender" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="radio-list">
                        <asp:ListItem Value="Male" Text="Male" />
                        <asp:ListItem Value="Female" Text="Female" />
                    </asp:RadioButtonList>
                    <span class="error-msg" id="genderError"></span>
                </div>
            </fieldset>

            <fieldset>
                <legend>Account Information</legend>
                <div class="form-row">
                    <label for="suUser">Username *</label>
                    <asp:TextBox ID="suUser" runat="server" MaxLength="20" autocomplete="username" />
                    <span class="error-msg" id="suUserError"></span>
                </div>
                <div class="form-row">
                    <label for="suPassword">Password *</label>
                    <asp:TextBox ID="suPassword" runat="server" TextMode="Password" MaxLength="50" autocomplete="new-password" />
                    <div class="strength-track"><div id="strengthBar"></div></div>
                    <span id="strengthText"></span>
                    <span class="error-msg" id="suPasswordError"></span>
                </div>
                <div class="form-row">
                    <label for="suConfirm">Confirm Password *</label>
                    <asp:TextBox ID="suConfirm" runat="server" TextMode="Password" MaxLength="50" autocomplete="new-password" />
                    <span class="error-msg" id="suConfirmError"></span>
                </div>
            </fieldset>

            <div class="form-row">
                <asp:CheckBox ID="suTerms" runat="server" />
                <label for="suTerms" class="inline-label">I accept the <a href="About.aspx#policy">rental policy</a> *</label>
                <span class="error-msg" id="suTermsError"></span>
            </div>

            <asp:Button ID="btnSignup" runat="server" Text="Create Account" CssClass="btn" OnClick="btnSignup_Click" />
            <p class="mt">Already have an account? <a href="Login.aspx">Login here</a></p>
        </asp:Panel>
    </main>
</asp:Content>
