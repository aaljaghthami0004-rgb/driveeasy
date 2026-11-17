-- =========================================================
-- DriveEasy Car Rental - database script (SQL Server / LocalDB)
-- CPIS-358 project - Abdullah Sayed Aljaghthami (1938732), Alhasan Maan Shami (2343094)
--
-- The website creates this database by itself the first time it runs
-- (App_Code/Db.cs -> EnsureDatabase). This file is the same script, so the
-- database can also be created by hand from SQL Server Object Explorer.
-- =========================================================

IF DB_ID('DriveEasyDB') IS NULL CREATE DATABASE DriveEasyDB;
GO

USE DriveEasyDB;
GO

IF OBJECT_ID('dbo.Cars') IS NULL
CREATE TABLE dbo.Cars (
    CarId        INT IDENTITY(1,1) PRIMARY KEY,
    Name         NVARCHAR(50)  NOT NULL,
    ModelYear    INT           NOT NULL,
    Category     NVARCHAR(20)  NOT NULL,
    Seats        INT           NOT NULL,
    Gear         NVARCHAR(20)  NOT NULL,
    PricePerDay  DECIMAL(10,2) NOT NULL,
    ImageFile    NVARCHAR(100) NOT NULL
);

IF OBJECT_ID('dbo.Users') IS NULL
CREATE TABLE dbo.Users (
    UserId       INT IDENTITY(1,1) PRIMARY KEY,
    FullName     NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(100) NOT NULL UNIQUE,
    Phone        NVARCHAR(10)  NOT NULL,
    Username     NVARCHAR(20)  NOT NULL UNIQUE,
    PasswordHash NVARCHAR(64)  NOT NULL,
    BirthDate    DATE          NOT NULL,
    City         NVARCHAR(30)  NOT NULL,
    Gender       NVARCHAR(10)  NOT NULL,
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.Bookings') IS NULL
CREATE TABLE dbo.Bookings (
    BookingId     INT IDENTITY(1,1) PRIMARY KEY,
    UserId        INT           NOT NULL REFERENCES dbo.Users(UserId),
    CarId         INT           NOT NULL REFERENCES dbo.Cars(CarId),
    Branch        NVARCHAR(30)  NOT NULL,
    PickupDate    DATE          NOT NULL,
    ReturnDate    DATE          NOT NULL,
    Extras        NVARCHAR(100) NOT NULL DEFAULT '',
    PaymentMethod NVARCHAR(20)  NOT NULL,
    Notes         NVARCHAR(300) NULL,
    TotalPrice    DECIMAL(10,2) NOT NULL,
    CreatedAt     DATETIME      NOT NULL DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.Feedback') IS NULL
CREATE TABLE dbo.Feedback (
    FeedbackId   INT IDENTITY(1,1) PRIMARY KEY,
    Name         NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(100) NOT NULL,
    Subject      NVARCHAR(30)  NOT NULL,
    Rating       INT           NOT NULL,
    Message      NVARCHAR(500) NOT NULL,
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT 1 FROM dbo.Cars)
INSERT INTO dbo.Cars (Name, ModelYear, Category, Seats, Gear, PricePerDay, ImageFile) VALUES
 (N'Toyota Camry',   2025, N'Sedan',  5, N'Automatic', 180, N'toyota-camry.svg'),
 (N'Hyundai Accent', 2025, N'Sedan',  5, N'Automatic', 120, N'hyundai-accent.svg'),
 (N'Nissan Patrol',  2024, N'SUV',    7, N'Automatic', 450, N'nissan-patrol.svg'),
 (N'Kia Sportage',   2025, N'SUV',    5, N'Automatic', 260, N'kia-sportage.svg'),
 (N'Ford Mustang',   2024, N'Sports', 4, N'Automatic', 550, N'ford-mustang.svg'),
 (N'Toyota Hilux',   2025, N'Pickup', 5, N'Manual',    220, N'toyota-hilux.svg');

IF NOT EXISTS (SELECT 1 FROM dbo.Feedback)
INSERT INTO dbo.Feedback (Name, Email, Subject, Rating, Message) VALUES
 (N'Saad', N'saad@example.com', N'Suggestion', 5, N'Booking took only three minutes and the car was very clean.'),
 (N'Mona', N'mona@example.com', N'Booking',    4, N'Good prices and friendly staff at the airport branch.');
GO
