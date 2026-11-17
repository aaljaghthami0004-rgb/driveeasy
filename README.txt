DriveEasy Car Rental - ASP.NET Web Forms version (Assignment 3)
CPIS-358 - Abdullah Sayed Aljaghthami (1938732) & Alhasan Maan Shami (2343094)

HOW TO RUN
1. Open Visual Studio.
2. File > Open > Web Site... and choose this "DriveEasy" folder.
3. Right-click Default.aspx > Set As Start Page, then press F5 (or Ctrl+F5).
4. The first run creates the database "DriveEasyDB" in SQL Server LocalDB
   automatically (tables: Cars, Users, Bookings, Feedback + sample cars).

NOTES
- Visual Studio 2015 / 2017 / 2019 / 2022 use the LocalDB name (LocalDB)\MSSQLLocalDB (already set).
- Visual Studio 2012 uses (LocalDB)\v11.0 -> change it in Web.config (two connection strings),
  and change targetFramework="4.7.2" to "4.5" in Web.config (VS 2012 does not have .NET 4.7.2).
- Database.sql is the same database script, if you want to create it by hand.

WHERE EACH ASP.NET REQUIREMENT IS
- Receiving and processing form data : Signup.aspx, Login.aspx, Booking.aspx, Contact.aspx, Cars.aspx (search form)
- Insert   : Signup.aspx.cs (Users), Booking.aspx.cs (Bookings), Contact.aspx.cs (Feedback)
- Retrieve : Default.aspx.cs (prices), Cars.aspx.cs, MyBookings.aspx.cs, Contact.aspx.cs
- Search   : Cars.aspx.cs (by name + category, with SQL parameters)
- Update   : MyBookings.aspx.cs (change branch, dates and extras)
- Delete   : MyBookings.aspx.cs (cancel a booking)
- Cookies  : LastVisit (Default.aspx.cs), RememberUser (Login.aspx.cs), PreferredBranch (Booking.aspx.cs)
- Sessions : Login.aspx.cs (UserId, FullName, Username, LoginTime), Site.master.cs (menu),
             Booking/MyBookings (login required), Logout.aspx.cs (Session.Abandon), Global.asax (Session_Start)
