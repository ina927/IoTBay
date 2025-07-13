<%@ page import="iotbay.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Confirm Deletion</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="login">
  <h1>Confirm Account Deletion</h1>
  <p>Are you sure you want to delete your account?<br>This action <strong>cannot be undone</strong>.</p>

  <form action="DeleteUserServlet" method="post">
    <input type="submit" value="Yes, Delete My Account" style="background-color: red;">
  </form>

  <br>
  <a href="profile.jsp"><button>Cancel</button></a>
</div>
</body>
</html>
