package iotbay.controller;

import iotbay.model.AccessLog;
import iotbay.model.User;
import iotbay.model.dao.DAO;
import iotbay.model.dao.AccesslogManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/AccessLogServlet")
public class AccessLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        DAO dao = (DAO) session.getAttribute("dao");

        if (dao == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String dateFilter = request.getParameter("date");
        List<AccessLog> logs = null;
        String errorMessage = null;

        try {
            AccesslogManager logManager = dao.accesslogManager();

            if (dateFilter != null && !dateFilter.isEmpty()) {
                if (!isValidDate(dateFilter)) {
                    errorMessage = "Invalid date format. Please enter the date as YYYY-MM-DD.";
                } else {
                    logs = logManager.getLogsByUserAndDate(user.getId(), dateFilter);
                }
            } else {
                logs = logManager.getLogsByUser(user.getId());
            }

        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred while retrieving access logs.";
        }

        request.setAttribute("logs", logs);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("accessLog.jsp").forward(request, response);
    }

    private boolean isValidDate(String date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);  // Strict parsing
        try {
            sdf.parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }
}
