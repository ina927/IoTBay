<%@ page contentType="text/html;charset=UTF-8" language="java" import="iotbay.model.User, iotbay.model.UserType" %>
<%@ page import="iotbay.model.Address" %>
<%@ page import="java.io.StringWriter, java.io.PrintWriter" %>
<%@ page import="iotbay.model.dao.DAO" %>

<%

    DAO dao = (DAO) session.getAttribute("dao");

    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String contact = request.getParameter("contact");
    String agree = request.getParameter("agree");

    String address = request.getParameter("address");
    String suburb = request.getParameter("suburb");
    String state = request.getParameter("state");
    String postcode = request.getParameter("postcode");
    String showAddress = request.getParameter("showAddress");

    boolean submitted = request.getMethod().equalsIgnoreCase("POST");
    boolean hasError = false;
    boolean requireAddress = "true".equals(showAddress);
    String errorAll = "";
    String errorPassword = "";
    String errorAgree = "";
    String errorAddress = "";

    if (submitted) {
        if (!password.equals(confirmPassword)) {
            errorPassword = "<p style='color:red;'>Passwords do not match.</p>";
            hasError = true;
        }

        if (agree == null) {
            errorAgree = "<p style='color:red;'>You must agree to the privacy policy.</p>";
            hasError = true;
        }

        if (requireAddress) {
            if (address == null || suburb == null || state == null || postcode == null ||
                    address.isEmpty() || suburb.isEmpty() || state.isEmpty() || postcode.isEmpty()) {
                errorAddress = "<p style='color:red;'>Please fill in all address fields or skip address.</p>";
                hasError = true;
            }
        }

        if (!hasError) {
            try {
                Address userAddress = new Address(address, suburb, state, postcode);
                User user = new User(UserType.CUSTOMER, firstName, lastName, email, password, contact, userAddress);
                user = dao.userManager().addUser(user);

                request.setAttribute("newUser", user);
                // not redirect to exist resigned user info in welcompage
                request.getRequestDispatcher("Welcome.jsp").forward(request, response);
//                session.setAttribute("loggedInUser", user);

            } catch (Exception e) {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                out.println("<pre>" + sw.toString() + "</pre>");
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        label {
            display: inline-block;
            width: 150px;
            text-align: right;
            margin-right: 10px;
        }
        input, select {
            width: 200px;
        }
    </style>
    <script>
        function showAddressFields() {
            document.getElementById("addressFields").style.display = "block";
            document.getElementById("addressLabelRow").style.display = "none";
            document.getElementById("showAddress").value = "true";
        }
        function skipAddressFields() {
            document.getElementById("addressFields").style.display = "none";
            document.getElementById("addressLabelRow").style.display = "block";
            document.getElementById("showAddress").value = "false";
        }
        function toggleAddressFields() {
            const fields = document.getElementById("addressFields");
            const toggleBtn = document.getElementById("toggleAddressBtn");
            const showAddressInput = document.getElementById("showAddress");

            if (fields.style.display === "none") {
                fields.style.display = "block";
                toggleBtn.innerText = "− Skip address";
                showAddressInput.value = "true";
            } else {
                fields.style.display = "none";
                toggleBtn.innerText = "+ Add address (optional)";
                showAddressInput.value = "false";
            }
        }
    </script>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="login">
    <h1>Register</h1>
    <br><br>
    <form name="regForm" method="POST" action="register.jsp">
        <input type="hidden" name="pageSrc" value="reg">
        <input type="hidden" name="showAddress" id="showAddress" value="<%= showAddress != null ? showAddress : "false" %>">

        <label for="firstName">First Name</label>
        <input type="text" name="firstName" id="firstName" placeholder="Enter your first name" value="<%= firstName != null ? firstName : "" %>" required><br><br>

        <label for="lastName">Last Name</label>
        <input type="text" name="lastName" id="lastName" placeholder="Enter your last name" value="<%= lastName != null ? lastName : "" %>" required><br><br>

        <label for="email">Email</label>
        <input type="email" name="email" id="email" placeholder="Enter your email" value="<%= email != null ? email : "" %>" required><br><br>

        <label for="password">Password</label>
        <input type="password" name="password" id="password" placeholder="Enter your password" required><br><br>

        <label for="confirmPassword">Confirm Password</label>
        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter your password" required><br>
        <%= errorPassword %>
        <br><br>

        <label for="contact">Contact Number</label>
        <input type="number" name="contact" id="contact" placeholder="Enter your contact number" value="<%= contact != null ? contact : "" %>" required><br><br>

        <div id="addressToggleRow">
            <label>Address</label>
            <button type="button" id="toggleAddressBtn" onclick="toggleAddressFields()">+ Add address (optional)</button>
            <br><br><br>
        </div>
        <%--        <div id="addressLabelRow" <%= "true".equals(showAddress) ? "style='display:none;'" : "" %>>--%>
        <%--            <label>Address</label>--%>
        <%--            <button type="button" onclick="showAddressFields()">+ Add address (optional)</button>--%>
        <%--        </div><br>--%>

        <div id="addressFields" <%= "true".equals(showAddress) ? "" : "style='display:none;'" %>>
            <%--            <button type="button" onclick="skipAddressFields()">Skip address</button>--%>

            <label for="address">Street Address</label>
            <input type="text" name="address" id="address" placeholder="Enter your street address" value="<%= address != null ? address : "" %>"><br><br>

            <label for="suburb">Suburb</label>
            <input type="text" name="suburb" id="suburb" placeholder="Enter your suburb" value="<%= suburb != null ? suburb : "" %>"><br><br>

            <label for="state">State</label>
            <select name="state" id="state">
                <option value="">-- Select State --</option>
                <option value="NSW" <%= "NSW".equals(state) ? "selected" : "" %>>NSW</option>
                <option value="VIC" <%= "VIC".equals(state) ? "selected" : "" %>>VIC</option>
                <option value="QLD" <%= "QLD".equals(state) ? "selected" : "" %>>QLD</option>
                <option value="WA" <%= "WA".equals(state) ? "selected" : "" %>>WA</option>
                <option value="SA" <%= "SA".equals(state) ? "selected" : "" %>>SA</option>
                <option value="TAS" <%= "TAS".equals(state) ? "selected" : "" %>>TAS</option>
                <option value="ACT" <%= "ACT".equals(state) ? "selected" : "" %>>ACT</option>
                <option value="NT" <%= "NT".equals(state) ? "selected" : "" %>>NT</option>
            </select><br><br>

            <label for="postcode">Postcode</label>
            <input type="text" name="postcode" id="postcode" placeholder="Enter your postcode" value="<%= postcode != null ? postcode : "" %>"><br><br>

        </div>
        <%= errorAddress %>

        <div class="agree-row">
            <input type="checkbox" name="agree" id="agree" <%= agree != null ? "checked" : "" %>>
            <label for="agree">I agree to the privacy policy.</label>
        </div>
        <%= errorAgree %>
        <br><br>

        <input type="submit" value="Register">
        <%= errorAll %>
    </form>
</div>
</body>
</html>