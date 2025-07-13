package iotbay.controller;

import iotbay.model.User;
import iotbay.model.dao.DAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

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
            dao.userManager().deleteUser(user.getId());

            session.removeAttribute("user");
            session.removeAttribute("dao");
            session.invalidate();

            response.sendRedirect("accountDeleted.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to delete account.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}
