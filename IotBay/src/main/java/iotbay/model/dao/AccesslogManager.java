package iotbay.model.dao;

import iotbay.model.AccessLog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccesslogManager {

    private final Connection connection;

    public AccesslogManager(Connection connection) {
        this.connection = connection;
    }

    public void insertLoginLog(Connection conn, int userId) throws SQLException {
        String sql = "INSERT INTO AccessLog (UserID, LoginTime) VALUES (?, datetime('now', 'localtime'))";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            int rowsInserted = pstmt.executeUpdate();
            System.out.println("[AccesslogManager] Login log inserted. Rows affected: " + rowsInserted);
        }
    }

    public void updateLogoutLog(Connection conn, int userId) throws SQLException {
        String sql = "UPDATE AccessLog SET LogoutTime = datetime('now', 'localtime') WHERE UserID = ? AND LogoutTime IS NULL";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated == 0) {
                System.err.println("[AccesslogManager] ⚠ No logout log updated. No matching record with NULL LogoutTime.");
            } else {
                System.out.println("[AccesslogManager] ✅ Logout log updated. Rows affected: " + rowsUpdated);
            }
        }
    }

    public List<AccessLog> getLogsByUser(int userId) throws SQLException {
        List<AccessLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM AccessLog WHERE UserID = ? ORDER BY LoginTime DESC";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                logs.add(new AccessLog(
                        rs.getInt("LogID"),
                        rs.getInt("UserID"),
                        rs.getTimestamp("LoginTime"),
                        rs.getTimestamp("LogoutTime")
                ));
            }
        }
        return logs;
    }

    public List<AccessLog> getLogsByUserAndDate(int userId, String date) throws SQLException {
        List<AccessLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM AccessLog WHERE UserID = ? AND DATE(LoginTime) = ? ORDER BY LoginTime DESC";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, date);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                logs.add(new AccessLog(
                        rs.getInt("LogID"),
                        rs.getInt("UserID"),
                        rs.getTimestamp("LoginTime"),
                        rs.getTimestamp("LogoutTime")
                ));
            }
        }
        return logs;
    }
}
