package iotbay.model.dao;

import iotbay.model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentManager {

    private final Connection connection;

    public PaymentManager(Connection connection) {
        this.connection = connection;
    }

    public void addPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payment (OrderID, PaymentMethod, CardNumber, CardHolder, ExpiryDate, CVV, Amount, PaymentDate, Address, Suburb, State, Postcode) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, payment.getOrderId());
            stmt.setString(2, payment.getPaymentMethod());
            stmt.setString(3, payment.getCardNumber());
            stmt.setString(4, payment.getCardHolder());
            stmt.setString(5, payment.getExpiryDate());
            stmt.setString(6, payment.getCvv());
            stmt.setDouble(7, payment.getAmount());
            stmt.setString(8, payment.getPaymentDate());
            stmt.setString(9, payment.getAddress());
            stmt.setString(10, payment.getSuburb());
            stmt.setString(11, payment.getState());
            stmt.setString(12, payment.getPostcode());

            stmt.executeUpdate();

            // Try to get the generated payment ID
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    payment.setPaymentId(generatedKeys.getInt(1));
                }
            }
        }
    }


    public List<Payment> fetchPaymentsByUser(int userId) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.* FROM Payment p " +
                "JOIN Orders o ON p.OrderID = o.OrderID " +
                "WHERE o.MemberID = ? ORDER BY p.PaymentDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(buildPaymentFromResultSet(rs));
                }
            }
        }
        return payments;
    }

    public List<Payment> fetchAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment ORDER BY PaymentDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                payments.add(buildPaymentFromResultSet(rs));
            }
        }
        return payments;
    }

    public Payment findPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE PaymentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return buildPaymentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public List<Payment> searchPaymentsByDate(String date) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE PaymentDate = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(buildPaymentFromResultSet(rs));
                }
            }
        }
        return payments;
    }

    public List<Payment> searchPaymentsByFormattedDate(String formattedDate) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE PaymentDate = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, formattedDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(buildPaymentFromResultSet(rs));
                }
            }
        }
        return payments;
    }



    public List<Payment> searchAllPaymentsByDate(String date) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE PaymentDate = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(buildPaymentFromResultSet(rs));
                }
            }
        }
        return payments;
    }

    public void updatePayment(Payment payment) throws SQLException {
        String sql = "UPDATE Payment SET PaymentMethod=?, CardNumber=?, CardHolder=?, ExpiryDate=?, CVV=?, Amount=?, PaymentDate=? " +
                "WHERE PaymentID=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, payment.getPaymentMethod());
            ps.setString(2, payment.getCardNumber());
            ps.setString(3, payment.getCardHolder());
            ps.setString(4, payment.getExpiryDate());
            ps.setString(5, payment.getCvv());
            ps.setDouble(6, payment.getAmount());
            ps.setDate(7, Date.valueOf(payment.getPaymentDate()));
            ps.setInt(8, payment.getPaymentId());
            ps.executeUpdate();
        }
    }

    public void deletePayment(int paymentId) throws SQLException {
        String sql = "DELETE FROM Payment WHERE PaymentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ps.executeUpdate();
        }
    }

    private Payment buildPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("PaymentID"));
        p.setOrderId(rs.getInt("OrderID"));
        p.setPaymentMethod(rs.getString("PaymentMethod"));
        p.setCardNumber(rs.getString("CardNumber"));
        p.setCardHolder(rs.getString("CardHolder"));
        p.setExpiryDate(rs.getString("ExpiryDate"));
        p.setCvv(rs.getString("CVV"));
        p.setAmount(rs.getDouble("Amount"));
        p.setPaymentDate(rs.getString("PaymentDate"));
        p.setAddress(rs.getString("Address"));
        p.setSuburb(rs.getString("Suburb"));
        p.setState(rs.getString("State"));
        p.setPostcode(rs.getString("Postcode"));
        return p;
    }
}
