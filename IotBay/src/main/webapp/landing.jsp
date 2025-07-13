<%@ page contentType="text/html;charset=UTF-8" language="java" import="iotbay.model.User, iotbay.model.UserType" %>
<%
    session.removeAttribute("GuestMode");
%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Landing_Page</title>
    <link rel="stylesheet" href="style.css">
</head>
<style>
    h1 {
        text-align: center;
        color: white;
        margin-bottom: 50px;
        margin-top: 10px;
        font-size: 100px;
    }

    h3{
        text-align: center;
        color: white;
        margin-bottom: 50px;
        margin-top: 50px;
        font-size: 30px;
    }

    body {
        background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('a1.jpg');
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
    }

    .left.buttons {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 20px;
    }

    a.button {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        padding: 12px 0;
        width: 180px;
        border: 1px solid rgba(255, 255, 255, 0.5);
        border-radius: 30px;
        backdrop-filter: blur(10px);
        cursor: pointer;
        font-size: 16px;
        text-decoration: none;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .button:hover {
        transform: scale(1.05);
    }
</style>
<body>
<div class="content">
    <h1> Welcome to IoTBay</h1>
    <h3>Your #1 shop for IoT devices</h3>
    <div class="left buttons">
        <a href="login.jsp" class="button">Login</a>
        <a href="register.jsp" class="button">Register</a>
        <a href="BrowseProductServlet" class="button">Continue as Guest</a>
    </div>
</div>
<script>
    if (parent && parent.frames['navFrame']) {
        parent.frames['navFrame'].location.reload();
    }
</script>
</body>
</html>