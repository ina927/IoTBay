<%@ page import="iotbay.model.User" %>
<%@ page import="iotbay.model.Address" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  Address address = user.getAddress();
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Profile</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="login">
  <h1>Edit My Profile</h1>

  <form method="post" action="UpdateUserServlet">
    <label for="firstName">First Name:</label>
    <input type="text" id="firstName" name="firstName" value="<%= user.getFirstName() %>">

    <label for="lastName">Last Name:</label>
    <input type="text" id="lastName" name="lastName" value="<%= user.getLastName() %>">

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" readonly>

    <label for="contact">Contact:</label>
    <input type="text" id="contact" name="contact" value="<%= user.getContact() %>">

    <h3>Address</h3>

    <label for="address">Street:</label>
    <input type="text" id="address" name="address" value="<%= address != null ? address.getAddress() : "" %>">

    <label for="suburb">Suburb:</label>
    <input type="text" id="suburb" name="suburb" value="<%= address != null ? address.getSuburb() : "" %>">

    <label for="state">State:</label>
    <input type="text" id="state" name="state" value="<%= address != null ? address.getState() : "" %>">

    <label for="postcode">Postcode:</label>
    <input type="text" id="postcode" name="postcode" value="<%= address != null ? address.getPostcode() : "" %>">

    <input type="submit" value="Update Profile">
  </form>
</div>
</body>
</html>
