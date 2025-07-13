package iotbay.model.dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import iotbay.model.Inventory;
import iotbay.model.InventoryItem;

public class InventoryManager {
    private Connection connection;

    public InventoryManager(Connection connection) {
        this.connection = connection;
    }

    // Fetch all inventory items from the database
    public List<InventoryItem> fetchAllInventory() throws SQLException {
        List<InventoryItem> inventoryList = new ArrayList<>();
        String query = "SELECT i.productID, p.name, p.category,p.description, p.price,p.imageUrl,i.stockQuantity, i.targetStockLevel,i.restockThreshold, i.lastUpdatedAt FROM Inventory i JOIN Product p ON i.productID = p.productID";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                InventoryItem item = new InventoryItem(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("category"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stockQuantity"),
                        rs.getInt("targetStockLevel"),
                        rs.getInt("restockThreshold"),
                        rs.getTimestamp("lastUpdatedAt").toLocalDateTime(),
                        rs.getString("imageUrl"));
                inventoryList.add(item);
            }
        }
        return inventoryList;
    }

    public int getStockQuantity(int productID) throws SQLException {
        String query = "SELECT stockQuantity FROM Inventory WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stockQuantity");
            }
        }
        return 0;
    }

    // CREATE - Add new inventory record
    public void addInventory(int productID, int stockQuantity, int targetStockLevel, int restockThreshold) throws SQLException {
        String query = "INSERT INTO Inventory (productID, stockQuantity, targetStockLevel, restockThreshold, lastUpdatedAt) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            stmt.setInt(2, stockQuantity);
            stmt.setInt(3, targetStockLevel);
            stmt.setInt(4, restockThreshold);
            stmt.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            stmt.executeUpdate();
        }
    }

    public void addProduct(int productID, String name, String category,String description, double price, String imageUrl) {
        String query = "INSERT INTO PRODUCT (productID, name, category,description, price, imageUrl) VALUES (?, ?, ?, ?, ?,?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            stmt.setString(2, name);
            stmt.setString(3, category);
            stmt.setString(4, description);
            stmt.setDouble(5, price);
            stmt.setString(6,imageUrl);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Or use logging
        }
    }

    // READ - Get Inventory Record by productID
    public Inventory getInventory(int productID) throws SQLException {
        String query = "SELECT * FROM Inventory WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Inventory(
                        rs.getInt("productID"),
                        rs.getInt("stockQuantity"),
                        rs.getInt("targetStockLevel"),
                        rs.getInt("restockThreshold"),
                        rs.getTimestamp("lastUpdatedAt").toLocalDateTime()
                );
            }
        }
        return null;
    }

    public List<InventoryItem> fetchInventoryWithProductDetails() throws SQLException {
        String query = "SELECT p.productID, p.name, p.category,p.description, p.price, i.stockQuantity, i.targetStockLevel, i.restockThreshold " +
                "FROM PRODUCT p " +
                "INNER JOIN INVENTORY i ON p.productID = i.productID";

        List<InventoryItem> inventoryList = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int productID = rs.getInt("productID");
                String name = rs.getString("name");
                String category = rs.getString("category");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stockQuantity = rs.getInt("stockQuantity");
                int targetStockLevel = rs.getInt("targetStockLevel");
                int restockThreshold = rs.getInt("restockThreshold");
                LocalDateTime lastUpdatedAt = rs.getTimestamp("lastUpdatedAt").toLocalDateTime();
                String imageUrl = rs.getString("imageUrl");
                InventoryItem item = new InventoryItem(productID, name, category,description, price, stockQuantity, targetStockLevel, restockThreshold, lastUpdatedAt, imageUrl);
                inventoryList.add(item);
            }
        }

        return inventoryList;
    }

    public List<InventoryItem> searchInventory(String searchQuery) throws SQLException {
        String query = "SELECT i.productID, p.name, p.category,p.description ,p.price,p.imageURL, " +
                "i.stockQuantity, i.targetStockLevel, i.restockThreshold, i.lastUpdatedAt " +
                "FROM Inventory i " +
                "JOIN Product p ON i.productID = p.productID " +
                "WHERE p.name LIKE ? or p.category LIKE ?";
        List<InventoryItem> inventoryList = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            String wildcardQuery = "%" + searchQuery + "%";
            stmt.setString(1, wildcardQuery);
            stmt.setString(2, wildcardQuery);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int productID = rs.getInt("productID");
                String name = rs.getString("name");
                String category = rs.getString("category");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stockQuantity = rs.getInt("stockQuantity");
                int targetStockLevel = rs.getInt("targetStockLevel");
                int restockThreshold = rs.getInt("restockThreshold");
                LocalDateTime lastUpdatedAt = rs.getTimestamp("lastUpdatedAt").toLocalDateTime();
                String imageUrl = rs.getString("imageUrl");

                InventoryItem item = new InventoryItem(productID, name, category,description, price, stockQuantity, targetStockLevel, restockThreshold, lastUpdatedAt, imageUrl);
                inventoryList.add(item);
            }
        }

        return inventoryList;
    }

    // UPDATE - Update stock quantity and last updated
    public void updateStockQuantity(int productID, int newQuantity) throws SQLException {
        String query = "UPDATE Inventory SET stockQuantity = ?, lastUpdatedAt = ? WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, newQuantity);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, productID);
            stmt.executeUpdate();
        }
    }

    // Update inventory record with new information
    public void updateInventory(int id, int stockQuantity, int targetStockLevel, int restockThreshold, LocalDateTime now) throws SQLException {
        String query = "UPDATE Inventory SET stockQuantity = ?, targetStockLevel = ?, restockThreshold = ?, lastUpdatedAt = ? WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, stockQuantity);
            stmt.setInt(2, targetStockLevel);
            stmt.setInt(3, restockThreshold);
            stmt.setTimestamp(4, Timestamp.valueOf(now));
            stmt.setInt(5, id);
            stmt.executeUpdate();
        }
    }

    public void updateProduct(int id, String name, String category, String description, double price, String imagePath) throws SQLException {
        String query = "UPDATE Product SET name = ?, category = ?, description = ?, price = ?, imageURL = ? WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, category);
            stmt.setString(3, description);
            stmt.setDouble(4, price);
            stmt.setString(5, imagePath);
            stmt.setInt(6, id);
            stmt.executeUpdate();
        }
    }

    public void sellProduct(int productId, int quantitySold) throws SQLException {
        int currentStock = getStockQuantity(productId);
        if (currentStock >= quantitySold) {
            int newStock = currentStock - quantitySold;
            updateStockQuantity(productId, newStock);
        }
    }

    // DELETE - Delete an inventory record
    public void deleteInventory(int productID) throws SQLException {
        String query = "DELETE FROM Inventory WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            stmt.executeUpdate();
        }
    }

    public void deleteProduct(int productID) throws SQLException {
        String query = "DELETE FROM Product WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            stmt.executeUpdate();
        }
    }

    public boolean existsProductName(String name) throws SQLException {
        String query = "SELECT 1 FROM Product WHERE name = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if exists
        }
    }

    public boolean existsProductID(int productID) throws SQLException {
        String query = "SELECT 1 FROM Product WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if exists
        }
    }

    public void updateProduct(int productID, String name, String category, String description, double price) throws SQLException {
        String query = "UPDATE Product SET name = ?, category = ?, description = ?, price = ? WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, category);
            stmt.setString(3, description);
            stmt.setDouble(4, price);
            stmt.setInt(5, productID);
            stmt.executeUpdate();
        }
    }
}