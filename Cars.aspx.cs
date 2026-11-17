using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class CarsPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // the drop-down menu sends the category in the query string, e.g. Cars.aspx?category=SUV
            string category = Request.QueryString["category"];
            if (!string.IsNullOrEmpty(category) && ddlCategory.Items.FindByValue(category) != null)
            {
                ddlCategory.SelectedValue = category;
            }
            SearchCars();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchCars();
    }

    protected void btnShowAll_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlCategory.SelectedValue = "all";
        ddlSort.SelectedValue = "asc";
        SearchCars();
    }

    // SEARCH / RETRIEVE: builds the SQL query from the form data (with parameters)
    private void SearchCars()
    {
        string sql = "SELECT CarId, Name, ModelYear, Category, Seats, Gear, PricePerDay, ImageFile FROM Cars WHERE 1 = 1";
        List<SqlParameter> parameters = new List<SqlParameter>();

        string name = txtSearch.Text.Trim();
        if (name != "")
        {
            sql += " AND Name LIKE @name";
            parameters.Add(Db.P("@name", "%" + name + "%"));
        }

        if (ddlCategory.SelectedValue != "all")
        {
            sql += " AND Category = @category";
            parameters.Add(Db.P("@category", ddlCategory.SelectedValue));
        }

        // the sort order comes from a fixed list, so it is safe to add it to the query
        sql += ddlSort.SelectedValue == "desc" ? " ORDER BY PricePerDay DESC" : " ORDER BY PricePerDay ASC";

        DataTable cars = Db.GetTable(sql, parameters.ToArray());
        rptCars.DataSource = cars;
        rptCars.DataBind();

        rptCars.Visible = cars.Rows.Count > 0;
        pnlNoResult.Visible = cars.Rows.Count == 0;
        litCount.Text = "Showing " + cars.Rows.Count + " car(s).";
    }
}
