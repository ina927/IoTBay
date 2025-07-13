package iotbay.model;

import java.io.Serializable;

 public class Payment implements  Serializable {
    private int paymentId;
     private int orderId;
     private int userId;
     private String paymentMethod;
     private String cardNumber;
     private String cardHolder;
     private String expiryDate;
     private String cvv;
     private double amount;
     private String paymentDate;
     private String address;
     private String suburb;
     private String state;
     private String postcode;


     public Payment() {}

    public Payment(int paymentId, int orderId, int userId, String paymentMethod, String cardNumber,
                   String cardHolder, String expiryDate, String cvv, double amount, String paymentDate) {
        this.paymentId = paymentId;
        this.orderId = orderId;
        this.userId = userId;
        this.paymentMethod = paymentMethod;
        this.cardNumber = cardNumber;
        this.cardHolder = cardHolder;
        this.expiryDate = expiryDate;
        this.cvv = cvv;
        this.amount = amount;
        this.paymentDate = paymentDate;
    }


    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }

    public String getCardHolder() { return cardHolder; }
    public void setCardHolder(String cardHolder) { this.cardHolder = cardHolder; }

    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }

    public String getCvv() { return cvv; }
    public void setCvv(String cvv) { this.cvv = cvv; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentDate() { return paymentDate; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
     public String getAddress() {
         return address;
     }

     public void setAddress(String address) {
         this.address = address;
     }

     public String getSuburb() {
         return suburb;
     }

     public void setSuburb(String suburb) {
         this.suburb = suburb;
     }

     public String getState() {
         return state;
     }

     public void setState(String state) {
         this.state = state;
     }

     public String getPostcode() {
         return postcode;
     }

     public void setPostcode(String postcode) {
         this.postcode = postcode;
     }

 }
