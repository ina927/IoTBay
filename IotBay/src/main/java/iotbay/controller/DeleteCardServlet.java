package iotbay.controller;

import iotbay.model.User;
import iotbay.model.dao.DAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DeleteCardServlet")
public class DeleteCardServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        DAO dao = (DAO) session.getAttribute("dao");
        User user = (User) session.getAttribute("user");

        if (dao == null || user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Delete from new UserCard table
            dao.userCardManager().deleteCardByUserId(user.getId());

            response.sendRedirect("PaymentServlet");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to delete stored card.");
            request.getRequestDispatcher("Payment.jsp").forward(request, response);
        }
    }
}
