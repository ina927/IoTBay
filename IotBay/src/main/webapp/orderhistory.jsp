<%@ page import="java.util.*, iotbay.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ArrayList<Order> orderList = (ArrayList<Order>) request.getAttribute("orderList");
    Map<Integer, String> repItems = (Map<Integer, String>) request.getAttribute("representativeItemsMap");
    Map<Integer, Double> totals = (Map<Integer, Double>) request.getAttribute("orderTotalsMap");
%>

<html>
<head>
    <title>Order History</title>
    <style>
        .search-form {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin: 0 auto 40px auto;
            width: 600px;
        }

        .radio-group {
            display: flex;
            justify-content: center;
            gap: 40px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .input-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 15px;
        }

        .input-group input {
            padding: 10px;
            width: 300px;
            border-radius: 20px;
            border: 1px solid #aaa;
        }

        .button-group {
            display: flex;
            gap: 20px;
            justify-content: center;
        }

        .button-group button {
            padding: 10px 25px;
            border-radius: 20px;
            border: none;
            background-color: black;
            color: white;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .button-group button:hover {
            transform: scale(1.05);
        }

        body {
            font-family: sans-serif;
            background-color: #dfdfdf;
            padding: 50px;
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
        }

        table {
            width: 90%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 15px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: black;
            color: white;
        }

        tr:hover {
            background-color: #f0f0f0;
        }

        .view-button {
            padding: 8px 16px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .view-button:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<h1>📦 My Order History</h1>

<!-- Search and filter form -->
<div class="search-form">
    <form method="get" action="OrderHistoryServlet">
        <div class="radio-group">
            <label><input type="radio" name="searchType" value="id" checked onclick="toggleInput()"> Order ID</label>
            <label><input type="radio" name="searchType" value="date" onclick="toggleInput()"> Date</label>
        </div>

        <div class="input-group">
            <input type="number" name="orderID" id="orderIDInput" placeholder="Enter Order ID">
            <input type="date" name="orderDate" id="orderDateInput" style="display: none;">
        </div>

        <div class="button-group">
            <button type="submit" name="action" value="viewAll">View All</button>
            <button type="submit" name="action" value="search">Search</button>
        </div>
    </form>
</div>
<% if (orderList == null || orderList.isEmpty()) { %>
<p style="text-align: center;">No orders found.</p>
<% } else { %>

<!-- Order history table -->
<table>
    <thead>
    <tr>
        <th>Order ID</th>
        <th>Items</th>
        <th>Total Amount</th>
        <th>Order Date</th>
        <th>Status</th>
        <th>Details</th>
    </tr>
    </thead>
    <tbody>
    <% for (Order order : orderList) {
        int id = order.getOrderID();
    %>
    <tr>
        <td><%= id %></td>
        <td><%= repItems.get(id) %></td>
        <td>AUD $<%= String.format("%.2f", totals.get(id)) %></td>
        <td><%= order.getOrderDate() %></td>
        <td><%= order.getOrderStatus() %></td>
        <td>
            <a class="view-button" href="OrderDetailServlet?orderID=<%= id %>">View</a>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>
<% } %>
<!-- JS to toggle input fields based on radio selection -->
<script>
    function toggleInput() {
        const type = document.querySelector('input[name="searchType"]:checked').value;
        document.getElementById("orderIDInput").style.display = (type === "id") ? "inline-block" : "none";
        document.getElementById("orderDateInput").style.display = (type === "date") ? "inline-block" : "none";
    }
    window.onload = toggleInput;
</script>
</body>
</html>