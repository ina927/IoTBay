package iotbay.controller;

import iotbay.model.Address;
import iotbay.model.User;
import iotbay.model.UserType;
import iotbay.model.dao.DAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/AdminCreateUserServlet")
public class AdminCreateUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");
        if (dao == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String firstName    = request.getParameter("firstName");
        String lastName     = request.getParameter("lastName");
        String email        = request.getParameter("email");
        String password     = request.getParameter("password");
        String contact      = request.getParameter("contact");
        String userTypeParam= request.getParameter("userType");

        String address      = request.getParameter("street");
        String suburb       = request.getParameter("suburb");
        String state        = request.getParameter("state");
        String postcode     = request.getParameter("postcode");

        List<User> users = null;
        List<String> emailList = null;
        try {
            users = dao.userManager().getAllUsers();
            emailList = users.stream().map(User::getEmail).collect(java.util.stream.Collectors.toList());
        } catch (SQLException e) {
            users = new java.util.ArrayList<>();
            emailList = new java.util.ArrayList<>();
        }

        try {
            for (User u : dao.userManager().getAllUsers()) {
                if (u.getEmail().equalsIgnoreCase(email)) {
                    request.setAttribute("userList", users);
                    request.setAttribute("emailList", emailList);
                    request.setAttribute("createError", "exists");
                    request.setAttribute("createFormData", new String[]{
                        firstName, lastName, email, password, contact, userTypeParam
                    });
                    request.setAttribute("action", "create");
                    request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
                    return;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("userList", users);
            request.setAttribute("emailList", emailList);
            request.setAttribute("createError", "server");
            request.setAttribute("createFormData", new String[]{
                firstName, lastName, email, password, contact, userTypeParam
            });
            request.setAttribute("action", "create");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
            return;
        }

        if (firstName    == null || firstName.trim().isEmpty()   ||
                lastName     == null || lastName.trim().isEmpty()    ||
                email        == null || email.trim().isEmpty()       ||
                password     == null || password.trim().isEmpty()    ||
                contact      == null || contact.trim().isEmpty()     ||
                userTypeParam== null || userTypeParam.trim().isEmpty()) {
            request.setAttribute("userList", users);
            request.setAttribute("emailList", emailList);
            request.setAttribute("createError", "blank_fields");
            request.setAttribute("createFormData", new String[]{
                firstName, lastName, email, password, contact, userTypeParam
            });
            request.setAttribute("action", "create");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
            return;
        }

        boolean anyAddr = (address  != null && !address.trim().isEmpty())  ||
                (suburb   != null && !suburb.trim().isEmpty())   ||
                (state    != null && !state.trim().isEmpty())    ||
                (postcode != null && !postcode.trim().isEmpty());
        boolean allAddr = anyAddr &&
                (address  != null && !address.trim().isEmpty())  &&
                (suburb   != null && !suburb.trim().isEmpty())   &&
                (state    != null && !state.trim().isEmpty())    &&
                (postcode != null && !postcode.trim().isEmpty());
        if (anyAddr && !allAddr) {
            request.setAttribute("userList", users);
            request.setAttribute("emailList", emailList);
            request.setAttribute("createError", "incomplete_address");
            request.setAttribute("createFormData", new String[]{
                firstName, lastName, email, password, contact, userTypeParam
            });
            request.setAttribute("action", "create");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
            return;
        }

        UserType userType;
        try {
            int userTypeIndex = Integer.parseInt(userTypeParam);
            if (userTypeIndex < 0 || userTypeIndex >= UserType.values().length) {
                request.setAttribute("createError", "invalid_type");
                request.setAttribute("action", "create");
                request.setAttribute("createFormData", new String[]{
                    firstName, lastName, email, password, contact, userTypeParam
                });
                request.setAttribute("userList", users);
                request.setAttribute("emailList", emailList);
                request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
                return;
            }
            userType = UserType.values()[userTypeIndex];
        } catch (NumberFormatException e) {
            request.setAttribute("createError", "invalid_type");
            request.setAttribute("action", "create");
            request.setAttribute("createFormData", new String[]{
                firstName, lastName, email, password, contact, userTypeParam
            });
            request.setAttribute("userList", users);
            request.setAttribute("emailList", emailList);
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
            return;
        }

        Address userAddress = allAddr
                ? new Address(address, suburb, state, postcode)
                : null;
        User newUser = new User(userType, firstName, lastName,
                email, password, contact, userAddress);

        try {
            dao.userManager().addUser(newUser);
            response.sendRedirect("systemAdmin.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("userList", users);
            request.setAttribute("emailList", emailList);
            request.setAttribute("createError", "server");
            request.setAttribute("createFormData", new String[]{
                firstName, lastName, email, password, contact, userTypeParam
            });
            request.setAttribute("action", "create");
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
        }
    }
}