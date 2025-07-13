package iotbay.model.dao;

import java.sql.Connection;

public class DAO {
    private final Connection connection;

    private final UserManager userManager;
    private final ProductManager productManager;
    private final OrderManager orderManager;
    private final PaymentManager paymentManager;
    private final InventoryManager inventoryManager;
    private final AccesslogManager accesslogManager;
    private final UserCardManager userCardManager;

    public DAO(Connection connection) {
        this.connection = connection;
        this.userManager = new UserManager(connection);
        this.productManager = new ProductManager(connection);
        this.orderManager = new OrderManager(connection);
        this.paymentManager = new PaymentManager(connection);
        this.inventoryManager = new InventoryManager(connection);
        this.accesslogManager = new AccesslogManager(connection);
        this.userCardManager = new UserCardManager(connection);
    }

    // Getter methods
    public Connection getConnection() {
        return connection;
    }

    public UserManager userManager() {
        return userManager;
    }

    public ProductManager productManager() {
        return productManager;
    }

    public OrderManager orderManager() {
        return orderManager;
    }

    public PaymentManager paymentManager() {
        return paymentManager;
    }

    public InventoryManager inventoryManager() {
        return inventoryManager;
    }

    public AccesslogManager accesslogManager() {
        return accesslogManager;
    }

    public UserCardManager userCardManager() {
        return userCardManager;
    }
}
