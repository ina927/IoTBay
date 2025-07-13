package iotbay.controller;

import iotbay.model.CartItem;
import iotbay.model.dao.ProductManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import iotbay.model.Product;
import iotbay.model.dao.DAO;
import iotbay.model.dao.InventoryManager;
import java.sql.SQLException;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    // Handles all POST requests for cart actions to call appropriate functions
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        switch (action) {
            case "add":
                addToCart(request, response, cart);
                return;
            case "update":
                updateCart(request, response, cart);
                break;
            case "remove":
                removeFromCart(request, cart);
                break;
            default:
                break;
        }

        response.sendRedirect("cart.jsp");
    }


    // Adds a product to the cart after validation of the input
    private void addToCart(HttpServletRequest request, HttpServletResponse response, ArrayList<CartItem> cart)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");

        int productID = Integer.parseInt(request.getParameter("productID"));
        String productName = request.getParameter("productName");
        double productPrice = Double.parseDouble(request.getParameter("productPrice"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String imageUrl = request.getParameter("imageUrl");
        String source = request.getParameter("source");

        try {
            InventoryManager inventoryManager = dao.inventoryManager();
            int cartQty = 0;
            for (CartItem item : cart) {
                if (item.getProductID() == productID) {
                    cartQty = item.getQuantity();
                    break;
                }
            }

            int stockQty = inventoryManager.getStockQuantity(productID);

            // Reject if new quantity is more than available stock
            if (cartQty + quantity > stockQty) {
                request.setAttribute("stockError", true);
                request.setAttribute("stockQty", stockQty);
                ProductManager pm = dao.productManager();
                Product product = pm.fetchProductById(productID);
                request.setAttribute("product", product);
                request.getRequestDispatcher("productdetail.jsp").forward(request, response);
                return;
            }

            // If item already in cart, update quantity
            for (CartItem item : cart) {
                if (item.getProductID() == productID) {
                    item.setQuantity(item.getQuantity() + quantity);
                    if ("buy".equals(source)) {
                        response.sendRedirect("cart.jsp");
                    } else {
                        request.setAttribute("success", true);
                        ProductManager pm = dao.productManager();
                        Product product = pm.fetchProductById(productID);
                        request.setAttribute("product", product);
                        request.getRequestDispatcher("productdetail.jsp").forward(request, response);
                    }
                    return;
                }
            }

            // If new item, add to cart
            cart.add(new CartItem(productID, productName, productPrice, quantity, imageUrl));

            if ("buy".equals(source)) {
                response.sendRedirect("cart.jsp");
            } else {
                request.setAttribute("success", true);
                ProductManager pm = dao.productManager();
                Product product = pm.fetchProductById(productID);
                request.setAttribute("product", product);
                request.getRequestDispatcher("productdetail.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error while checking stock", e);
        }
    }

    // Updates the quantity of a product in the cart after validation of the input
    private void updateCart(HttpServletRequest request, HttpServletResponse response, ArrayList<CartItem> cart){
        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");

        int productID = Integer.parseInt(request.getParameter("productID"));
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));

        try {
            InventoryManager inventoryManager = dao.inventoryManager();
            int stockQty = inventoryManager.getStockQuantity(productID);

            // Reject if new quantity is more than available stock or less than 0
            if (newQuantity > stockQty) {
                ProductManager productManager = dao.productManager();
                Product product = productManager.fetchProductById(productID);
                request.setAttribute("stockError", true);
                request.setAttribute("stockQty", stockQty);
                request.setAttribute("productName", product.getName());
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            } else if (newQuantity < 1) {
                newQuantity = 1;
            }

            // Update quantity in cart
            for (CartItem item : cart) {
                if (item.getProductID() == productID) {
                    item.setQuantity(newQuantity);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Removes a product from the cart
    private void removeFromCart(HttpServletRequest request, ArrayList<CartItem> cart) {
        int productID = Integer.parseInt(request.getParameter("productID"));
        cart.removeIf(item -> item.getProductID() == productID);
    }
}
