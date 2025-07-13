package iotbay.model.dao;

import iotbay.model.Address;
import iotbay.model.User;
import iotbay.model.UserType;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserManager {

    private Connection connection;

    public UserManager(Connection connection) {
        this.connection = connection;
    }

    public User addUser(User user) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement(
                "INSERT INTO USER (UserType, FirstName, LastName, Email, Password, PhoneNum, Street, Suburb, State, Postcode, CreatedAt) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );
        preparedStatement.setInt(1, user.getUserType().ordinal());
        preparedStatement.setString(2, user.getFirstName());
        preparedStatement.setString(3, user.getLastName());
        preparedStatement.setString(4, user.getEmail());
        preparedStatement.setString(5, user.getPassword());
        preparedStatement.setString(6, user.getContact());

        Address address = user.getAddress();
        if (address != null) {
            preparedStatement.setString(7, address.getAddress());
            preparedStatement.setString(8, address.getSuburb());
            preparedStatement.setString(9, address.getState());
            preparedStatement.setString(10, address.getPostcode());
        } else {
            for (int i = 7; i <= 10; i++) {
                preparedStatement.setNull(i, java.sql.Types.VARCHAR);
            }
        }

        // CreatedAt에 현재 시간 세팅
        preparedStatement.setTimestamp(11, new Timestamp(System.currentTimeMillis()));

        preparedStatement.executeUpdate();

        preparedStatement = connection.prepareStatement("SELECT MAX(UserId) FROM user");
        ResultSet resultSet = preparedStatement.executeQuery();
        resultSet.next();
        int userId = resultSet.getInt(1);

        user.setId(userId);
        return user;
    }

    public User findUser(String email, String password, int userTypeCode) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement(
                "SELECT * FROM USER WHERE Email = ? AND Password = ? AND Usertype = ?"
        );
        preparedStatement.setString(1, email);
        preparedStatement.setString(2, password);
        preparedStatement.setInt(3, userTypeCode);

        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            UserType userType = UserType.values()[resultSet.getInt("UserType")];
            String firstName = resultSet.getString("FirstName");
            String lastName = resultSet.getString("LastName");
            String contact = resultSet.getString("PhoneNum");

            Address address = new Address(
                    resultSet.getString("Street"),
                    resultSet.getString("Suburb"),
                    resultSet.getString("State"),
                    resultSet.getString("Postcode")
            );

            User user = new User(userType, firstName, lastName, email, password, contact, address);
            user.setId(resultSet.getInt("UserId"));

            // jisu edited plz don't remove code and method
            user.setStatus(resultSet.getString("status"));
            return user;
        }
        return null;
    }

    public User findUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM USER WHERE UserId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserType userType = UserType.values()[rs.getInt("UserType")];
                    String firstName = rs.getString("FirstName");
                    String lastName = rs.getString("LastName");
                    String email = rs.getString("Email");
                    String password = rs.getString("Password");
                    String contact = rs.getString("PhoneNum");
                    String status = rs.getString("Status");

                    Address address = new Address(
                            rs.getString("Street"),
                            rs.getString("Suburb"),
                            rs.getString("State"),
                            rs.getString("Postcode")
                    );

                    User user = new User(userType, firstName, lastName, email, password, contact, address);
                    user.setId(userId);
                    user.setStatus(status);
                    return user;
                }
            }
        }
        return null;
    }


    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE USER SET FirstName = ?, LastName = ?, PhoneNum = ?, Street = ?, Suburb = ?, State = ?, Postcode = ? WHERE UserId = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getContact());

            Address address = user.getAddress();
            if (address != null) {
                pstmt.setString(4, address.getAddress());
                pstmt.setString(5, address.getSuburb());
                pstmt.setString(6, address.getState());
                pstmt.setString(7, address.getPostcode());
            } else {
                for (int i = 4; i <= 7; i++) {
                    pstmt.setNull(i, java.sql.Types.VARCHAR);
                }
            }

            pstmt.setInt(8, user.getId());
            pstmt.executeUpdate();
        }
    }

    public void deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM USER WHERE UserId = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        }
    }

    //  view all user (systemAdmin.jsp)
    public List<User> getAllUsers() throws SQLException {
        List<User> userList = new ArrayList<>();
        String query = "SELECT * FROM USER";

        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                UserType userType = UserType.values()[rs.getInt("UserType")];
                String firstName = rs.getString("FirstName");
                String lastName = rs.getString("LastName");
                String email = rs.getString("Email");
                String password = rs.getString("Password");
                String contact = rs.getString("PhoneNum");

                Address address = new Address(
                        rs.getString("Street"),
                        rs.getString("Suburb"),
                        rs.getString("State"),
                        rs.getString("Postcode")
                );

                User user = new User(userType, firstName, lastName, email, password, contact, address);
                user.setId(rs.getInt("UserId"));
                user.setStatus(rs.getString("Status"));
                userList.add(user);
            }
        }

        return userList;
    }

    // update user by admin ->
    public void updateUserByAdmin(User user) throws SQLException {
        String sql = "UPDATE USER SET FirstName = ?, LastName = ?, PhoneNum = ?, Street = ?, Suburb = ?, State = ?, Postcode = ?, Status = ? WHERE UserId = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getContact());

            Address address = user.getAddress();
            if (address != null) {
                pstmt.setString(4, address.getAddress());
                pstmt.setString(5, address.getSuburb());
                pstmt.setString(6, address.getState());
                pstmt.setString(7, address.getPostcode());
            } else {
                for (int i = 4; i <= 7; i++) {
                    pstmt.setNull(i, java.sql.Types.VARCHAR);
                }
            }

            pstmt.setString(8, user.getStatus());
            pstmt.setInt(9, user.getId());

            pstmt.executeUpdate();
        }
    }
}

