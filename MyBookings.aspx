<%@ Page Title="DriveEasy Car Rental | My Bookings" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyBookings.aspx.cs" Inherits="MyBookingsPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .booking-actions .btn { padding: 6px 12px; font-size: 13px; margin: 2px 0; }
        .btn-red { background-color: #c0392b; border-color: #c0392b; }
        .btn-red:hover { background-color: #ffffff; color: #c0392b; }
        .check-list label { font-weight: normal; margin: 0 14px 0 4px; }
        .session-info { color: #6b7785; font-size: 13px; }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-title">
        <div class="container">
            <h1>My Bookings</h1>
            <p style="margin:0;">View, change or cancel your car bookings.</p>
        </div>
    </section>

    <main class="container page-section">
        <p class="session-info"><asp:Literal ID="litSession" runat="server" /></p>

        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <!-- UPDATE: edit form (shown when the user presses "Change") -->
        <asp:Panel ID="pnlEdit" runat="server" Visible="false" CssClass="card dashed-border">
            <h2>Change Booking #<asp:Literal ID="litEditId" runat="server" /></h2>
            <asp:HiddenField ID="hfBookingId" runat="server" />
            <p><strong>Car:</strong> <asp:Literal ID="litEditCar" runat="server" /></p>
            <div class="two-cols">
                <div class="form-row">
                    <label for="editBranch">Pick-up Branch</label>
                    <asp:DropDownList ID="editBranch" runat="server">
                        <asp:ListItem Value="Airport" Text="King Abdulaziz Airport" />
                        <asp:ListItem Value="Al-Rawdah" Text="Al-Rawdah District" />
                        <asp:ListItem Value="Al-Hamra" Text="Al-Hamra (Corniche)" />
                    </asp:DropDownList>
                </div>
                <div class="form-row">
                    <label for="editPickup">Pick-up Date</label>
                    <asp:TextBox ID="editPickup" runat="server" TextMode="Date" />
                </div>
                <div class="form-row">
                    <label for="editReturn">Return Date</label>
                    <asp:TextBox ID="editReturn" runat="server" TextMode="Date" />
                </div>
            </div>
            <div class="form-row">
                <label>Extras</label>
                <span class="check-list">
                    <asp:CheckBox ID="editGps" runat="server" Text="GPS (+20 SAR/day)" />
                    <asp:CheckBox ID="editSeat" runat="server" Text="Child seat (+15 SAR/day)" />
                    <asp:CheckBox ID="editInsurance" runat="server" Text="Full insurance (+40 SAR/day)" />
                </span>
            </div>
            <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancelEdit" runat="server" Text="Close" CssClass="btn btn-dark" OnClick="btnCancelEdit_Click" CausesValidation="false" />
        </asp:Panel>

        <!-- RETRIEVE: the bookings of the logged-in user -->
        <asp:Repeater ID="rptBookings" runat="server" OnItemCommand="rptBookings_ItemCommand" ClientIDMode="Predictable">
            <HeaderTemplate>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th scope="col">No.</th>
                            <th scope="col">Car</th>
                            <th scope="col">Branch</th>
                            <th scope="col">From</th>
                            <th scope="col">To</th>
                            <th scope="col">Extras</th>
                            <th scope="col">Payment</th>
                            <th scope="col">Total</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                        <tr>
                            <td>#<%# Eval("BookingId") %></td>
                            <td><%# Eval("CarName") %></td>
                            <td><%# Eval("Branch") %></td>
                            <td><%# Eval("PickupDate", "{0:dd/MM/yyyy}") %></td>
                            <td><%# Eval("ReturnDate", "{0:dd/MM/yyyy}") %></td>
                            <td><%# Eval("Extras").ToString() == "" ? "-" : Eval("Extras") %></td>
                            <td><%# Eval("PaymentMethod") %></td>
                            <td><strong><%# Eval("TotalPrice", "{0:0.##}") %> SAR</strong></td>
                            <td class="booking-actions">
                                <asp:Button ID="btnEdit" runat="server" Text="Change" CssClass="btn btn-dark"
                                    CommandName="EditBooking" CommandArgument='<%# Eval("BookingId") %>' />
                                <asp:Button ID="btnDelete" runat="server" Text="Cancel" CssClass="btn btn-red"
                                    CommandName="DeleteBooking" CommandArgument='<%# Eval("BookingId") %>'
                                    OnClientClick="return confirm('Are you sure you want to cancel this booking?');" />
                            </td>
                        </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="card text-center">
            <p>You do not have any bookings yet.</p>
            <a href="Cars.aspx" class="btn">Choose a car</a>
        </asp:Panel>
    </main>
</asp:Content>
