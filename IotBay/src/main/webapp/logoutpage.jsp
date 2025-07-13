<%@ page contentType="text/html;charset=UTF-8" language="java" import="iotbay.model.User" %>
<html>
<head>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("landing.jsp");
        return;
    }
    String userEmail = user.getEmail();
%>

<div class="logout-box">
    <h2>Logout Confirmation</h2>
    <br>
    <p>Are you sure you want to logout from</p>
    <p> <%= userEmail %>?</p>
    <br>

    <form method="get" action="LogoutServlet">
        <button type="submit" name="confirmLogout">YES</button>
        <button type="submit" name="cancelLogout" formaction="BrowseProductServlet">NO</button>
    </form>
</div>

</body>
</html>
