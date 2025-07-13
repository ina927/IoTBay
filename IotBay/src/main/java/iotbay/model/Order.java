package iotbay.model;

import java.io.Serializable;

public class Order implements Serializable {
    private int orderID;
    private Integer memberID; // allow nullable (guest order)
    private String orderDate;
    private String orderStatus;

    public Order() {
    }

    public Order(int orderID, Integer memberID, String orderDate, String orderStatus) {
        this.orderID = orderID;
        this.memberID = memberID;
        this.orderDate = orderDate;
        this.orderStatus = orderStatus;
    }

    public Order(Integer memberID, String orderDate, String orderStatus) {
        this.memberID = memberID;
        this.orderDate = orderDate;
        this.orderStatus = orderStatus;
    }

    public int getOrderID() { return orderID; }
    public void setOrderID(int orderID) { this.orderID = orderID; }


    public Integer getMemberID() { return memberID; }
    public void setMemberID(Integer memberID) { this.memberID = memberID; }

    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
}
