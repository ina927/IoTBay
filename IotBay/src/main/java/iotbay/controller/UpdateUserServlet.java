package iotbay.controller;

import iotbay.model.User;
import iotbay.model.Address;
import iotbay.model.dao.DAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {

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

        // 값 받아오기
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String contact = request.getParameter("contact");
        String street = request.getParameter("address");
        String suburb = request.getParameter("suburb");
        String state = request.getParameter("state");
        String postcode = request.getParameter("postcode");

        // 값 반영
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setContact(contact);

        Address address = new Address(street, suburb, state, postcode);
        user.setAddress(address);

        try {
            dao.userManager().updateUser(user);
            session.setAttribute("user", user);
            response.sendRedirect("profile.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update profile.");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
        }
    }
}
