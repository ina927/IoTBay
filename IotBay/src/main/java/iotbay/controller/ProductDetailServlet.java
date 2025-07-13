package iotbay.controller;

import iotbay.model.Product;
import iotbay.model.dao.ProductManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ProductDetailServlet")
public class ProductDetailServlet extends HttpServlet {

    // Handles GET requests to retrieve product details from DB based on the selected Product
    // browse.jsp -> ProductDetailServlet -> productDetail.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        ProductManager productManager = (ProductManager) session.getAttribute("productManager");

        if (productManager == null) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "ProductManager not found in session.");
            return;
        }

        String productIdStr = request.getParameter("id");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing product ID.");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            Product product = productManager.fetchProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("productdetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID format.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }
}
