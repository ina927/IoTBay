<%@ page import="iotbay.model.dao.DAO" %>
<%@ page import="iotbay.model.dao.InventoryManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>
<%@ page import="iotbay.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inventory Manager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #eeeeee;
        }
        h2, h3 {
            color: black;
        }

        .table-container {
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            min-width: 1000px;
            margin-top: 20px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 8px 10px;
            border: 1px solid #ddd;
            text-align: center;
            font-size: 14px;
        }
        th {
            background-color: #111;
            color: white;
        }
        input[type="text"] {
            padding: 8px;
            border-radius: 20px;
            border: 1px solid #ccc;
            text-align: left;
        }

        input[name="Name"] {
            width: 200px;
        }

        input[name="Category"] {
            width: 150px;
        }

        input[name="Description"] {
            width: 300px;
        }

        input[type="number"] {
            width: 100px;
            padding: 8px;
            border-radius: 20px;
            border: 1px solid #ccc;
            text-align: center;
        }
        button {
            padding: 8px 16px;
            width: 100px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            transition: transform 0.2s ease, background-color 0.2s ease;
        }
        button:hover {
            transform: scale(1.05);
            background-color: #222;
        }
        form {
            display: inline;
        }
        .search-container {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }
        .search-input {
            padding: 10px 15px;
            border-radius: 20px;
            border: 2px solid black;
            outline: none;
            font-size: 16px;
            width: 450px;
        }
        .search-input:focus {
            border-color: #444;
            transform: scale(1.03);
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
        .upload-container {
            border: 2px dashed #ccc;
            padding: 20px;
            width: 300px;
            border-radius: 12px;
            background-color: #fafafa;
        }
    </style>

    <%
        User user = (User) session.getAttribute("user");
        if ((user == null) || (user.getUserType() == null) || user.getUserType() != UserType.STAFF) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

</head>
<body>

<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<div style="color:red;"><%= error %></div>
<%
    }
%>

<h2>Inventory List</h2>

<!-- Add New Inventory Item Form -->
<h3>Add New Inventory Item</h3>
<form action="InventoryServlet" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add" />
    Product ID: <input type="text" name="productID" required />
    Name: <input type="text" name="name" required />
    Category: <input type="text" name="category" required />
    Description: <input type="text" name="description" required />
    Price: <input type="number" name="price" step="0.10" min="0" required />
    Stock: <input type="number" name="stockQuantity" min="0" required />
    Target: <input type="number" name="targetStockLevel" min="0" required />
    Restock Threshold: <input type="number" name="restockThreshold" min="0" required />

    <br/><br/>
    Image:
    <div class="upload-container">
        <input type="file" name="image" accept="image/*" required />
    </div>

    <br/>
    <button type="submit">Add Item</button>
</form>

<!-- Search Form -->
<div class="search-container">
    <form action="InventoryServlet" method="get">
        <input class="search-input" type="text" name="searchQuery" placeholder="Search by name / category" />
        <button class="search-button" type="submit">Search</button>
    </form>
</div>

<hr/>

<%
    List<InventoryItem> inventoryList = (List<InventoryItem>) request.getAttribute("inventoryList");
    if (inventoryList != null && !inventoryList.isEmpty()) {
%>
<div class="table-container">
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Category</th>
        <th>Description</th>
        <th>Price ($)</th>
        <th>Stock</th>
        <th>Target</th>
        <th>Restock Threshold</th>
        <th>Last Updated</th>
        <th>Image</th>
        <th colspan="3">Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (InventoryItem item : inventoryList) {
    %>
    <tr>
        <!-- UPDATE FORM -->
        <form action="InventoryServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="productID" value="<%= item.getProductID() %>" />
            <td><%= item.getProductID() %></td>
            <td><input type="text" name="name" value="<%= item.getName() %>" required /></td>
            <td><input type="text" name="category" value="<%= item.getCategory() %>" required /></td>
            <td><input type="text" name="description" value="<%= item.getDescription() %>" required /></td>
            <td><input type="number" step="0.10" name="price" value="<%= item.getPrice() %>" required /></td>
            <td><input type="number" name="stockQuantity" value="<%= item.getStockQuantity() %>" required /></td>
            <td><input type="number" name="targetStockLevel" value="<%= item.getTargetStockLevel() %>" required /></td>
            <td><input type="number" name="restockThreshold" value="<%= item.getRestockThreshold() %>" required /></td>
            <td><%= item.getLastUpdatedAt() %></td>
            <td>
                <img src="<%= request.getContextPath() + item.getImageUrl() %>" alt="Product Image" width="30" height="30"/><br/>
                <input type="file" name="image" accept="image/*" />
            </td>
            <td>
                <button type="submit">Update</button>
            </td>
        </form>

        <!-- DELETE FORM -->
        <form action="InventoryServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this item?');">
            <input type="hidden" name="action" value="delete" />
            <input type="hidden" name="productID" value="<%= item.getProductID() %>" />
            <td><button type="submit">Delete</button></td>
        </form>
    </tr>
    <% } %>
    </tbody>
</table>
</div>
<% } else { %>
<p>No inventory data available.</p>
<% } %>
</body>
</html>