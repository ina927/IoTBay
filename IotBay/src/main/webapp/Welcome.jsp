<%@ page contentType="text/html;charset=UTF-8" language="java" import="iotbay.model.User" %>

<%
    String pageSrc = request.getParameter("pageSrc");
    User newUser = (User) request.getAttribute("newUser");
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="welcome-box">
    <h1>Welcome, <%= (newUser != null) ? newUser.getFirstName() : (user != null ? user.getFirstName() : "Guest") %>!</h1>
    <br>

    <% if ("reg".equals(pageSrc) && newUser != null) { %>
    <p>Thank you for joining us.</p>
    <p>Please log in to continue.</p><br><br>
    <a href="login.jsp"><button class="button">Login</button></a>
    <% } else if (user != null) { %>
    <p>You are logged in to the account</p>
    <p>(<%= user.getEmail() %>)</p><br><br>
    <a href="BrowseProductServlet"><button class="button">Continue</button></a>
    <% } %>
</div>

</body>
</html>
