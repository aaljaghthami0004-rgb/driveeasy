/* =========================================================
   DriveEasy Car Rental - external JavaScript file
   ========================================================= */

// writes the current year in the footer
function setFooterYear() {
    var yearSpan = document.getElementById("year");
    if (yearSpan) {
        yearSpan.innerHTML = new Date().getFullYear();
    }
}

// marks the menu link of the page that is open now
function highlightCurrentPage() {
    var page = window.location.pathname.split("/").pop();
    if (page === "") {
        page = "index.html";
    }
    var links = document.querySelectorAll(".main-menu > ul > li > a");
    for (var i = 0; i < links.length; i++) {
        if (links[i].getAttribute("href") === page) {
            links[i].className = "active";
        }
    }
}

window.onload = function () {
    setFooterYear();
    highlightCurrentPage();
};
