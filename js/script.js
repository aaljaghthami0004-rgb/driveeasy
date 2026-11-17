/* =========================================================
   DriveEasy Car Rental - external JavaScript file
   Contents:
     1. Helper functions
     2. Common parts (all pages)
     3. Home page   - slideshow (dynamic picture & text)
     4. Cars page   - search, filter and sort
     5. Booking     - price calculation + form validation
     6. Contact     - feedback validation + dynamic list
     7. Login       - validation + show password
     8. Sign up     - validation + password strength
     9. About       - FAQ show / hide
   ========================================================= */


/* ---------- 1. Helper functions ---------- */

function byId(id) {
    return document.getElementById(id);
}

function isEmpty(value) {
    return value.trim() === "";
}

function isValidEmail(value) {
    var pattern = /^[^\s@]+@[^\s@]+\.[A-Za-z]{2,}$/;
    return pattern.test(value.trim());
}

// Saudi mobile number: 10 digits starting with 05
function isValidPhone(value) {
    var pattern = /^05[0-9]{8}$/;
    return pattern.test(value.trim());
}

// 8+ characters with an upper case letter, a lower case letter and a number
function isStrongPassword(value) {
    return value.length >= 8 && /[A-Z]/.test(value) && /[a-z]/.test(value) && /[0-9]/.test(value);
}

// letters and spaces only (English or Arabic), at least 3 characters
function isValidName(value) {
    var pattern = /^[A-Za-z؀-ۿ ]{3,}$/;
    return pattern.test(value.trim());
}

// shows an error under the field and changes its style
function showError(input, message) {
    input.classList.remove("valid");
    input.classList.add("invalid");
    var errorSpan = byId(input.id + "Error");
    if (errorSpan) {
        errorSpan.innerHTML = message;
    }
    return false;
}

// removes the error and marks the field as correct
function clearError(input) {
    input.classList.remove("invalid");
    input.classList.add("valid");
    var errorSpan = byId(input.id + "Error");
    if (errorSpan) {
        errorSpan.innerHTML = "";
    }
    return true;
}

// error for a group of radio buttons / one checkbox (no single input to colour)
function setGroupError(errorId, message) {
    var errorSpan = byId(errorId);
    if (errorSpan) {
        errorSpan.innerHTML = message;
    }
    return message === "";
}

// returns the value of the checked radio button in a group, or ""
function getCheckedValue(name) {
    var radios = document.getElementsByName(name);
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            return radios[i].value;
        }
    }
    return "";
}

// removes a group error as soon as the user picks an option
function clearGroupErrorOnChange(inputs, errorId) {
    for (var i = 0; i < inputs.length; i++) {
        inputs[i].addEventListener("change", function () {
            if (this.type === "radio" || this.checked) {
                setGroupError(errorId, "");
            }
        });
    }
}

// creates a message box (success) and puts it inside a container
function showMessage(containerId, text) {
    var container = byId(containerId);
    container.innerHTML = "";
    var box = document.createElement("div");
    box.className = "success-box";
    box.textContent = text;
    container.appendChild(box);
}

// removes the red / green style from all fields of a form
function resetFieldStyles(form) {
    var fields = form.querySelectorAll("input, select, textarea");
    for (var i = 0; i < fields.length; i++) {
        fields[i].classList.remove("invalid");
        fields[i].classList.remove("valid");
    }
    var errors = form.querySelectorAll(".error-msg");
    for (var j = 0; j < errors.length; j++) {
        errors[j].innerHTML = "";
    }
}

// date as yyyy-mm-dd (used for the min attribute of date inputs)
function formatDate(date) {
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (month < 10) { month = "0" + month; }
    if (day < 10) { day = "0" + day; }
    return date.getFullYear() + "-" + month + "-" + day;
}


/* ---------- 2. Common parts (all pages) ---------- */

function setFooterYear() {
    var yearSpan = byId("year");
    if (yearSpan) {
        yearSpan.innerHTML = new Date().getFullYear();
    }
}

