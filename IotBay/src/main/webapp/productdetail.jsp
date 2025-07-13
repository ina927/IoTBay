<%@ page import="iotbay.model.Product" %>
<%@ page import="iotbay.model.dao.DAO" %>
<%@ page import="iotbay.model.dao.InventoryManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Product product = (Product) request.getAttribute("product");
    DAO dao = (DAO) session.getAttribute("dao");

    int stockQuantity = 0;
    if (dao != null && product != null) {
        InventoryManager inventoryManager = dao.inventoryManager();
        try {
            stockQuantity = inventoryManager.getStockQuantity(product.getProductID());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<html>
<head>
    <title><%= product.getName() %> - Product Details</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #dfdfdf;
            margin: 0;
            padding: 15px 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .back-button-container {
            position: absolute;
            top: 60px;
            left: 310px;
        }

        .back-button {
            padding: 12px 24px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            display: inline-block;
            text-align: center;
            transition: transform 0.3s;
        }

        .back-button:hover {
            transform: scale(1.05);
        }
        .product-detail-container {
            display: flex;
            background-color: white;
            padding: 50px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
            gap: 80px;
            width: 80%;
            max-width: 1200px;
        }
        .product-image img {
            width: 500px;
            height: 500px;
            object-fit: cover;
        }
        .product-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .product-info h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .product-info .category {
            font-size: 14px;
            color: #888;
            margin-bottom: 20px;
        }
        .product-info .description {
            font-size: 16px;
            color: #555;
            margin-bottom: 20px;
        }
        .product-info .price {
            font-size: 24px;
            color: #333;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .quantity-selector {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .quantity-selector button {
            padding: 6px 14px;
            font-size: 18px;
            margin: 0 10px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
        }
        .quantity-selector input[type="text"] {
            width: 60px;
            text-align: center;
            font-size: 18px;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 6px;
        }
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 20px;
        }
        .action-buttons button {
            width: 100%;
            padding: 14px;
            font-size: 16px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            transition: transform 0.3s;
        }
        .action-buttons button:hover {
            transform: scale(1.05);
        }
        .stock-warning {
            margin-top: 20px;
            font-size: 16px;
            color: red;
        }

        .price-and-quantity {
            display: flex;
            align-items: center;
            gap: 90px;
            margin-top: 15px;
        }

        .price {
            font-size: 24px;
            color: #333;
            font-weight: bold;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
        }

        .quantity-selector button {
            padding: 6px 14px;
            font-size: 18px;
            margin: 0 5px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
        }

        .quantity-selector input[type="text"] {
            width: 50px;
            text-align: center;
            font-size: 18px;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 6px;
        }
    </style>
</head>
<body>
<%
    // attribute from CartServlet to show error alert
    Boolean stockError = (Boolean) request.getAttribute("stockError");
    Boolean success = (Boolean) request.getAttribute("success");
    Integer stockQty = (Integer) request.getAttribute("stockQty");
%>

<!-- Hidden input to store stock value for JS logic -->
<input type="hidden" id="stockQuantity" value="<%= stockQuantity %>">

<!-- Back to product list -->
<div class="back-button-container">
    <a class="back-button" href="BrowseProductServlet">← Back</a>
</div>

<!-- Main product detail display retrieved from ProductDetailServlet-->
<div class="product-detail-container">
    <div class="product-image">
        <img src="<%= request.getContextPath() + product.getImageUrl() %>" alt="Product Image">
    </div>
    <div class="product-info">
        <h1><%= product.getName() %></h1>
        <div class="category"><%= product.getCategory() %></div>
        <div class="description"><%= product.getDescription() %></div>
        <div class="price-and-quantity">
            <div class="price">AUD $<%= String.format("%.2f", product.getPrice()) %></div>
            <div class="quantity-selector">
                <button type="button" onclick="decreaseQuantity()">-</button>
                <input type="text" id="quantity" value="1" readonly>
                <button type="button" onclick="increaseQuantity()">+</button>
            </div>
        </div>

        <!-- Show warning if stock is low -->
        <% if (stockQuantity > 0 && stockQuantity <= 10) { %>
        <div class="stock-warning">
            * Only <%= stockQuantity %> items left in stock
        </div>
        <% } %>

        <!-- Add to Cart and Buy Now actions -->
        <div class="action-buttons">
            <button type="button" onclick="addToCart()">🛒 Add to Cart</button>
            <button type="button" onclick="buyNow()">⚡ Buy Now</button>

            <form id="addToCartForm" action="CartServlet" method="post" style="display: none;">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productID" value="<%= product.getProductID() %>">
                <input type="hidden" name="productName" value="<%= product.getName() %>">
                <input type="hidden" name="productPrice" value="<%= product.getPrice() %>">
                <input type="hidden" name="imageUrl" value="<%= product.getImageUrl() %>">
                <input type="hidden" name="quantity" id="formQuantity" value="1">
                <input type="hidden" name="source" id="formSource" value="">
            </form>
        </div>
    </div>
</div>

<!-- JavaScript for quantity adjustment and form submission -->
<script>
    function decreaseQuantity() {
        var quantityInput = document.getElementById('quantity');
        var value = parseInt(quantityInput.value);
        if (value > 1) {
            quantityInput.value = value - 1;
        }
    }

    function increaseQuantity() {
        var quantityInput = document.getElementById('quantity');
        quantityInput.value = parseInt(quantityInput.value) + 1;
    }

    function addToCart() {
        document.getElementById('formQuantity').value = document.getElementById('quantity').value;
        document.getElementById('formSource').value = "add";
        document.getElementById('addToCartForm').submit();
    }

    function buyNow() {
        document.getElementById('formQuantity').value = document.getElementById('quantity').value;
        document.getElementById('formSource').value = "buy";
        document.getElementById('addToCartForm').submit();
    }

    document.addEventListener("DOMContentLoaded", function () {
        <% if (Boolean.TRUE.equals(request.getAttribute("stockError"))) { %>
        alert("❗ Not enough stock! Only <%= request.getAttribute("stockQty") %> left.");
        <% } else if (Boolean.TRUE.equals(request.getAttribute("success"))) { %>
        if (confirm("🛒 Added to cart!\nWould you like to view your cart?")) {
            window.location.href = "cart.jsp";
        } else {
            window.location.href = "BrowseProductServlet";
        }
        <% } %>
    });

</script>

</body>
</html>