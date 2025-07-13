package iotbay.controller;

import iotbay.model.User;
import iotbay.model.dao.DAO;
import iotbay.model.UserType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AdminUserListServlet")
public class AdminUserListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is admin
        if (currentUser == null || !"admin@iotbay.com".equals(currentUser.getEmail())) {
            response.sendRedirect("login.jsp");
            return;
        }



        String typeFilter = request.getParameter("typeFilter");
        String nameFilter = request.getParameter("searchFullName");
        String phoneFilter = request.getParameter("searchPhone");
        String action = request.getParameter("action");
        String userIdToEdit = request.getParameter("userId");

        // Filter users
        List<User> userList = new ArrayList<>();
        try {
            for (User u : dao.userManager().getAllUsers()) {
                boolean matchesType = typeFilter == null
                        || "ALL".equals(typeFilter)
                        || u.getUserType().name().equalsIgnoreCase(typeFilter);
                String fullName = u.getFirstName() + " " + u.getLastName();
                boolean matchesName = nameFilter == null || nameFilter.trim().isEmpty()
                        || fullName.equalsIgnoreCase(nameFilter.trim());
                boolean matchesPhone = phoneFilter == null || phoneFilter.trim().isEmpty()
                        || (u.getContact() != null
                        && u.getContact().toLowerCase().contains(phoneFilter.trim().toLowerCase()));
                if (matchesType && matchesName && matchesPhone) {
                    userList.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
        }

        // Prepare email list for duplicate checking
        List<String> emailList = new ArrayList<>();
        for (User u : userList) {
            emailList.add(u.getEmail());
        }

        // Find user to edit if in edit mode
        User editUser = null;
        if ("edit".equals(action) && userIdToEdit != null) {
            for (User u : userList) {
                if (String.valueOf(u.getId()).equals(userIdToEdit)) {
                    editUser = u;
                    break;
                }
            }
        }

        // Handle delete confirmation
        if ("confirmDelete".equals(action)) {
            String emailToDelete = null;
            if (userIdToEdit != null) {
                for (User u : userList) {
                    if (String.valueOf(u.getId()).equals(userIdToEdit)) {
                        emailToDelete = u.getEmail();
                        break;
                    }
                }
            }
            request.setAttribute("emailToDelete", emailToDelete);
        }

        // Set all necessary attributes for the JSP
        request.setAttribute("userList", userList);
        request.setAttribute("emailList", emailList);
        request.setAttribute("editUser", editUser);
        request.setAttribute("action", action);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("nameFilter", nameFilter);
        request.setAttribute("phoneFilter", phoneFilter);

        for (User u : userList) {
            // User Type
            String userTypeLabel = "-";
            if (u.getUserType() != null) {
                userTypeLabel = u.getUserType() == UserType.STAFF ? "Staff" : "Customer";
            }
            request.setAttribute("userTypeLabel_" + u.getId(), userTypeLabel);

            // Address
            String addressDisplay = "-";
            if (u.getAddress() != null) {
                String street = u.getAddress().getAddress();
                String suburb = u.getAddress().getSuburb();
                String state = u.getAddress().getState();
                String postcode = u.getAddress().getPostcode();
                boolean validStreet = street != null && !street.trim().isEmpty() && !"null".equalsIgnoreCase(street.trim());
                boolean validSuburb = suburb != null && !suburb.trim().isEmpty() && !"null".equalsIgnoreCase(suburb.trim());
                boolean validState = state != null && !state.trim().isEmpty() && !"null".equalsIgnoreCase(state.trim());
                boolean validPostcode = postcode != null && !postcode.trim().isEmpty() && !"null".equalsIgnoreCase(postcode.trim());
                if (validStreet && validSuburb && validState && validPostcode) {
                    addressDisplay = street + ", " + suburb + ", " + state + " " + postcode;
                }
            }
            request.setAttribute("addressDisplay_" + u.getId(), addressDisplay);

            // Status Class
            String statusClass = "active".equals(u.getStatus()) ? "status-enable" : "status-disable";
            request.setAttribute("statusClass_" + u.getId(), statusClass);
        }

        // Forward to JSP
        request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
    }
}
