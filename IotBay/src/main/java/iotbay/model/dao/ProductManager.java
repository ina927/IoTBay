package iotbay.model.dao;
import iotbay.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ProductManager {
    private Connection connection;
    public ProductManager(Connection connection){
        this.connection = connection;
    }

    public ArrayList<Product> fetchAllProducts() throws SQLException {
        ArrayList<Product> products = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement("SELECT * FROM Product");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("productID"));
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("category"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setImageUrl(rs.getString("imageURL"));

                products.add(product);
            }
        }
        return products;
    }

    public Product fetchProductById(int productID) throws SQLException {
        String query = "SELECT * FROM Product WHERE productID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Product(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("category"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("imageURL")
                );
            }
        }
        return null;
    }

    public ArrayList<Product> fetchProductbyName(String searchQuery) throws SQLException{
        ArrayList<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Product WHERE name LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, "%" + searchQuery + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                        int productID = rs.getInt("productID");
                        String name = rs.getString("name");
                        String category = rs.getString("category");
                        String description = rs.getString("description");
                        double price = rs.getDouble("price");
                        String imageURL = rs.getString("imageURL");
                        Product product = new Product(productID, name, category, description, price, imageURL);
                        products.add(product);
            }
        }
        return products;
    }

    public ArrayList<Product> fetchProductsByCategory(String category) throws SQLException {
        ArrayList<Product> products = new ArrayList<>();
        String query;

        if ("Other".equals(category)) {
            query = "SELECT * FROM Product WHERE category NOT IN ("
                    + "'Temperature / Humidity / Air Pressure / Gas', "
                    + "'Motion Sensor', "
                    + "'Navigation Modules', "
                    + "'Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth')";
        } else {
            query = "SELECT * FROM Product WHERE category = ?";
        }

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            if (!"Other".equals(category)) {
                stmt.setString(1, category);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int productID = rs.getInt("productID");
                String name = rs.getString("name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String imageURL = rs.getString("imageURL");

                Product product = new Product(productID, name, category, description, price, imageURL);
                products.add(product);
            }
        }

        return products;
    }
}
