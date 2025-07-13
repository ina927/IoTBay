package iotbay.controller;

import iotbay.model.Address;
import iotbay.model.User;
import iotbay.model.dao.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AdminUpdateUserServlet")
public class AdminUpdateUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG] AdminUpdateUserServlet.doPost() called");
        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");
        if (dao == null) {
            System.out.println("[DEBUG] DAO is null, redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String contact   = request.getParameter("contact");
        String status    = request.getParameter("status");

        String street   = request.getParameter("street");
        String suburb   = request.getParameter("suburb");
        String state    = request.getParameter("state");
        String postcode = request.getParameter("postcode");

        System.out.println("[DEBUG] userId=" + userId + ", firstName=" + firstName + ", lastName=" + lastName + ", contact=" + contact + ", status=" + status);
        System.out.println("[DEBUG] street=" + street + ", suburb=" + suburb + ", state=" + state + ", postcode=" + postcode);

        if (firstName == null || firstName.trim().isEmpty() ||
                lastName  == null || lastName.trim().isEmpty()  ||
                contact   == null || contact.trim().isEmpty()) {
            System.out.println("[DEBUG] not enogh field, editUser forward");
            User editUser = null;
            try {
                editUser = dao.userManager().findUserById(userId);
            } catch (SQLException ignored) {}
            request.setAttribute("error", "blank_fields");
            request.setAttribute("action", "edit");
            request.setAttribute("editUser", editUser);
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
            return;
        }

        try {
            User target = dao.userManager().findUserById(userId);
            if (target == null) {
                System.out.println("[DEBUG] can't find user,");
                request.setAttribute("error", "notfound");
                request.setAttribute("action", "edit");
                request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
                return;
            }

            target.setFirstName(firstName);
            target.setLastName(lastName);
            target.setContact(contact);
            target.setStatus(status);

            boolean anyAddr = (street   != null && !street.trim().isEmpty()) ||
                    (suburb   != null && !suburb.trim().isEmpty()) ||
                    (state    != null && !state.trim().isEmpty()) ||
                    (postcode != null && !postcode.trim().isEmpty());
            boolean allAddr = anyAddr &&
                    (street   != null && !street.trim().isEmpty()) &&
                    (suburb   != null && !suburb.trim().isEmpty()) &&
                    (state    != null && !state.trim().isEmpty()) &&
                    (postcode != null && !postcode.trim().isEmpty());

            if (anyAddr && !allAddr) {
                System.out.println("[DEBUG] not enough field, incomplete_address error");
                request.setAttribute("error", "incomplete_address");
                request.setAttribute("action", "edit");
                request.setAttribute("editUser", target);
                request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
                return;
            } else if (allAddr) {
                target.setAddress(new Address(street, suburb, state, postcode));
            } else {
                target.setAddress(null);
            }

            dao.userManager().updateUserByAdmin(target);
            System.out.println("[DEBUG] success update user, AdminUserListServlet redirect");
            response.sendRedirect("AdminUserListServlet");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("[DEBUG] SQLException, updatefail error");
            request.setAttribute("error", "updatefail");
            request.setAttribute("action", "edit");
            try {
                User editUser = dao.userManager().findUserById(userId);
                request.setAttribute("editUser", editUser);
            } catch (SQLException ignored) {}
            request.getRequestDispatcher("systemAdmin.jsp").forward(request, response);
        }
    }
}