// marks the menu link of the current page
function highlightCurrentPage() {
    var page = window.location.pathname.split("/").pop();
    if (page === "") {
        page = "index.html";
    }
    var links = document.querySelectorAll(".main-menu > ul > li > a");
    for (var i = 0; i < links.length; i++) {
        if (links[i].getAttribute("href") === page) {
            links[i].classList.add("active");
        }
    }
}

// dynamic element: "back to top" button created by JavaScript
function createBackToTopButton() {
    var button = document.createElement("button");
    button.type = "button";
    button.innerHTML = "&#8593;";
    button.title = "Back to top";
    button.style.position = "fixed";
    button.style.right = "20px";
    button.style.bottom = "20px";
    button.style.width = "45px";
    button.style.height = "45px";
    button.style.borderRadius = "50%";
    button.style.border = "none";
    button.style.backgroundColor = "#f28c28";
    button.style.color = "#ffffff";
    button.style.fontSize = "22px";
    button.style.cursor = "pointer";
    button.style.boxShadow = "0 4px 10px rgba(0,0,0,0.3)";
    button.style.zIndex = "300";
    button.style.display = "none";
    document.body.appendChild(button);

    button.addEventListener("click", function () {
        window.scrollTo(0, 0);
    });

    window.addEventListener("scroll", function () {
        if (window.pageYOffset > 300) {
            button.style.display = "block";
        } else {
            button.style.display = "none";
        }
    });
}

// dynamic elements: text size buttons (A- / A+) that change the CSS font size
function createTextSizeButtons() {
    var header = document.querySelector(".header-inner");
    if (!header) {
        return;
    }
    var box = document.createElement("div");
    box.style.display = "flex";
    box.style.gap = "6px";

    var sizes = [{ label: "A-", change: -1 }, { label: "A+", change: 1 }];
    for (var i = 0; i < sizes.length; i++) {
        var btn = document.createElement("button");
        btn.type = "button";
        btn.textContent = sizes[i].label;
        btn.title = "Change text size";
        btn.setAttribute("data-change", sizes[i].change);
        btn.style.padding = "4px 9px";
        btn.style.border = "1px solid #f28c28";
        btn.style.borderRadius = "4px";
        btn.style.backgroundColor = "transparent";
        btn.style.color = "#ffffff";
        btn.style.cursor = "pointer";
        btn.addEventListener("click", changeTextSize);
        box.appendChild(btn);
    }
    header.appendChild(box);
}

function changeTextSize(event) {
    var change = parseInt(event.target.getAttribute("data-change"), 10);
    var current = parseInt(window.getComputedStyle(document.body).fontSize, 10);
    var newSize = current + change;
    if (newSize >= 12 && newSize <= 20) {
        document.body.style.fontSize = newSize + "px";
    }
}


/* ---------- 3. Home page: slideshow (dynamic picture & text) ---------- */

var slides = [
    { image: "images/toyota-camry.svg",   title: "Toyota Camry 2025",   text: "Comfortable family sedan, perfect for trips inside Jeddah. From 180 SAR per day." },
    { image: "images/hyundai-accent.svg", title: "Hyundai Accent 2025", text: "Our cheapest car with low fuel use. Only 120 SAR per day." },
    { image: "images/nissan-patrol.svg",  title: "Nissan Patrol 2024",  text: "Big 7-seat SUV for families and desert trips. 450 SAR per day." },
    { image: "images/kia-sportage.svg",   title: "Kia Sportage 2025",   text: "Modern SUV with a large boot and smart features. 260 SAR per day." },
    { image: "images/ford-mustang.svg",   title: "Ford Mustang 2024",   text: "Enjoy the Corniche in a V8 sports car. 550 SAR per day." },
    { image: "images/toyota-hilux.svg",   title: "Toyota Hilux 2025",   text: "Strong pickup truck for work and moving. 220 SAR per day." }
];
var currentSlide = 0;
var slideTimer = null;

