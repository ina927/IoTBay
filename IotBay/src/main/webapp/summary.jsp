<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="iotbay.model.Payment" %>
<%@ page import="iotbay.model.OrderItem" %>
<%@ page import="iotbay.model.Product" %>
<%@ page import="java.util.*" %>

<%
    Payment payment = (Payment) request.getAttribute("payment");
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("orderItems");
    Map<Integer, Product> productMap = (Map<Integer, Product>) request.getAttribute("productMap");
    double total = (request.getAttribute("orderTotal") != null) ? (Double) request.getAttribute("orderTotal") : 0.0;
%>

<html>
<head>
    <title>Order Summary</title>
    <link rel="stylesheet" href="main.css">
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

        .container {
            width: 90%;
            max-width: 1000px;
            background-color: white;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        h1, h2 {
            text-align: center;
            margin-bottom: 20px;
            color: black;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: black;
            color: white;
            font-size: 16px;
        }

        img {
            width: 80px;
            height: 80px;
            object-fit: contain;
        }

        p {
            font-size: 16px;
            margin-bottom: 10px;
        }

        .button {
            padding: 12px 30px;
            background-color: black;
            color: white;
            text-decoration: none;
            border-radius: 20px;
            font-size: 16px;
            display: inline-block;
            text-align: center;
            transition: background-color 0.3s;
        }

        .button:hover {
            background-color: #333;
        }
    </style>

</head>
<body>
<div class="container">
    <h1> Order Summary</h1>

    <h2>Order Info</h2>
    <p><strong>Order ID:</strong> <%= payment.getOrderId() %></p>
    <p><strong>Payment ID:</strong> <%= payment.getPaymentId() %></p>
    <p><strong>Order Date:</strong> <%= payment.getPaymentDate() %></p>

    <h2>Items</h2>
    <table>
        <tr>
            <th>Image</th>
            <th>Product</th>
            <th>Unit Price</th>
            <th>Qty</th>
            <th>Total</th>
        </tr>
        <%
            if (items != null && !items.isEmpty()) {
                for (OrderItem item : items) {
                    Product product = productMap.get(item.getProductID());
                    if (product == null) continue;
        %>
        <tr>
            <td><img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>"/></td>
            <td><%= product.getName() %></td>
            <td>$<%= String.format("%.2f", product.getPrice()) %></td>
            <td><%= item.getQuantity() %></td>
            <td>$<%= String.format("%.2f", product.getPrice() * item.getQuantity()) %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="5">No items found in this order.</td></tr>
        <% } %>
    </table>

    <p><strong>Total Amount:</strong> $<%= String.format("%.2f", total) %></p>

    <h2>Payment</h2>
    <p><strong>Payment Method:</strong> Card</p>
    <p><strong>Card Holder:</strong> <%= payment.getCardHolder() %></p>

    <h2>Delivery Address</h2>
    <p><%= payment.getAddress() %>, <%= payment.getSuburb() %>, <%= payment.getState() %> <%= payment.getPostcode() %></p>

    <a href="BrowseProductServlet" class="button">Return to Home</a>
</div>
</body>
</html>
