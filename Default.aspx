<%@ Page Title="DriveEasy Car Rental | Home" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="DefaultPage" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- internal CSS (only for this page) -->
    <style>
        .steps li { margin-bottom: 8px; }
        .benefit-list li { margin-bottom: 6px; }
        #greeting { font-weight: bold; color: #ffd9b3; }
        .visit-info {
            background-color: #eaf4ff;
            border: 1px solid #9cc3eb;
            border-radius: 6px;
            padding: 10px 15px;
            margin-bottom: 20px;
        }
        .slideshow { text-align: center; }
        .slideshow img {
            width: 100%;
            max-width: 520px;
            border-radius: 10px;
            border: 3px solid #f28c28;
        }
        .slide-controls button { margin: 0 5px; }
        .dots { margin-top: 10px; }
        .dot {
            display: inline-block;
            width: 13px;
            height: 13px;
            margin: 0 4px;
            border-radius: 50%;
            background-color: #c9d1db;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">

    <!-- banner made of three layers (picture, overlay, text) using z-index -->
    <section class="banner">
        <img class="banner-img" src="images/hero.svg" alt="A rental car driving in Jeddah" />
        <div class="banner-overlay"></div>
        <div class="container banner-text">
            <h1>Rent Your Car in Minutes</h1>
            <p>DriveEasy lets you compare cars, see clear daily prices and book your rental car in Jeddah online.</p>
            <p id="greeting">Welcome to DriveEasy!</p>
            <a href="Booking.aspx" class="btn">Book Now</a>
            <a href="Cars.aspx" class="btn btn-dark">View Our Cars</a>
        </div>
    </section>

    <!-- embedded JavaScript: greeting changes with the time of the day -->
    <script>
        var hour = new Date().getHours();
        var greetingText;
        if (hour < 12) {
            greetingText = "Good morning! Start your day with the right car.";
        } else if (hour < 18) {
            greetingText = "Good afternoon! Your next car is a few clicks away.";
        } else {
            greetingText = "Good evening! Book tonight and pick up your car tomorrow.";
        }
        document.getElementById("greeting").innerHTML = greetingText;
    </script>

    <main class="container page-section">

        <!-- message built on the server from the session and the "LastVisit" cookie -->
        <div class="visit-info">
            <asp:Literal ID="litVisit" runat="server" />
        </div>

        <nav class="on-this-page" aria-label="On this page">
            <strong>On this page:</strong>
            <ul>
                <li><a href="#idea">Our Idea</a></li>
                <li><a href="#benefits">Benefits</a></li>
                <li><a href="#how-it-works">How It Works</a></li>
                <li><a href="#prices">Prices</a></li>
                <li><a href="#featured">Featured Cars</a></li>
            </ul>
        </nav>

        <article id="idea" class="card">
            <h2>The Idea of DriveEasy</h2>
            <p>
                Renting a car in Jeddah usually means calling many rental offices, waiting in long queues
                and asking again and again about the price, the insurance and the car documents. Visitors
                who land at the airport and people whose own car is at the workshop often lose hours before
                they get a car, and many of them find extra fees only when they return it.
            </p>
            <p>
                <span class="highlight">DriveEasy</span> solves this by putting everything online in one place.
                The customer can see all available cars with real photos, compare the daily prices,
                choose the pick-up branch and the dates, add extras like GPS or a child seat, and see the
                total price before booking. The car is ready when the customer arrives at the branch.
            </p>
        </article>

        <section id="benefits" class="card">
            <h2>Why Rent With Us?</h2>
            <ul class="benefit-list">
                <li><strong>Clear prices:</strong> the total cost is shown before you confirm, with no hidden fees.</li>
                <li><strong>Saves time:</strong> book from home in less than five minutes.</li>
                <li><strong>Many choices:</strong> sedans, SUVs, sports cars and pickup trucks.</li>
                <li><strong>Three branches:</strong>
                    <ul>
                        <li>King Abdulaziz International Airport</li>
                        <li>Al-Rawdah District</li>
                        <li>Al-Hamra District (Corniche)</li>
                    </ul>
                </li>
                <li><strong>Full insurance option</strong> and 24/7 road assistance.</li>
            </ul>
        </section>

        <section id="how-it-works" class="card">
            <h2>How It Works</h2>
            <ol class="steps">
                <li>Create a free account from the <a href="Signup.aspx">Sign Up</a> page.</li>
                <li>Browse <a href="Cars.aspx">our cars</a> and choose the one you like.</li>
                <li>Fill the <a href="Booking.aspx">booking form</a> with the dates and the branch.</li>
                <li>Manage or cancel your booking from <a href="MyBookings.aspx">My Bookings</a>.</li>
            </ol>
        </section>

        <section id="prices">
            <h2>Daily Prices</h2>
            <!-- this table is filled from the Cars table in the database -->
            <asp:Repeater ID="rptPrices" runat="server">
                <HeaderTemplate>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th scope="col">Car</th>
                                <th scope="col">Category</th>
                                <th scope="col">Price / Day</th>
                                <th scope="col">Price / Week (10% off)</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <td><%# Eval("Name") %> <%# Eval("ModelYear") %></td>
                                <td><%# Eval("Category") %></td>
                                <td><%# Eval("PricePerDay", "{0:0}") %> SAR</td>
                                <td><%# Eval("WeekPrice", "{0:N0}") %> SAR</td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </section>

        <section id="featured">
            <h2>Featured Cars</h2>
            <!-- dynamic picture and text (changed by JavaScript) -->
            <div class="card slideshow" id="slideshow">
                <img id="slideImage" src="images/toyota-camry.svg" alt="Toyota Camry 2025" />
                <h3 id="slideTitle">Toyota Camry 2025</h3>
                <p id="slideText">Comfortable family sedan, perfect for trips inside Jeddah. From 180 SAR per day.</p>
                <div class="slide-controls">
                    <button type="button" class="btn btn-dark" id="prevSlide">&#8249; Previous</button>
                    <button type="button" class="btn btn-dark" id="nextSlide">Next &#8250;</button>
                </div>
                <div class="dots" id="slideDots"></div>
            </div>
        </section>

        <p class="text-center"><a href="#top">Back to top &#8593;</a></p>
    </main>
</asp:Content>
