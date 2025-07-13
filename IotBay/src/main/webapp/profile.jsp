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
  <title>User Profile</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="welcome-box">
  <h1>My Profile</h1>

  <p><strong>First Name:</strong> <%= user.getFirstName() %></p>
  <p><strong>Last Name:</strong> <%= user.getLastName() %></p>
  <p><strong>Email:</strong> <%= user.getEmail() %></p>
  <p><strong>Contact:</strong> <%= user.getContact() %></p>

  <h3 style="margin-top: 20px;">Address</h3>
  <% if (address != null) { %>
  <p><strong>Street:</strong> <%= address.getAddress() %></p>
  <p><strong>Suburb:</strong> <%= address.getSuburb() %></p>
  <p><strong>State:</strong> <%= address.getState() %></p>
  <p><strong>Postcode:</strong> <%= address.getPostcode() %></p>
  <% } else { %>
  <p>No address on file.</p>
  <% } %>

  <br>
  <a href="editProfile.jsp">
    <button>Edit Profile</button>
  </a>
  <a href="confirmDelete.jsp">
    <button style="margin-top: 10px; background-color: red;">Delete Account</button>
  </a>
</div>
</body>
</html>
