<%@ Page Title="DriveEasy Car Rental | Book a Car" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Booking.aspx.cs" Inherits="BookingPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .booking-layout {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            align-items: flex-start;
        }
        .booking-layout .form-box {
            flex: 2 1 420px;
            margin: 0;
        }
        .summary-box {
            flex: 1 1 260px;
            position: sticky;
            top: 100px;
        }
        .summary-box ul { list-style: none; margin: 0 0 10px 0; }
        .summary-box li { padding: 5px 0; border-bottom: 1px solid #eef1f4; }
        .total-line { font-size: 20px; font-weight: bold; color: #f28c28; }
        .radio-list label { font-weight: normal; margin: 0 14px 0 4px; }
    </style>
    <!-- embedded JavaScript: car prices written by the server from the database -->
    <script>
        var carPrices = <asp:Literal ID="litCarPrices" runat="server" />;
    </script>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-title">
        <div class="container">
            <h1>Book a Car</h1>
            <p style="margin:0;">Fields marked with <span style="color:#ffb066;">*</span> are required.</p>
        </div>
    </section>

    <main class="container page-section">

        <!-- shown after the booking is saved -->
        <asp:Panel ID="pnlDone" runat="server" Visible="false" CssClass="card">
            <div class="success-box"><asp:Literal ID="litDone" runat="server" /></div>
            <a href="MyBookings.aspx" class="btn">Go to My Bookings</a>
            <a href="Booking.aspx" class="btn btn-dark">Book another car</a>
        </asp:Panel>

        <asp:Panel ID="pnlForm" runat="server" CssClass="booking-layout">
            <section class="card form-box">
                <h2>Booking Details</h2>
                <asp:Label ID="lblError" runat="server" CssClass="error-box" Visible="false" />

                <fieldset>
                    <legend>Customer Information</legend>
                    <div class="form-row">
                        <label for="fullName">Full Name *</label>
                        <asp:TextBox ID="fullName" runat="server" MaxLength="100" />
                        <span class="error-msg" id="fullNameError"></span>
                    </div>
                    <div class="two-cols">
                        <div class="form-row">
                            <label for="phone">Mobile Number *</label>
                            <asp:TextBox ID="phone" runat="server" TextMode="Phone" MaxLength="10" placeholder="05XXXXXXXX" />
                            <span class="error-msg" id="phoneError"></span>
                        </div>
                        <div class="form-row">
                            <label for="email">Email *</label>
                            <asp:TextBox ID="email" runat="server" TextMode="Email" MaxLength="100" />
                            <span class="error-msg" id="emailError"></span>
                        </div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>Car and Dates</legend>
                    <div class="two-cols">
                        <div class="form-row">
                            <label for="car">Car *</label>
                            <asp:DropDownList ID="car" runat="server" />
                            <span class="error-msg" id="carError"></span>
                        </div>
                        <div class="form-row">
                            <label for="branch">Pick-up Branch *</label>
                            <asp:DropDownList ID="branch" runat="server">
                                <asp:ListItem Value="" Text="-- Select a branch --" />
                                <asp:ListItem Value="Airport" Text="King Abdulaziz Airport" />
                                <asp:ListItem Value="Al-Rawdah" Text="Al-Rawdah District" />
                                <asp:ListItem Value="Al-Hamra" Text="Al-Hamra (Corniche)" />
                            </asp:DropDownList>
                            <span class="error-msg" id="branchError"></span>
                        </div>
                    </div>
                    <div class="two-cols">
                        <div class="form-row">
                            <label for="pickupDate">Pick-up Date *</label>
                            <asp:TextBox ID="pickupDate" runat="server" TextMode="Date" />
                            <span class="error-msg" id="pickupDateError"></span>
                        </div>
                        <div class="form-row">
                            <label for="returnDate">Return Date *</label>
                            <asp:TextBox ID="returnDate" runat="server" TextMode="Date" />
                            <span class="error-msg" id="returnDateError"></span>
                        </div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>Extras (per day)</legend>
                    <div class="form-row">
                        <asp:CheckBox ID="extraGps" runat="server" Text="GPS navigation (+20 SAR)" />
                        &nbsp;
                        <asp:CheckBox ID="extraSeat" runat="server" Text="Child seat (+15 SAR)" />
                        &nbsp;
                        <asp:CheckBox ID="extraInsurance" runat="server" Text="Full insurance (+40 SAR)" />
                    </div>
                </fieldset>

                <fieldset>
                    <legend>Payment Method *</legend>
                    <div class="form-row">
                        <asp:RadioButtonList ID="payment" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="radio-list">
                            <asp:ListItem Value="Credit Card" Text="Credit card" />
                            <asp:ListItem Value="Mada" Text="Mada" />
                            <asp:ListItem Value="Cash" Text="Cash at the branch" />
                        </asp:RadioButtonList>
                        <span class="error-msg" id="paymentError"></span>
                    </div>
                </fieldset>

                <div class="form-row">
                    <label for="notes">Notes (optional)</label>
                    <asp:TextBox ID="notes" runat="server" TextMode="MultiLine" Rows="3" MaxLength="300" />
                </div>

                <div class="form-row">
                    <asp:CheckBox ID="terms" runat="server" />
                    <label for="terms" class="inline-label">I agree to the <a href="About.aspx#policy">rental policy</a> *</label>
                    <span class="error-msg" id="termsError"></span>
                </div>

                <asp:Button ID="btnBook" runat="server" Text="Confirm Booking" CssClass="btn" OnClick="btnBook_Click" />
            </section>

            <aside class="card summary-box shadow-box">
                <h2>Booking Summary</h2>
                <ul id="summaryList">
                    <li>Choose a car and the dates to see the price.</li>
                </ul>
                <p class="total-line">Total: <span id="totalPrice">0</span> SAR</p>
                <p class="small-text">Weekly rentals (7 days or more) get 10% discount. The final price is calculated again on the server.</p>
            </aside>
        </asp:Panel>
    </main>
</asp:Content>
