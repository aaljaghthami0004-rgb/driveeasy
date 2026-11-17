<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // create the database and the tables the first time the website runs
        Db.EnsureDatabase();
    }

    void Session_Start(object sender, EventArgs e)
    {
        // session variable: time when this visit started
        Session["VisitStarted"] = DateTime.Now;
    }

</script>