function showSlide(index) {
    // go round when we pass the first or the last slide
    if (index >= slides.length) {
        index = 0;
    } else if (index < 0) {
        index = slides.length - 1;
    }
    currentSlide = index;

    var image = byId("slideImage");
    image.src = slides[index].image;
    image.alt = slides[index].title;
    byId("slideTitle").innerHTML = slides[index].title;
    byId("slideText").innerHTML = slides[index].text;

    var dots = document.querySelectorAll("#slideDots .dot");
    for (var i = 0; i < dots.length; i++) {
        if (i === index) {
            dots[i].style.backgroundColor = "#f28c28";
        } else {
            dots[i].style.backgroundColor = "#c9d1db";
        }
    }
}

function startSlideTimer() {
    stopSlideTimer();
    slideTimer = setInterval(function () {
        showSlide(currentSlide + 1);
    }, 4000);
}

function stopSlideTimer() {
    if (slideTimer !== null) {
        clearInterval(slideTimer);
        slideTimer = null;
    }
}

function initSlideshow() {
    if (!byId("slideshow")) {
        return;
    }
    // create one dot for every slide
    var dotsBox = byId("slideDots");
    for (var i = 0; i < slides.length; i++) {
        var dot = document.createElement("span");
        dot.className = "dot";
        dot.title = slides[i].title;
        dot.setAttribute("data-index", i);
        dot.addEventListener("click", function () {
            showSlide(parseInt(this.getAttribute("data-index"), 10));
        });
        dotsBox.appendChild(dot);
    }

    byId("nextSlide").addEventListener("click", function () {
        showSlide(currentSlide + 1);
    });
    byId("prevSlide").addEventListener("click", function () {
        showSlide(currentSlide - 1);
    });

    // stop when the mouse is over the slideshow
    byId("slideshow").addEventListener("mouseover", stopSlideTimer);
    byId("slideshow").addEventListener("mouseout", startSlideTimer);

    showSlide(0);
    startSlideTimer();
}


/* ---------- 4. Cars page: search, filter and sort ---------- */

var sortAscending = true;

function filterCars() {
    var search = byId("searchBox").value.trim().toLowerCase();
    var category = byId("categoryFilter").value;
    var maxPrice = parseInt(byId("maxPrice").value, 10);
    byId("maxPriceValue").innerHTML = maxPrice;

    var rows = byId("carsTable").tBodies[0].rows;
    var shown = 0;

    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (row.id === "noResultRow") {
            continue;
        }
        var name = row.cells[1].textContent.toLowerCase();
        var rowCategory = row.getAttribute("data-category");
        var price = parseInt(row.getAttribute("data-price"), 10);

        var matchName = name.indexOf(search) !== -1;
        var matchCategory = (category === "all" || category === rowCategory);
        var matchPrice = price <= maxPrice;

        if (matchName && matchCategory && matchPrice) {
            row.style.display = "";
            shown++;
        } else {
            row.style.display = "none";
        }
    }

    byId("resultCount").innerHTML = shown;
    showNoResultRow(shown === 0);
}

// adds or removes a row that says "no cars found"
function showNoResultRow(show) {
    var tbody = byId("carsTable").tBodies[0];
    var oldRow = byId("noResultRow");
    if (show && !oldRow) {
        var row = document.createElement("tr");
        row.id = "noResultRow";
        var cell = document.createElement("td");
        cell.colSpan = 6;
        cell.style.textAlign = "center";
        cell.style.color = "#c0392b";
        cell.textContent = "No cars match your search. Try another name or a higher price.";
        row.appendChild(cell);
        tbody.appendChild(row);
    } else if (!show && oldRow) {
        tbody.removeChild(oldRow);
    }
}

function sortCarsByPrice() {
    var tbody = byId("carsTable").tBodies[0];
    var rows = [];
    for (var i = 0; i < tbody.rows.length; i++) {
        if (tbody.rows[i].id !== "noResultRow") {
            rows.push(tbody.rows[i]);
        }
    }
    rows.sort(function (a, b) {
        var diff = parseInt(a.getAttribute("data-price"), 10) - parseInt(b.getAttribute("data-price"), 10);
        return sortAscending ? diff : -diff;
    });
    for (var j = 0; j < rows.length; j++) {
        tbody.appendChild(rows[j]);   // appendChild moves the row to the end
    }
    byId("sortPrice").innerHTML = sortAscending ? "Sort by price &#8595;" : "Sort by price &#8593;";
    sortAscending = !sortAscending;
}

