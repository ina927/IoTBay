package iotbay.model.dao;

import iotbay.model.UserCard;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserCardManager {

    private final Connection connection;

    public UserCardManager(Connection connection) {
        this.connection = connection;
    }

    // Add new card for user
    public void addCard(UserCard card) throws SQLException {
        UserCard existing = getCardByUserId(card.getUserId());
        if (existing != null) {

            card.setCardId(existing.getCardId());
            updateCard(card);
        } else {
            // Insert new card
            String sql = "INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, card.getUserId());
                stmt.setString(2, card.getCardNumber());
                stmt.setString(3, card.getCardHolder());
                stmt.setString(4, card.getExpiryDate());
                stmt.setString(5, card.getCvv());
                stmt.setString(6, card.getPaymentMethod());
                stmt.executeUpdate();

            }
        }
    }



    public UserCard getCardByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM UserCard WHERE userID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserCard card = extractUserCardFromResultSet(rs);
                    System.out.println("Found card in DB for user " + userId + ": " + card.getCardNumber());
                    return card;
                }
            }
        }
        System.out.println("No card found in DB for user: " + userId);
        return null;
    }

    public List<UserCard> getCardsByUserId(int userId) throws SQLException {
        List<UserCard> cards = new ArrayList<>();
        String sql = "SELECT * FROM UserCard WHERE userID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cards.add(extractUserCardFromResultSet(rs));
                }
            }
        }
        return cards;
    }

    // Delete card by user ID
    public void deleteCardByUserId(int userId) throws SQLException {
        String sql = "DELETE FROM UserCard WHERE userID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Deleted " + rowsAffected + " cards for user ID: " + userId);
        }
    }

    // Delete card by card ID
    public void deleteCard(int cardId) throws SQLException {
        String sql = "DELETE FROM UserCard WHERE cardID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cardId);
            stmt.executeUpdate();
        }
    }

    // Update card
    public void updateCard(UserCard card) throws SQLException {
        String sql = "UPDATE UserCard SET cardNumber = ?, cardHolder = ?, expiryDate = ?, cvv = ?, paymentMethod = ? " +
                "WHERE cardID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, card.getCardNumber());
            stmt.setString(2, card.getCardHolder());
            stmt.setString(3, card.getExpiryDate());
            stmt.setString(4, card.getCvv());
            stmt.setString(5, card.getPaymentMethod());
            stmt.setInt(6, card.getCardId());
            stmt.executeUpdate();
        }
    }


    private UserCard extractUserCardFromResultSet(ResultSet rs) throws SQLException {
        UserCard card = new UserCard();
        card.setCardId(rs.getInt("cardID"));
        card.setUserId(rs.getInt("userID"));
        card.setCardNumber(rs.getString("cardNumber"));
        card.setCardHolder(rs.getString("cardHolder"));
        card.setExpiryDate(rs.getString("expiryDate"));
        card.setCvv(rs.getString("cvv"));
        card.setPaymentMethod(rs.getString("paymentMethod"));
        return card;
    }
}