package iotbay.controller;

import iotbay.model.Product;
import iotbay.model.dao.ProductManager;
import iotbay.model.dao.DBConnector;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Connection;
import java.util.ArrayList;

@WebServlet("/BrowseProductServlet")
public class BrowseProductServlet extends HttpServlet {

    // Handles GET requests to retrieve full or filtered product list from DB
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            session.setAttribute("GuestMode", true);
        }
        ProductManager productManager = (ProductManager) session.getAttribute("productManager");
        String query = (String) request.getParameter("query");
        String category = (String) request.getParameter("category");
        ArrayList<Product> products;

        if (productManager == null) {
            DBConnector dbConnector = new DBConnector();
            Connection connection = dbConnector.getConnection();
            productManager = new ProductManager(connection);
            session.setAttribute("productManager", productManager);
        }

        try {
            if (query != null && !query.isEmpty()) {
                products = productManager.fetchProductbyName(query);
            } else if (category != null && !category.isEmpty()) {
                products = productManager.fetchProductsByCategory(category);
            } else {
                products = productManager.fetchAllProducts();
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("browse.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving products.");
        }
    }
}