function initCarsPage() {
    if (!byId("carsTable") || !byId("searchBox")) {
        return;
    }
    byId("searchBox").addEventListener("keyup", filterCars);
    byId("categoryFilter").addEventListener("change", filterCars);
    byId("maxPrice").addEventListener("input", filterCars);
    byId("sortPrice").addEventListener("click", sortCarsByPrice);
    filterCars();
}


/* ---------- 5. Booking page: price calculation + validation ---------- */

function getRentalDays() {
    var pickup = byId("pickupDate").value;
    var ret = byId("returnDate").value;
    if (pickup === "" || ret === "") {
        return 0;
    }
    var diff = new Date(ret) - new Date(pickup);
    var days = Math.round(diff / (1000 * 60 * 60 * 24));
    return days > 0 ? days : 0;
}

function calculateTotal() {
    var list = byId("summaryList");
    list.innerHTML = "";

    var car = byId("car").value;
    var days = getRentalDays();

    if (car === "" || days === 0) {
        var info = document.createElement("li");
        info.textContent = "Choose a car and the dates to see the price.";
        list.appendChild(info);
        byId("totalPrice").innerHTML = "0";
        return 0;
    }

    var pricePerDay = carPrices[car];
    var total = pricePerDay * days;
    addSummaryLine(list, car + ": " + pricePerDay + " SAR x " + days + " day(s) = " + (pricePerDay * days) + " SAR");

    // add the price of every checked extra
    var extras = document.getElementsByName("extras");
    for (var i = 0; i < extras.length; i++) {
        if (extras[i].checked) {
            var extraPrice = parseInt(extras[i].getAttribute("data-price"), 10) * days;
            total += extraPrice;
            addSummaryLine(list, extras[i].value + ": " + extraPrice + " SAR");
        }
    }

    if (days >= 7) {
        var discount = Math.round(total * 0.10);
        total -= discount;
        addSummaryLine(list, "Weekly discount (10%): -" + discount + " SAR");
    }

    byId("totalPrice").innerHTML = total;
    return total;
}

function addSummaryLine(list, text) {
    var item = document.createElement("li");
    item.textContent = text;
    list.appendChild(item);
}

function validateBookingField(input) {
    var value = input.value;
    switch (input.id) {
        case "fullName":
            if (isEmpty(value)) { return showError(input, "Please enter your full name."); }
            if (!isValidName(value)) { return showError(input, "Name must be at least 3 letters (letters and spaces only)."); }
            break;
        case "phone":
            if (isEmpty(value)) { return showError(input, "Please enter your mobile number."); }
            if (!isValidPhone(value)) { return showError(input, "Mobile number must be 10 digits and start with 05."); }
            break;
        case "email":
            if (isEmpty(value)) { return showError(input, "Please enter your email."); }
            if (!isValidEmail(value)) { return showError(input, "Please enter a valid email, e.g. name@example.com"); }
            break;
        case "car":
            if (value === "") { return showError(input, "Please choose a car."); }
            break;
        case "branch":
            if (value === "") { return showError(input, "Please choose a pick-up branch."); }
            break;
        case "pickupDate":
            if (value === "") { return showError(input, "Please choose the pick-up date."); }
            if (value < formatDate(new Date())) { return showError(input, "Pick-up date cannot be in the past."); }
            break;
        case "returnDate":
            if (value === "") { return showError(input, "Please choose the return date."); }
            if (byId("pickupDate").value !== "" && value <= byId("pickupDate").value) {
                return showError(input, "Return date must be after the pick-up date.");
            }
            break;
    }
    return clearError(input);
}

function validateBookingForm() {
    var ids = ["fullName", "phone", "email", "car", "branch", "pickupDate", "returnDate"];
    var allValid = true;
    for (var i = 0; i < ids.length; i++) {
        if (!validateBookingField(byId(ids[i]))) {
            allValid = false;
        }
    }
    if (getCheckedValue("payment") === "") {
        allValid = setGroupError("paymentError", "Please choose a payment method.") && allValid;
    } else {
        setGroupError("paymentError", "");
    }
    if (!byId("terms").checked) {
        allValid = setGroupError("termsError", "You must agree to the rental policy.") && allValid;
    } else {
        setGroupError("termsError", "");
    }
    return allValid;
}

