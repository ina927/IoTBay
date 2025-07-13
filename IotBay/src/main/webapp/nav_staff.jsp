<link rel="stylesheet" type="text/css" href="nav.css">
<link href="http://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">

<div class="header">
    <a href ="InventoryServlet" target="contentFrame"><img src="images/logo.png" alt="IoTBay Logo"></a>
    <div class="nav-links">
        <span>Welcome, <%= request.getAttribute("userName") %></span>
        <a href="logoutpage.jsp" target="contentFrame" class="nav-button override-link">Logout</a>
    </div>
</div>
