<%@ Page Title="DriveEasy Car Rental | Login" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="LoginPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .auth-box { max-width: 430px; margin: 0 auto; }
        .auth-box h2 { text-align: center; }
        .auth-links { text-align: center; margin-top: 15px; }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-title">
        <div class="container">
            <h1>Login</h1>
            <p style="margin:0;">Log in to book a car and manage your bookings.</p>
        </div>
    </section>

    <main class="container page-section">
        <asp:Panel ID="pnlLogin" runat="server" CssClass="card auth-box shadow-box" DefaultButton="btnLogin">
            <h2>Welcome Back</h2>
            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <div class="form-row">
                <label for="loginUser">Username or Email *</label>
                <asp:TextBox ID="loginUser" runat="server" MaxLength="100" autocomplete="username" />
                <span class="error-msg" id="loginUserError"></span>
            </div>
            <div class="form-row">
                <label for="loginPassword">Password *</label>
                <asp:TextBox ID="loginPassword" runat="server" TextMode="Password" MaxLength="50" autocomplete="current-password" />
                <span class="error-msg" id="loginPasswordError"></span>
            </div>
            <div class="form-row">
                <input type="checkbox" id="showPassword" />
                <label for="showPassword" class="inline-label">Show password</label>
                <asp:CheckBox ID="rememberMe" runat="server" />
                <label for="rememberMe" class="inline-label">Remember me</label>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" Width="100%" OnClick="btnLogin_Click" />

            <div class="auth-links">
                <p>New customer? <a href="Signup.aspx">Create an account</a></p>
                <p class="small-text">Forgot your password? Call us on 012 600 1111.</p>
            </div>
        </asp:Panel>
    </main>
</asp:Content>