function initBookingPage() {
    var form = byId("bookingForm");
    if (!form || typeof carPrices === "undefined") {
        return;
    }

    // dates cannot be before today
    var today = formatDate(new Date());
    byId("pickupDate").min = today;
    byId("returnDate").min = today;

    // if the user came from "Book this car", select that car
    var params = new URLSearchParams(window.location.search);
    var carFromLink = params.get("car");
    if (carFromLink) {
        var options = byId("car").options;
        for (var i = 0; i < options.length; i++) {
            if (options[i].value === carFromLink) {
                byId("car").selectedIndex = i;
            }
        }
    }

    // check every field when the user leaves it or changes it
    var fields = ["fullName", "phone", "email", "car", "branch", "pickupDate", "returnDate"];
    for (var j = 0; j < fields.length; j++) {
        byId(fields[j]).addEventListener("blur", function () {
            validateBookingField(this);
        });
        byId(fields[j]).addEventListener("change", function () {
            validateBookingField(this);
        });
    }
    clearGroupErrorOnChange(document.getElementsByName("payment"), "paymentError");
    clearGroupErrorOnChange([byId("terms")], "termsError");

    // update the price when something changes
    var priceInputs = ["car", "pickupDate", "returnDate", "extraGps", "extraSeat", "extraInsurance"];
    for (var k = 0; k < priceInputs.length; k++) {
        byId(priceInputs[k]).addEventListener("change", calculateTotal);
    }
    byId("pickupDate").addEventListener("change", function () {
        byId("returnDate").min = this.value;
    });

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        if (validateBookingForm()) {
            var total = calculateTotal();
            var reference = "DE-" + Math.floor(100000 + Math.random() * 900000);
            showMessage("bookingMessage", "Thank you " + byId("fullName").value.trim() +
                "! Your booking is confirmed. Reference number: " + reference +
                ". Total price: " + total + " SAR.");
            window.scrollTo(0, 0);
        } else {
            byId("bookingMessage").innerHTML = "";
        }
    });

    form.addEventListener("reset", function () {
        resetFieldStyles(form);
        byId("bookingMessage").innerHTML = "";
        setTimeout(calculateTotal, 0);   // wait until the form is cleared
    });

    calculateTotal();
}


/* ---------- 6. Contact page: feedback ---------- */

var ratingNames = { "5": "Excellent", "4": "Good", "3": "Average", "2": "Poor" };

function updateCharCounter() {
    var message = byId("fbMessage");
    var left = 500 - message.value.length;
    var counter = byId("charCounter");
    counter.innerHTML = left + " characters left";
    if (left < 50) {
        counter.style.color = "#c0392b";
    } else {
        counter.style.color = "#6b7785";
    }
}

function validateFeedbackField(input) {
    var value = input.value;
    switch (input.id) {
        case "fbName":
            if (isEmpty(value)) { return showError(input, "Please enter your name."); }
            if (!isValidName(value)) { return showError(input, "Name must be at least 3 letters."); }
            break;
        case "fbEmail":
            if (isEmpty(value)) { return showError(input, "Please enter your email."); }
            if (!isValidEmail(value)) { return showError(input, "Please enter a valid email."); }
            break;
        case "fbSubject":
            if (value === "") { return showError(input, "Please choose a subject."); }
            break;
        case "fbMessage":
            if (value.trim().length < 10) { return showError(input, "Message must be at least 10 characters."); }
            break;
    }
    return clearError(input);
}

