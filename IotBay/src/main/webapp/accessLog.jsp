<%@ page import="java.util.List" %>
<%@ page import="iotbay.model.AccessLog" %>
<%@ page import="iotbay.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  List<AccessLog> logs = (List<AccessLog>) request.getAttribute("logs");
  String dateParam = request.getParameter("date");
  User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Access Log</title>
  <link rel="stylesheet" href="style.css">
  <style>
    table {
      border-collapse: collapse;
      margin-top: 20px;
      width: 100%;
      max-width: 800px;
    }

    th, td {
      border: 1px solid #999;
      padding: 12px;
      text-align: center;
      font-size: 14px;
    }

    th {
      background-color: #f2f2f2;
      font-weight: bold;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    .table-container {
      width: 100%;
      display: flex;
      justify-content: center;
    }

    .login {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 40px;
    }

    h1 {
      margin-bottom: 20px;
    }

    form {
      margin-bottom: 20px;
    }

    input[type="text"], input[type="submit"] {
      padding: 8px;
      margin-right: 10px;
    }

    button {
      padding: 10px 20px;
    }
  </style>
</head>
<body>
<div class="login">
  <h1>My Access Log</h1>
  <% String errorMessage = (String) request.getAttribute("errorMessage"); %>

  <% if (errorMessage != null) { %>
  <p style="color: red; font-weight: bold;"><%= errorMessage %></p>
  <% } %>

  <form method="get" action="AccessLogServlet">
    <label for="date">Search by Date:</label>
    <input type="text" id="date" name="date" value="<%= dateParam != null ? dateParam : "" %>" placeholder="YYYY-MM-DD">
    <input type="submit" value="Search" class="button">
  </form>

  <br>

  <table border="1" style="margin-top: 20px;">
    <tr>
      <th>Login Time</th>
      <th>Logout Time</th>
      <th>User Email</th>
    </tr>
    <% if (logs != null && !logs.isEmpty()) {
      for (AccessLog log : logs) {
    %>
    <tr>
      <td><%= log.getLoginTime() %></td>
      <td><%= log.getLogoutTime() != null ? log.getLogoutTime() : "Still Logged In" %></td>
      <td><%= currentUser != null ? currentUser.getEmail() : "Unknown" %></td>
    </tr>
    <% }} else { %>
    <tr>
      <td colspan="3">No records found.</td>
    </tr>
    <% } %>
  </table>

  <br>
</div>
</body>
</html>
