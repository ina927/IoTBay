package iotbay.controller;

import iotbay.model.dao.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AdminDeleteUserServlet")
public class AdminDeleteUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG] AdminDeleteUserServlet.doPost() called");
        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");
        if (dao == null) {
            System.out.println("[DEBUG] DAO is null, redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        String userIdStr = request.getParameter("userId");
        System.out.println("[DEBUG] userId parameter: " + userIdStr);

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            System.out.println("[DEBUG] userId is null or empty");
            request.setAttribute("error", "Invalid user ID");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            System.out.println("[DEBUG] Attempting to delete user with ID: " + userId);

            dao.userManager().deleteUser(userId);
            System.out.println("[DEBUG] Delete operation completed");

            System.out.println("[DEBUG] User deleted successfully, redirecting to AdminUserListServlet");
            response.sendRedirect("AdminUserListServlet");

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Invalid userId format: " + userIdStr);
            request.setAttribute("error", "Invalid user ID format");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("[DEBUG] SQLException during delete: " + e.getMessage());
            request.setAttribute("error", "Database error during delete");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
        }
    }
}