function initContactPage() {
    var form = byId("feedbackForm");
    if (!form) {
        return;
    }
    var ids = ["fbName", "fbEmail", "fbSubject", "fbMessage"];
    for (var i = 0; i < ids.length; i++) {
        byId(ids[i]).addEventListener("blur", function () {
            validateFeedbackField(this);
        });
    }
    byId("fbMessage").addEventListener("input", updateCharCounter);
    byId("fbSubject").addEventListener("change", function () {
        validateFeedbackField(this);
    });
    clearGroupErrorOnChange(document.getElementsByName("rating"), "ratingError");

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        var valid = true;
        for (var j = 0; j < ids.length; j++) {
            if (!validateFeedbackField(byId(ids[j]))) {
                valid = false;
            }
        }
        var rating = getCheckedValue("rating");
        if (rating === "") {
            valid = setGroupError("ratingError", "Please choose a rating.") && valid;
        } else {
            setGroupError("ratingError", "");
        }
        if (!valid) {
            return;
        }

        // dynamic element: add the new feedback to the top of the list
        var item = document.createElement("li");
        var nameTag = document.createElement("strong");
        nameTag.textContent = byId("fbName").value.trim();
        item.appendChild(nameTag);
        item.appendChild(document.createTextNode(" (" + ratingNames[rating] + "): " + byId("fbMessage").value.trim()));
        item.style.backgroundColor = "#fff3e6";
        var list = byId("feedbackList");
        list.insertBefore(item, list.firstChild);

        showMessage("feedbackMessage", "Thank you! Your feedback was sent successfully.");
        form.reset();
    });

    form.addEventListener("reset", function () {
        resetFieldStyles(form);
        setTimeout(updateCharCounter, 0);
    });
}


/* ---------- 7. Login page ---------- */

function initLoginPage() {
    var form = byId("loginForm");
    if (!form) {
        return;
    }
    byId("showPassword").addEventListener("change", function () {
        byId("loginPassword").type = this.checked ? "text" : "password";
    });

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        var user = byId("loginUser");
        var pass = byId("loginPassword");
        var valid = true;

        if (isEmpty(user.value)) {
            valid = showError(user, "Please enter your username or email.");
        } else if (user.value.trim().length < 3) {
            valid = showError(user, "Username must be at least 3 characters.");
        } else {
            clearError(user);
        }

        if (isEmpty(pass.value)) {
            valid = showError(pass, "Please enter your password.") && valid;
        } else if (pass.value.length < 8) {
            valid = showError(pass, "Password must be at least 8 characters.") && valid;
        } else {
            clearError(pass);
        }

        if (valid) {
            showMessage("loginMessage", "Welcome back, " + user.value.trim() + "! Taking you to the home page...");
            setTimeout(function () {
                window.location.href = "index.html";
            }, 2000);
        }
    });
}


/* ---------- 8. Sign up page ---------- */

function checkPasswordStrength() {
    var password = byId("suPassword").value;
    var rules = [/.{8,}/, /[A-Z]/, /[a-z]/, /[0-9]/, /[^A-Za-z0-9]/];
    var score = 0;
    for (var i = 0; i < rules.length; i++) {
        if (rules[i].test(password)) {
            score++;
        }
    }

    var bar = byId("strengthBar");
    var text = byId("strengthText");
    bar.style.width = (score * 20) + "%";

    if (password === "") {
        text.innerHTML = "";
    } else if (score <= 2) {
        bar.style.backgroundColor = "#c0392b";
        text.innerHTML = "Weak password";
        text.style.color = "#c0392b";
    } else if (score <= 4) {
        bar.style.backgroundColor = "#f39c12";
        text.innerHTML = "Medium password";
        text.style.color = "#d68910";
    } else {
        bar.style.backgroundColor = "#27ae60";
        text.innerHTML = "Strong password";
        text.style.color = "#27ae60";
    }
    return score;
}

