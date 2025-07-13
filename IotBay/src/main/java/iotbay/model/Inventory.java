package iotbay.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Inventory implements Serializable {
    private int productId;
    private int stockQuantity;
    private int targetStockLevel;
    private int restockThreshold;
    private LocalDateTime lastUpdatedAt;

    public Inventory() {}

    public Inventory(int productId, int stockQuantity, int targetStockLevel, int restockThreshold, LocalDateTime lastUpdatedAt) {
        this.productId = productId;
        this.stockQuantity = stockQuantity;
        this.targetStockLevel = targetStockLevel;
        this.restockThreshold = restockThreshold;
        this.lastUpdatedAt = lastUpdatedAt;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
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
        this.lastUpdatedAt = lastUpdatedAt;
    }


}
