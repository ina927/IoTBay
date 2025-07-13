<link rel="stylesheet" type="text/css" href="nav.css">
<link href="http://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">

<div class="header">
    <a href ="InventoryServlet" target="contentFrame"><img src="images/logo.png" alt="IoTBay Logo"></a>
    <div class="nav-links">
        <ul>
            <li><a href="InventoryServlet" target="contentFrame">INVENTORY</a></li>
            <li><a href="systemAdmin.jsp" target="contentFrame">USERS</a></li>
            <span>Welcome, <%= request.getAttribute("userName") %></span>
            <a href="logoutpage.jsp" class="nav-button override-link" target="contentFrame">Logout</a>
        </ul>
    </div>
</div>
