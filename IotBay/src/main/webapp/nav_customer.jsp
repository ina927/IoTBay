<%@ page import="iotbay.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    String userName = (user != null) ? user.getFirstName() : "Guest";
%>
<link rel="stylesheet" type="text/css" href="nav.css">
<link href="http://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">

<div class="header">
    <a href ="BrowseProductServlet" target="contentFrame"><img src="images/logo.png" alt="IoTBay Logo"></a>
    <div class="nav-links">
    <ul>
        <li><a href="BrowseProductServlet"target="contentFrame">PRODUCTS</a></li>
        <li><a href="OrderHistoryServlet" target="contentFrame">ORDERS</a></li>
        <li><a href="profile.jsp" target="contentFrame">PROFILE</a></li>
        <li><a href="AccessLogServlet" target="contentFrame">LOGS</a></li>
        <span>Welcome, <%= request.getAttribute("userName") %></span>
        <a href="logoutpage.jsp" class="nav-button override-link" target="contentFrame">Logout</a>
    </ul>
    </div>
</div>