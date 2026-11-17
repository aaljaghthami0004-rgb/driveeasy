using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

/// <summary>
/// Server-side validation rules (the same rules as the JavaScript validation).
/// The server checks again because JavaScript can be turned off in the browser.
/// </summary>
public static class Validator
{
    public static bool IsValidName(string value)
    {
        return Regex.IsMatch(value.Trim(), @"^[A-Za-z؀-ۿ ]{3,}$");
    }

    public static bool IsValidEmail(string value)
    {
        return Regex.IsMatch(value.Trim(), @"^[^\s@]+@[^\s@]+\.[A-Za-z]{2,}$");
    }

    // Saudi mobile number: 10 digits starting with 05
    public static bool IsValidPhone(string value)
    {
        return Regex.IsMatch(value.Trim(), @"^05[0-9]{8}$");
    }

    public static bool IsValidUsername(string value)
    {
        return Regex.IsMatch(value, @"^[A-Za-z0-9_]{4,20}$");
    }

    // 8+ characters with an upper case letter, a lower case letter and a number
    public static bool IsStrongPassword(string value)
    {
        return value.Length >= 8
            && Regex.IsMatch(value, "[A-Z]")
            && Regex.IsMatch(value, "[a-z]")
            && Regex.IsMatch(value, "[0-9]");
    }

    public static int GetAge(DateTime birthDate)
    {
        DateTime today = DateTime.Today;
        int age = today.Year - birthDate.Year;
        if (birthDate.Date > today.AddYears(-age))
        {
            age--;
        }
        return age;
    }
}

/// <summary>
/// Password hashing: we never save the real password in the database.
/// </summary>
public static class PasswordHelper
{
    public static string Hash(string password)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes("DriveEasy#" + password));
            StringBuilder sb = new StringBuilder();
            foreach (byte b in bytes)
            {
                sb.Append(b.ToString("x2"));
            }
            return sb.ToString();
        }
    }
}

/// <summary>
/// Calculates the booking price (same rule as the JavaScript on the booking page).
/// </summary>
public static class PriceCalculator
{
    // price of every extra per day
    public static readonly Dictionary<string, decimal> ExtraPrices = new Dictionary<string, decimal>
    {
        { "GPS", 20m },
        { "Child Seat", 15m },
        { "Full Insurance", 40m }
    };

    public static int GetDays(DateTime pickup, DateTime ret)
    {
        return (int)(ret.Date - pickup.Date).TotalDays;
    }

    public static decimal Calculate(decimal pricePerDay, int days, string extras)
    {
        decimal total = pricePerDay * days;

        if (!string.IsNullOrEmpty(extras))
        {
            string[] list = extras.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string item in list)
            {
                string name = item.Trim();
                if (ExtraPrices.ContainsKey(name))
                {
                    total += ExtraPrices[name] * days;
                }
            }
        }

        // weekly rentals get 10% discount
        if (days >= 7)
        {
            total -= Math.Round(total * 0.10m, MidpointRounding.AwayFromZero);
        }
        return total;
    }
}
