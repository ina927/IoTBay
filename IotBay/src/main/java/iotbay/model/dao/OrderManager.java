package iotbay.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import iotbay.model.OrderItem;
import iotbay.model.Order;

public class OrderManager {
    private Connection connection;

    public OrderManager(Connection connection) {
        this.connection = connection;
    }

    // CREATE OPERATIONS

    // Create a new order
    public void addOrder(Integer memberID, String orderDate, String orderStatus) throws SQLException {
        String query;
        if (memberID == null) {
            query = "INSERT INTO Orders (orderDate, orderStatus) VALUES (?, ?)";
        } else {
            query = "INSERT INTO Orders (memberID, orderDate, orderStatus) VALUES (?, ?, ?)";
        }

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            if (memberID == null) {
                stmt.setString(1, orderDate);
                stmt.setString(2, orderStatus);
            } else {
                stmt.setInt(1, memberID);
                stmt.setString(2, orderDate);
                stmt.setString(3, orderStatus);
            }
            stmt.executeUpdate();
        }
    }

    // Add item to the order
    public void addOrderItem(int orderID, int productID, int quantity) throws SQLException {
        String query = "INSERT INTO OrderItem (orderID, productID, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, orderID);
            stmt.setInt(2, productID);
            stmt.setInt(3, quantity);
            stmt.executeUpdate();
        }
    }


    // READ OPERATIONS

    // Retrieve the most recent order ID
    public int getLatestOrderID() throws SQLException {
        try (PreparedStatement stmt = connection.prepareStatement("SELECT MAX(orderID) FROM Orders");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    // Get a single order by its ID
    public Order getOrderByID(int orderID) throws SQLException {
        String sql = "SELECT orderID, memberID, orderDate, orderStatus FROM Orders WHERE orderID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int memberID = rs.getInt("memberID");
                String orderDate = rs.getString("orderDate");
                String orderStatus = rs.getString("orderStatus");
                return new Order(orderID, memberID, orderDate, orderStatus);
            }
        }
        return null;
    }

    // Get all items from the given Order
    public ArrayList<OrderItem> getOrderItemsByOrderID(int orderID) throws SQLException {
        ArrayList<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM OrderItem WHERE orderID = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(new OrderItem(
                        rs.getInt("orderID"),
                        rs.getInt("productID"),
                        rs.getInt("quantity")
                ));
            }
        }

        return items;
    }

    // Get all orders placed by a specific member
    public ArrayList<Order> getOrdersByMemberID(int memberID) throws SQLException {
        ArrayList<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE memberID = ? ORDER BY orderDate DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(new Order(
                        rs.getInt("orderID"),
                        rs.getInt("memberID"),
                        rs.getString("orderDate"),
                        rs.getString("orderStatus")
                ));
            }
        }

        return orders;
    }

    // Get all orders placed by a member on a specific date
    public ArrayList<Order> getOrdersByDateAndUser(String date, int userID) throws SQLException {
        ArrayList<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM Orders WHERE orderDate = ? AND memberID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, date);
            stmt.setInt(2, userID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("orderID"),
                        rs.getInt("memberID"),
                        rs.getString("orderDate"),
                        rs.getString("orderStatus")
                );
                orders.add(order);
            }
        }
        return orders;
    }

}
