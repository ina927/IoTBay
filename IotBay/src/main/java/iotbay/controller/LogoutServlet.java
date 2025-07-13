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

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            DAO dao = (DAO) session.getAttribute("dao");
            User user = (User) session.getAttribute("user");

            if (dao != null && user != null) {
                try {
                    dao.accesslogManager().updateLogoutLog(dao.getConnection(), user.getId());
                } catch (SQLException e) {
                    System.err.println("[LogoutServlet] Failed to update logout log:");
                    e.printStackTrace();
                }
            }
            session.setAttribute("user", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<script>");
        response.getWriter().println("parent.document.getElementById('nav-frame').contentWindow.location.reload();");
        response.getWriter().println("parent.document.getElementById('content-frame').src = 'logoutpage.jsp';");
        response.getWriter().println("</script>");
    }
}