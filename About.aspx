<%@ Page Title="DriveEasy Car Rental | About Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- internal CSS (only for this page) -->
    <style>
        .values-list li {
            margin-bottom: 6px;
        }
        .team-table td:first-child {
            font-weight: bold;
        }
        .faq-question {
            display: block;
            width: 100%;
            text-align: left;
            background-color: #ffffff;
            border: 1px solid #d5dce4;
            border-radius: 6px;
            padding: 12px 15px;
            margin-bottom: 6px;
            font-family: inherit;
            font-size: 15px;
            font-weight: bold;
            color: #16263a;
            cursor: pointer;
        }
        .faq-answer {
            padding: 0 15px 10px 15px;
        }
    </style>
</asp:Content>

<asp:Content ID="BodyArea" ContentPlaceHolderID="MainContent" runat="server">

<section class="page-title">
    <div class="container">
        <h1>About DriveEasy</h1>
        <p style="margin:0;">A simple and honest way to rent a car in Jeddah.</p>
    </div>
</section>

<main class="container page-section">

    <nav class="on-this-page" aria-label="On this page">
        <strong>On this page:</strong>
        <ul>
            <li><a href="#who-we-are">Who We Are</a></li>
            <li><a href="#mission">Mission &amp; Values</a></li>
            <li><a href="#team">Project Team</a></li>
            <li><a href="#policy">Rental Policy</a></li>
            <li><a href="#faq">FAQ</a></li>
        </ul>
    </nav>

    <article id="who-we-are" class="card">
        <h2>Who We Are</h2>
        <p>
            DriveEasy is a car rental website for the city of Jeddah. We started the idea after we noticed
            how hard it is for visitors, students and families to compare rental offices and to know the
            real final price before they sign the contract.
        </p>
        <p>
            Our website shows every car with its photo, specifications and daily price, and lets the
            customer book online and pick up the car from one of our three branches.
        </p>
    </article>

    <section id="mission" class="card">
        <h2>Mission &amp; Values</h2>
        <p><strong>Our mission:</strong> to make renting a car fast, clear and safe for everyone in Jeddah.</p>
        <h3>Our values</h3>
        <ul class="values-list">
            <li><strong>Honesty</strong> &ndash; the price you see is the price you pay.</li>
            <li><strong>Quality</strong> &ndash; all cars are less than two years old and checked before every rental.</li>
            <li><strong>Customer care</strong> &ndash; support by phone and WhatsApp 24 hours a day.</li>
        </ul>
    </section>

    <section id="team">
        <h2>Project Team</h2>
        <table class="data-table team-table">
            <thead>
                <tr>
                    <th scope="col">Student Name</th>
                    <th scope="col">Student ID</th>
                    <th scope="col">Main Tasks</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Abdullah Sayed Aljaghthami</td>
                    <td>1938732</td>
                    <td>Home, Cars and Booking pages, JavaScript</td>
                </tr>
                <tr>
                    <td>Alhasan Maan Shami</td>
                    <td>2343094</td>
                    <td>About, Contact, Login and Sign Up pages, CSS style sheet</td>
                </tr>
            </tbody>
        </table>
        <p class="small-text">Course: CPIS-358 Internet Applications &amp; Web Programming &ndash; King Abdulaziz University, Fall 2026.</p>
    </section>

    <section id="policy" class="card dashed-border">
        <h2>Rental Policy</h2>
        <ol>
            <li>The minimum rental period is one day (24 hours).</li>
            <li>The car must be returned with the same fuel level.</li>
            <li>Late return of more than 3 hours is charged as one extra day.</li>
            <li>Free cancellation up to 24 hours before the pick-up time.</li>
            <li>Traffic violations during the rental period are paid by the customer.</li>
        </ol>
    </section>

    <section id="faq">
        <h2>Frequently Asked Questions</h2>
        <div class="faq-item">
            <button type="button" class="faq-question">Can I rent a car without a credit card?</button>
            <div class="faq-answer">
                <p>Yes. You can pay with Mada or cash at the branch, but a small deposit is needed.</p>
            </div>
        </div>
        <div class="faq-item">
            <button type="button" class="faq-question">Is insurance included in the price?</button>
            <div class="faq-answer">
                <p>Basic insurance is included. Full insurance can be added for 40 SAR per day.</p>
            </div>
        </div>
        <div class="faq-item">
            <button type="button" class="faq-question">Can I return the car to a different branch?</button>
            <div class="faq-answer">
                <p>Yes, inside Jeddah you can return the car to any of our three branches for free.</p>
            </div>
        </div>
    </section>

    <p class="text-center"><a href="#top">Back to top &#8593;</a></p>
</main>
</asp:Content>
