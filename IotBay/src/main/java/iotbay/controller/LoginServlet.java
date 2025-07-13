package iotbay.controller;

import iotbay.model.User;
import iotbay.model.UserType;
import iotbay.model.dao.DAO;
import iotbay.model.dao.AccesslogManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");

        if (dao == null) {
            System.out.println("[DEBUG] DAO is null!");
            request.setAttribute("error", "DAO is not initialized.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String email = request.getParameter("userId");
        String password = request.getParameter("userPw");
        String userTypeParam = request.getParameter("userType");

        System.out.println("[DEBUG] Email: " + email + ", Password: " + password + ", UserType: " + userTypeParam);

        try {
            int userTypeCode = "staff".equalsIgnoreCase(userTypeParam) ? 1 : 0;
            User user = dao.userManager().findUser(email, password, userTypeCode);
            System.out.println("DEBUG: user.getStatus() = [" + (user != null ? user.getStatus() : "null") + "]");

            //(45-51) jisu edited do not delete
            if (user != null) {
                if ("inactive".equalsIgnoreCase(user.getStatus())) {
                    request.setAttribute("error", "This account is inactive.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
                System.out.println("[DEBUG] Login success for user: " + user.getEmail() + " (ID: " + user.getId() + ")");
                session.setAttribute("user", user);
                session.removeAttribute("GuestMode");


                try {
                    AccesslogManager logManager = dao.accesslogManager();
                    logManager.insertLoginLog(dao.getConnection(), user.getId());
                } catch (SQLException e) {
                    System.out.println("[ERROR] Failed to insert login log:");
                    e.printStackTrace();
                }

                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>");

                response.getWriter().println("parent.document.getElementById('nav-frame').contentWindow.location.reload();");

                if (user.getUserType() == UserType.CUSTOMER) {
                    response.getWriter().println("parent.document.getElementById('content-frame').src = 'BrowseProductServlet';");
                } else {
                    response.getWriter().println("parent.document.getElementById('content-frame').src = 'InventoryServlet';");
                }

                response.getWriter().println("</script>");
            } else {
                System.out.println("[DEBUG] Login failed: user == null");
                request.setAttribute("error", "Invalid email, password, or user type.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("[DEBUG] Exception during login:");
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