function validateSignupField(input) {
    var value = input.value;
    switch (input.id) {
        case "suName":
            if (isEmpty(value)) { return showError(input, "Please enter your full name."); }
            if (!isValidName(value)) { return showError(input, "Name must be at least 3 letters (letters and spaces only)."); }
            break;
        case "suEmail":
            if (isEmpty(value)) { return showError(input, "Please enter your email."); }
            if (!isValidEmail(value)) { return showError(input, "Please enter a valid email."); }
            break;
        case "suPhone":
            if (isEmpty(value)) { return showError(input, "Please enter your mobile number."); }
            if (!isValidPhone(value)) { return showError(input, "Mobile number must be 10 digits and start with 05."); }
            break;
        case "suBirth":
            if (value === "") { return showError(input, "Please enter your date of birth."); }
            if (getAge(value) < 21) { return showError(input, "You must be at least 21 years old to rent a car."); }
            break;
        case "suCity":
            if (value === "") { return showError(input, "Please choose your city."); }
            break;
        case "suUser":
            if (isEmpty(value)) { return showError(input, "Please choose a username."); }
            if (!/^[A-Za-z0-9_]{4,20}$/.test(value)) { return showError(input, "Username: 4-20 letters, numbers or _ only."); }
            break;
        case "suPassword":
            if (value === "") { return showError(input, "Please enter a password."); }
            checkPasswordStrength();
            if (!isStrongPassword(value)) { return showError(input, "Use 8+ characters with upper case, lower case and a number."); }
            break;
        case "suConfirm":
            if (value === "") { return showError(input, "Please confirm your password."); }
            if (value !== byId("suPassword").value) { return showError(input, "Passwords do not match."); }
            break;
    }
    return clearError(input);
}

function getAge(birthText) {
    var birth = new Date(birthText);
    var today = new Date();
    var age = today.getFullYear() - birth.getFullYear();
    var monthDiff = today.getMonth() - birth.getMonth();
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
        age--;
    }
    return age;
}

function initSignupPage() {
    var form = byId("signupForm");
    if (!form) {
        return;
    }
    var ids = ["suName", "suEmail", "suPhone", "suBirth", "suCity", "suUser", "suPassword", "suConfirm"];
    for (var i = 0; i < ids.length; i++) {
        byId(ids[i]).addEventListener("blur", function () {
            validateSignupField(this);
        });
    }
    byId("suPassword").addEventListener("keyup", checkPasswordStrength);
    byId("suCity").addEventListener("change", function () {
        validateSignupField(this);
    });
    byId("suBirth").addEventListener("change", function () {
        validateSignupField(this);
    });
    clearGroupErrorOnChange(document.getElementsByName("gender"), "genderError");
    clearGroupErrorOnChange([byId("suTerms")], "suTermsError");

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        var valid = true;
        for (var j = 0; j < ids.length; j++) {
            if (!validateSignupField(byId(ids[j]))) {
                valid = false;
            }
        }
        if (getCheckedValue("gender") === "") {
            valid = setGroupError("genderError", "Please choose your gender.") && valid;
        } else {
            setGroupError("genderError", "");
        }
        if (!byId("suTerms").checked) {
            valid = setGroupError("suTermsError", "You must accept the rental policy.") && valid;
        } else {
            setGroupError("suTermsError", "");
        }

        if (valid) {
            showMessage("signupMessage", "Your account was created successfully, " +
                byId("suName").value.trim() + "! You can log in now.");
            window.scrollTo(0, 0);
            setTimeout(function () {
                window.location.href = "login.html";
            }, 3000);
        }
    });

    form.addEventListener("reset", function () {
        resetFieldStyles(form);
        setTimeout(checkPasswordStrength, 0);
    });
}


/* ---------- 9. About page: FAQ show / hide ---------- */

function initFaq() {
    var questions = document.querySelectorAll(".faq-question");
    for (var i = 0; i < questions.length; i++) {
        var answer = questions[i].nextElementSibling;
        answer.style.display = "none";
        questions[i].innerHTML = "+ " + questions[i].innerHTML;

        questions[i].addEventListener("click", function () {
            var ans = this.nextElementSibling;
            var text = this.innerHTML.substring(2);
            if (ans.style.display === "none") {
                ans.style.display = "block";
                this.innerHTML = "&minus; " + text;
                this.style.backgroundColor = "#fff3e6";
            } else {
                ans.style.display = "none";
                this.innerHTML = "+ " + text;
                this.style.backgroundColor = "#ffffff";
            }
        });
    }
}


/* ---------- start everything when the page is loaded ---------- */

window.addEventListener("load", function () {
    setFooterYear();
    highlightCurrentPage();
    createBackToTopButton();
    createTextSizeButtons();
    initSlideshow();
    initCarsPage();
    initBookingPage();
    initContactPage();
    initLoginPage();
    initSignupPage();
    initFaq();
});
