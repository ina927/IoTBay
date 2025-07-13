package iotbay.model;

import java.time.LocalDateTime;
import java.io.Serializable;

public class InventoryItem implements Serializable {
    private int productID;
    private String name;
    private String category;
    private String description;
    private double price;
    private int stockQuantity;
    private int targetStockLevel;
    private int restockThreshold;
    private LocalDateTime lastUpdatedAt;
    private String imageUrl;

    public InventoryItem(int productID, String name, String category, String description, double price, int stockQuantity, int targetStockLevel, int restockThreshold, LocalDateTime lastUpdatedAt, String imageUrl) {
        this.productID = productID;
        this.name = name;
        this.category = category;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.targetStockLevel = targetStockLevel;
        this.restockThreshold = restockThreshold;
        this.lastUpdatedAt = lastUpdatedAt;
        this.imageUrl = imageUrl;
    }

    // Getters and setters
    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public int getTargetStockLevel() {
        return targetStockLevel;
    }

    public void setTargetStockLevel(int targetStockLevel) {
        this.targetStockLevel = targetStockLevel;
    }

    public int getRestockThreshold() {
        return restockThreshold;
    }

    public void setRestockThreshold(int restockThreshold) {
        this.restockThreshold = restockThreshold;
    }

    public LocalDateTime getLastUpdatedAt() {
        return lastUpdatedAt;
    }

    public void setLastUpdatedAt(LocalDateTime lastUpdatedAt) {
        this.lastUpdatedAt = LocalDateTime.now();
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() {
        return imageUrl;
    }
}
