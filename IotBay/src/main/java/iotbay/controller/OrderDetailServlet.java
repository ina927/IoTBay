package iotbay.controller;

import iotbay.model.Order;
import iotbay.model.OrderItem;
import iotbay.model.Product;
import iotbay.model.dao.DAO;
import iotbay.model.dao.OrderManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/OrderDetailServlet")
public class OrderDetailServlet extends HttpServlet {

    // Handles GET requests to retrieve order details from DB based on the selected Order
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");

        String orderIDParam = request.getParameter("orderID");

        if (dao == null || orderIDParam == null || orderIDParam.isEmpty()) {
            response.sendRedirect("orderhistory.jsp");
            return;
        }

        try {
            int orderID = Integer.parseInt(orderIDParam);
            OrderManager orderManager = dao.orderManager();
            Order order = orderManager.getOrderByID(orderID);
            ArrayList<OrderItem> orderItems = orderManager.getOrderItemsByOrderID(orderID);

            Map<Integer, Product> productMap = new HashMap<>();
            double total = 0;

            for (OrderItem item : orderItems) {
                Product product = dao.productManager().fetchProductById(item.getProductID());
                productMap.put(item.getProductID(), product);
                total += product.getPrice() * item.getQuantity();
            }

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("productMap", productMap);
            request.setAttribute("orderTotal", total);

            // FORWARD TO JSP
            request.getRequestDispatcher("orderdetail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
