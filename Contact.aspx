<%@ Page Title="DriveEasy Car Rental | Contact Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="ContactPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .contact-layout {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            align-items: flex-start;
        }
        .contact-layout > section { flex: 1 1 400px; }
        #charCounter { font-size: 13px; color: #6b7785; }
        #feedbackList { list-style: none; margin: 0; }
        #feedbackList li {
            background-color: #f7f9fb;
            border-left: 4px solid #f28c28;
            padding: 8px 12px;
            margin-bottom: 8px;
            border-radius: 4px;
        }
        .radio-list label { font-weight: normal; margin: 0 14px 0 4px; }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-title">
        <div class="container">
            <h1>Contact Us</h1>
            <p style="margin:0;">We are happy to answer your questions and hear your feedback.</p>
        </div>
    </section>

    <main class="container page-section">
        <nav class="on-this-page" aria-label="On this page">
            <strong>On this page:</strong>
            <ul>
                <li><a href="#branches">Our Branches</a></li>
                <li><a href="#feedback">Send Feedback</a></li>
            </ul>
        </nav>

        <section id="branches">
            <h2>Our Branches</h2>
            <table class="data-table">
                <thead>
                    <tr>
                        <th scope="col">Branch</th>
                        <th scope="col">Address</th>
                        <th scope="col">Phone</th>
                        <th scope="col">Working Hours</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Airport</td>
                        <td>King Abdulaziz International Airport, North Terminal</td>
                        <td>012 600 1111</td>
                        <td>24 hours</td>
                    </tr>
                    <tr>
                        <td>Al-Rawdah</td>
                        <td>Prince Sultan Road, Al-Rawdah District</td>
                        <td>012 600 2222</td>
                        <td rowspan="2">8:00 AM &ndash; 11:00 PM</td>
                    </tr>
                    <tr>
                        <td>Al-Hamra</td>
                        <td>Corniche Road, Al-Hamra District</td>
                        <td>012 600 3333</td>
                    </tr>
                </tbody>
            </table>
            <p>Email: <a href="mailto:info@driveeasy.sa">info@driveeasy.sa</a> &nbsp;|&nbsp; WhatsApp: 055 000 1234</p>
        </section>

        <div class="contact-layout">
            <asp:Panel ID="feedback" runat="server" CssClass="card" DefaultButton="btnSend">
                <h2>Send Us Your Feedback</h2>
                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <div class="form-row">
                    <label for="fbName">Your Name *</label>
                    <asp:TextBox ID="fbName" runat="server" MaxLength="100" />
                    <span class="error-msg" id="fbNameError"></span>
                </div>
                <div class="form-row">
                    <label for="fbEmail">Email *</label>
                    <asp:TextBox ID="fbEmail" runat="server" TextMode="Email" MaxLength="100" placeholder="name@example.com" />
                    <span class="error-msg" id="fbEmailError"></span>
                </div>
                <div class="form-row">
                    <label for="fbSubject">Subject *</label>
                    <asp:DropDownList ID="fbSubject" runat="server">
                        <asp:ListItem Value="" Text="-- Select a subject --" />
                        <asp:ListItem Value="Booking" Text="Question about a booking" />
                        <asp:ListItem Value="Suggestion" Text="Suggestion" />
                        <asp:ListItem Value="Complaint" Text="Complaint" />
                        <asp:ListItem Value="Other" Text="Other" />
                    </asp:DropDownList>
                    <span class="error-msg" id="fbSubjectError"></span>
                </div>
                <div class="form-row">
                    <label>How do you rate our service? *</label>
                    <asp:RadioButtonList ID="rating" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="radio-list">
                        <asp:ListItem Value="5" Text="Excellent" />
                        <asp:ListItem Value="4" Text="Good" />
                        <asp:ListItem Value="3" Text="Average" />
                        <asp:ListItem Value="2" Text="Poor" />
                    </asp:RadioButtonList>
                    <span class="error-msg" id="ratingError"></span>
                </div>
                <div class="form-row">
                    <label for="fbMessage">Message *</label>
                    <asp:TextBox ID="fbMessage" runat="server" TextMode="MultiLine" Rows="5" MaxLength="500" />
                    <span id="charCounter">500 characters left</span>
                    <span class="error-msg" id="fbMessageError"></span>
                </div>
                <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="btn" OnClick="btnSend_Click" />
            </asp:Panel>

            <section class="card">
                <h2>What Customers Say</h2>
                <!-- RETRIEVE: the latest feedback from the database -->
                <ul id="feedbackList">
                    <asp:Repeater ID="rptFeedback" runat="server">
                        <ItemTemplate>
                            <li><strong><%# Server.HtmlEncode(Eval("Name").ToString()) %></strong>
                                (<%# RatingText(Eval("Rating")) %>): <%# Server.HtmlEncode(Eval("Message").ToString()) %></li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </section>
        </div>
    </main>
</asp:Content>
