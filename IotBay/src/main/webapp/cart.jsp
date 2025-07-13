<%@ page import="iotbay.model.CartItem" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="iotbay.model.dao.DAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  DAO dao = (DAO) session.getAttribute("dao");

  ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("cart");
  if (cart == null) {
    cart = new ArrayList<>();
  }
%>

<html>
<head>
  <title>Shopping Cart</title>
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
      padding: 15px;
      text-align: center;
      border-bottom: 1px solid #ccc;
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
    .action-buttons form {
      display: inline;
    }
    .total-section {
      width: 80%;
      max-width: 1000px;
      text-align: right;
      font-size: 20px;
      margin-bottom: 30px;
    }
    .button-group {
      text-align: center;
      margin-top: 30px;
    }
    .checkout-button, .continue-button {
      padding: 14px 30px;
      font-size: 18px;
      border-radius: 20px;
      cursor: pointer;
      transition: transform 0.3s;
      width: 200px;
      margin: 10px;
      display: inline-block;
    }
    .checkout-button {
      background-color: black;
      color: white;
      border: none;
    }
    .checkout-button:hover {
      transform: scale(1.05);
    }
    .continue-button {
      background-color: white;
      color: black;
      border: 2px solid black;
    }
    .continue-button:hover {
      transform: scale(1.05);
    }
  </style>
</head>
<body>

<h1>🛒 Your Cart</h1>

<!-- Table of cart items -->
<% if (cart.isEmpty()) { %>
<div style="text-align: center; margin-top: 50px;">
  <h2>No items in the cart</h2>
  <form action="BrowseProductServlet" method="get" style="margin-top: 30px;">
    <button type="submit" class="continue-button">Browse Items</button>
  </form>
</div>
<% } else { %><table>
  <thead>
  <tr>
    <th>Product</th>
    <th>Name</th>
    <th>Price</th>
    <th>Quantity</th>
    <th>Total</th>
    <th> </th>
  </tr>
  </thead>
  <tbody>
  <%
    double grandTotal = 0;
    for (CartItem item : cart) {
      double totalPrice = item.getProductPrice() * item.getQuantity();
      grandTotal += totalPrice;
  %>
  <tr>
    <td><img src="<%= request.getContextPath() + item.getImageUrl() %>" alt="Product Image" class="product-img"></td>
    <td><%= item.getProductName() %></td>
    <td>AUD $<%= String.format("%.2f", item.getProductPrice()) %></td>

    <!-- Quantity controls -->
    <td class="quantity-buttons">
      <form method="post" action="CartServlet" style="display:inline;">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="productID" value="<%= item.getProductID() %>">
        <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
        <button type="submit">-</button>
      </form>

      <span><%= item.getQuantity() %></span>

      <form method="post" action="CartServlet" style="display:inline;">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="productID" value="<%= item.getProductID() %>">
        <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
        <button type="submit">+</button>
      </form>
    </td>

    <!-- Subtotal and remove button -->
    <td>AUD $<%= String.format("%.2f", totalPrice) %></td>
    <td class="action-buttons">
      <form action="CartServlet" method="post" style="display:inline;">
        <input type="hidden" name="action" value="remove">
        <input type="hidden" name="productID" value="<%= item.getProductID() %>">
        <button type="submit">Remove</button>
      </form>
    </td>
  </tr>
  <% } %>
  </tbody>
</table>

<!-- Grand total display -->
<div class="total-section">
  <strong>Grand Total: AUD $<%= String.format("%.2f", grandTotal) %></strong>
</div>

<!-- Navigation buttons -->
<div class="button-group">
  <form action="BrowseProductServlet" method="get" style="display:inline;">
    <button type="submit" class="continue-button">Add More Items</button>
  </form>
  <form action="PaymentServlet" method="post" style="display:inline;">
    <button type="submit" class="checkout-button">Checkout</button>
  </form>
</div>
<% } %>
<script>
  <!-- JS to show stock error alert if applicable -->
  document.addEventListener("DOMContentLoaded", function () {
    <% if (Boolean.TRUE.equals(request.getAttribute("stockError"))) { %>
    alert("❗ Not enough stock for <%= request.getAttribute("productName") %>!\nOnly <%= request.getAttribute("stockQty") %> left.");
    <% } %>
  });
</script>
</body>
</html>
