<%@ Page Title="DriveEasy Car Rental | Our Cars" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cars.aspx.cs" Inherits="CarsPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: flex-end;
        }
        .filter-bar .form-row {
            flex: 1 1 200px;
            margin-bottom: 0;
        }
        .result-info { font-weight: bold; color: #16263a; }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-title">
        <div class="container">
            <h1>Our Cars</h1>
            <p style="margin:0;">Search our cars by name or category. The list comes from our database.</p>
        </div>
    </section>

    <main class="container page-section">
        <nav class="on-this-page" aria-label="On this page">
            <strong>Jump to:</strong>
            <ul>
                <li><a href="#all-cars">Search Cars</a></li>
                <li><a href="#requirements">Rental Requirements</a></li>
            </ul>
        </nav>

        <section id="all-cars">
            <h2>Search Cars</h2>

            <!-- search form: the data is sent to the server and used in the SQL query -->
            <asp:Panel ID="pnlSearch" runat="server" CssClass="card filter-bar" DefaultButton="btnSearch">
                <div class="form-row">
                    <label for="txtSearch">Car name</label>
                    <asp:TextBox ID="txtSearch" runat="server" MaxLength="50" placeholder="e.g. Toyota" />
                </div>
                <div class="form-row">
                    <label for="ddlCategory">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server">
                        <asp:ListItem Value="all" Text="All categories" />
                        <asp:ListItem Value="Sedan" Text="Sedan" />
                        <asp:ListItem Value="SUV" Text="SUV" />
                        <asp:ListItem Value="Sports" Text="Sports" />
                        <asp:ListItem Value="Pickup" Text="Pickup" />
                    </asp:DropDownList>
                </div>
                <div class="form-row">
                    <label for="ddlSort">Sort by</label>
                    <asp:DropDownList ID="ddlSort" runat="server">
                        <asp:ListItem Value="asc" Text="Price: low to high" />
                        <asp:ListItem Value="desc" Text="Price: high to low" />
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnShowAll" runat="server" Text="Show all" CssClass="btn btn-dark" OnClick="btnShowAll_Click" />
                </div>
            </asp:Panel>

            <p class="result-info"><asp:Literal ID="litCount" runat="server" /></p>

            <asp:Repeater ID="rptCars" runat="server">
                <HeaderTemplate>
                    <table class="data-table" id="carsTable">
                        <thead>
                            <tr>
                                <th scope="col">Photo</th>
                                <th scope="col">Car</th>
                                <th scope="col">Category</th>
                                <th scope="col">Seats</th>
                                <th scope="col">Gear</th>
                                <th scope="col">Price / Day</th>
                                <th scope="col">Book</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <td><img src="images/<%# Eval("ImageFile") %>" alt="<%# Eval("Name") %>" /></td>
                                <td><%# Eval("Name") %> <%# Eval("ModelYear") %></td>
                                <td><%# Eval("Category") %></td>
                                <td><%# Eval("Seats") %></td>
                                <td><%# Eval("Gear") %></td>
                                <td><strong><%# Eval("PricePerDay", "{0:0}") %> SAR</strong></td>
                                <td><a class="btn" href="Booking.aspx?carId=<%# Eval("CarId") %>">Book</a></td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoResult" runat="server" Visible="false" CssClass="card">
                <p style="color:#c0392b; margin:0;">No cars match your search. Try another name or category.</p>
            </asp:Panel>
        </section>

        <section id="requirements" class="card dashed-border">
            <h2>Rental Requirements</h2>
            <ol>
                <li>Valid Saudi driving licence or international driving permit.</li>
                <li>National ID, Iqama or passport.</li>
                <li>Minimum age is 21 years (25 years for sports cars).</li>
                <li>A credit card or Mada card for the deposit.</li>
            </ol>
        </section>
    </main>
</asp:Content>
