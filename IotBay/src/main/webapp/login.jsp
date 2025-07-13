<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="iotbay.model.User, iotbay.model.UserType" %>
<%@ page import="iotbay.model.dao.DAO" %>
<%@ page import="iotbay.model.dao.UserManager" %>

<%
    String userType = request.getParameter("userType");
    String userId = request.getParameter("userId");
    String userPw = request.getParameter("userPw");
    String errorMsg = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LOGIN_PAGE</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="login">
    <h1>Login</h1>
    <br><br>
    <form method="post" action="LoginServlet">

        <!-- User Type -->
        <label for="userType">User Type</label>
        <select id="userType" name="userType" required>
            <option value="" disabled <%= userType == null ? "selected" : "" %>>Select User Type</option>
            <option value="customer" <%= "customer".equals(userType) ? "selected" : "" %>>Customer</option>
            <option value="staff" <%= "staff".equals(userType) ? "selected" : "" %>>Staff</option>
        </select>
        <br><br>

        <!-- Email -->
        <label for="userId">EMAIL</label>
        <input type="text" id="userId" name="userId" placeholder="Enter your email"
               value="<%= userId != null ? userId : "" %>" required>
        <br><br>

        <!-- Password -->
        <label for="userPw">PW</label>
        <input type="password" id="userPw" name="userPw" placeholder="Enter your password" required>
        <br><br>

        <button type="submit" name="login">Login</button>
    </form>

    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
    <p style="color:red;"><%= errorMsg %></p>
    <% } %>

    <p>Not a member? <a href="register.jsp">Sign up</a></p>
</div>

</body>
</html>
