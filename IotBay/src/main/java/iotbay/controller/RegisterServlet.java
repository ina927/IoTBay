package iotbay.controller;

import iotbay.model.User;
import iotbay.model.UserType;
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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DAO dao = (DAO) request.getSession().getAttribute("dao");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String contact = request.getParameter("contact");
        String agree = request.getParameter("agree");

        String address = request.getParameter("address");
        String suburb = request.getParameter("suburb");
        String state = request.getParameter("state");
        String postcode = request.getParameter("postcode");
        String showAddress = request.getParameter("showAddress");

        boolean requireAddress = "true".equals(showAddress);

        boolean hasError = false;
        String errorMessage = "";

        if (!password.equals(confirmPassword)) {
            hasError = true;
            errorMessage = "Passwords do not match.";
        }

        if (agree == null) {
            hasError = true;
            errorMessage = "You must agree to the privacy policy.";
        }

        if (requireAddress) {
            if (address == null || suburb == null || state == null || postcode == null ||
                    address.isEmpty() || suburb.isEmpty() || state.isEmpty() || postcode.isEmpty()) {
                hasError = true;
                errorMessage = "Please fill in all address fields or skip address.";
            }
        }

        if (hasError) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            try {
                Address userAddress = null;
                if (requireAddress) {
                    userAddress = new Address(address, suburb, state, postcode);
                }

                User user = new User(UserType.CUSTOMER, firstName, lastName, email, password, contact, userAddress);
                dao.userManager().addUser(user);
                request.setAttribute("newUser", user);
                request.getRequestDispatcher("Welcome.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred during registration.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }
}
