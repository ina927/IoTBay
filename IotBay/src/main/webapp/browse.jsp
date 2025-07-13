<%@ page import="java.util.ArrayList" %>
<%@ page import="iotbay.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Browse Products</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #eeeeee;
            margin: 0;
            padding: 0;
        }

        .header {
            position: relative;
            width: 100%;
            height: 200px;
            background: url('images/header2.png') no-repeat center center;
            background-size: cover;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: bold;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
            overflow: hidden;
            margin: 0;
            padding: 0;
        }

        .cart-link {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: white;
            color: black;
            padding: 14px 20px;
            border-radius: 30px;
            border: 3px solid black;
            font-size: 18px;
            text-decoration: none;
            z-index: 1000;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .cart-link:hover {
            background-color: black;
            color: white;
            transform: scale(1.05);
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            padding: 30px;
            width: 72%;
            align-items: center;
            margin: 0 auto;
        }

        .product-card {
            background-color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            min-height: 345px;
        }

        .product-card:hover {
            transform: scale(1.02);
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .product-card h3 {
            font-size: 16px;
            margin: 25px 0 5px 0;
            color: black;
            font-weight: 600;
            text-align: center;
        }

        .product-card .category {
            font-size: 14px;
            color: #888;
            margin-bottom: 5px;
            text-align: center;
        }

        .product-card .price {
            font-size: 16px;
            color: #333;
            font-weight: 500;
            text-align: center;
        }


        .category-button {
            background: none;
            border: none;
            font-size: 18px;
            color: #333;
            cursor: pointer;
            margin: 10px 15px;
            font-weight: 400;
            transition: all 0.2s ease;
        }

        .category-button:hover {
            font-weight: 600;
            color: black;
        }

        .search-container {
            display: flex;
            justify-content: center;
            margin: 40px 0;
        }

        .search-input {
            padding: 15px 25px;
            border-radius: 30px;
            border: 1px solid black;
            font-size: 18px;
            width: 650px;
            outline: none;
            transition: all 0.2s ease;
            padding-left: 30px;
        }

        .search-input:focus {
            border-color: #444;
            transform: scale(1.02);
        }

        .search-button {
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 10px 20px;
            margin-left: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s ease, background-color 0.2s ease;
        }

        .search-button:hover {
            transform: scale(1.05);
            background-color: #222;
        }

    </style>
</head>

<body>

<!-- Header section and fix-positioned Cart button-->
<div class="header">
    <h1>IoT Devices</h1>
    <%
        ArrayList<iotbay.model.CartItem> cart = (ArrayList<iotbay.model.CartItem>) session.getAttribute("cart");
        int cartCount = (cart != null) ? cart.size() : 0;
    %>
    <a class="cart-link" href="cart.jsp">🛒 Cart (<%= cartCount %>)</a>
</div>

<!-- Product search form -->
<div class="search-container" style="text-align: right; margin-bottom: 20px;">
    <form action="BrowseProductServlet" method="get">
        <input class="search-input" type="text" name="query" placeholder="Search by name" style="padding: 6px;" />
        <button class="search-button" type="submit">Search</button>
    </form>
</div>

<!-- Category filter buttons -->
<div style="text-align: center; margin: 20px 0;">
    <form action="BrowseProductServlet" method="get" style="display: inline;">
        <button class="category-button" type="submit" name="category" value="Temperature / Humidity / Air Pressure / Gas">Temperature / Humidity / Air Pressure / Gas</button>
    </form>
    <form action="BrowseProductServlet" method="get" style="display: inline;">
        <button class="category-button" type="submit" name="category" value="Motion Sensor">Motion Sensor</button>
    </form>
    <form action="BrowseProductServlet" method="get" style="display: inline;">
        <button class="category-button" type="submit" name="category" value="Navigation Modules">Navigation Modules</button>
    </form>
    <form action="BrowseProductServlet" method="get" style="display: inline;">
        <button class="category-button" type="submit" name="category" value="Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth">Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth</button>
    </form>
    <form action="BrowseProductServlet" method="get" style="display: inline;">
        <button class="category-button" type="submit" name="category" value="Other">Other</button>
    </form>
</div>


<!-- Product display grid -->
<div class="product-grid">
    <%
        ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("products");
        if (products != null) {
            for (Product product : products) {
    %>
    <a href="ProductDetailServlet?id=<%= product.getProductID() %>" style="text-decoration: none; color: inherit;">
        <div class="product-card">
            <img src="<%= request.getContextPath() + product.getImageUrl() %>" alt="Product Image">
            <h3><%= product.getName() %></h3>
            <p class="category"><%= product.getCategory() %></p>
            <p class="price">AUD $<%= String.format("%.2f", product.getPrice()) %></p>
        </div>
    </a>
    <%
            }
        }
    %>

    <%-- If user is in guest mode, force reload of nav frame to reflect state --%>
    <%
        Boolean isGuest = (Boolean) session.getAttribute("GuestMode");
        if (isGuest != null && isGuest) {
    %>
    <script>
        if (parent && parent.frames['navFrame']) {
            parent.frames['navFrame'].location.reload();
        }
    </script>
    <%
        }
    %>
</div>
</body>
</html>
