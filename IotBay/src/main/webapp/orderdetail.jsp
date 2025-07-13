<%@ page import="java.util.*" %>
<%@ page import="iotbay.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Order order = (Order) request.getAttribute("order");
  ArrayList<OrderItem> orderItems = (ArrayList<OrderItem>) request.getAttribute("orderItems");
  Map<Integer, Product> productMap = (Map<Integer, Product>) request.getAttribute("productMap");
  double orderTotal = (double) request.getAttribute("orderTotal");
%>

<html>
<head>
  <title>Order Details</title>
  <style>
    body {
      font-family: sans-serif;
      background-color: #dfdfdf;
      margin: 0;
      padding: 50px 0;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    h1 {
      text-align: center;
      margin-bottom: 30px;
    }

    table {
      width: 80%;
      max-width: 1000px;
      background-color: white;
      border-collapse: collapse;
      margin-bottom: 30px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    table th, table td {
      padding: 10px 8px;
      text-align: center;
      border-bottom: 1px solid #ccc;
      font-size: 15px;
    }

    table th {
      background-color: black;
      color: white;
      font-size: 18px;
    }
    .product-img {
      width: 80px;
      height: 80px;
      object-fit: cover;
    }

    .back-button {
      padding: 14px 30px;
      font-size: 18px;
      border-radius: 20px;
      cursor: pointer;
      width: 200px;
      margin: 10px auto;
      display: block;
      background-color: black;
      color: white;
      border: none;
      transition: transform 0.3s;
      text-align: center;
      text-decoration: none;
    }

    .back-button:hover {
      transform: scale(1.05);
    }

    .order-info {
      text-align: center;
      margin-bottom: 30px;
    }

    .order-info p {
      font-size: 18px;
      margin: 4px 0;
    }
  </style>
</head>
<body>
<!-- Order summary section -->
<div class="order-info">
  <h1>Order #<%= order.getOrderID() %></h1>
  <p><strong>Status:</strong> <%= order.getOrderStatus() %></p>
  <p><strong>Date:</strong> <%= order.getOrderDate() %></p>
</div>

<!-- Table of ordered items -->
<table>
  <tr>
    <th>Product</th>
    <th>Name</th>
    <th>Quantity</th>
    <th>Price</th>
    <th>Subtotal</th>
  </tr>

  <% for (OrderItem item : orderItems) {
    Product p = productMap.get(item.getProductID());
  %>
  <tr>
    <td><img src="<%= request.getContextPath() + p.getImageUrl() %>" alt="Product Image" class="product-img"></td>
    <td><%= p.getName() %></td>
    <td><%= item.getQuantity() %></td>
    <td>AUD $<%= String.format("%.2f", p.getPrice()) %></td>
    <td>AUD $<%= String.format("%.2f", item.getQuantity() * p.getPrice()) %></td>
  </tr>
  <% } %>

  <tr class="total-row">
    <td colspan="4" style="text-align: right;">Total</td>
    <td>AUD $<%= String.format("%.2f", orderTotal) %></td>
  </tr>
</table>

<!-- Back button to return to order history -->
<a href="OrderHistoryServlet" class="back-button">← Back to Order History</a>

</body>
</html>
