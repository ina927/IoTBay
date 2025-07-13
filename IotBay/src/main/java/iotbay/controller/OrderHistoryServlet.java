package iotbay.controller;

import iotbay.model.Order;
import iotbay.model.OrderItem;
import iotbay.model.User;
import iotbay.model.dao.DAO;
import iotbay.model.dao.OrderManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {

    // Handles GET requests to retrieve order history from DB based on logged-in user
    // Supports searching by order ID or date, or viewing all orders
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");
        User user = (User) session.getAttribute("user");

        if (dao == null || user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userID = user.getId();
        String action = request.getParameter("action");
        String searchType = request.getParameter("searchType");
        String orderIDParam = request.getParameter("orderID");
        String orderDateParam = request.getParameter("orderDate");

        ArrayList<Order> orderList = new ArrayList<>();

        try {
            OrderManager orderManager = dao.orderManager();

            if ("search".equals(action)) {
                if ("id".equals(searchType) && orderIDParam != null && !orderIDParam.trim().isEmpty()) {
                    // Search by order ID
                    try {
                        int orderID = Integer.parseInt(orderIDParam.trim());
                        Order order = orderManager.getOrderByID(orderID);
                        if (order != null && Objects.equals(order.getMemberID(), userID)) {
                            orderList.add(order);
                        }
                    } catch (NumberFormatException ignored) {}
                } else if ("date".equals(searchType) && orderDateParam != null && !orderDateParam.trim().isEmpty()) {
                    // Search by order date
                    orderList = orderManager.getOrdersByDateAndUser(orderDateParam.trim(), userID);
                }
            } else {
                // viewAll or default
                orderList = orderManager.getOrdersByMemberID(userID);
            }

            Map<Integer, String> representativeItemsMap = new HashMap<>();
            Map<Integer, Double> orderTotalsMap = new HashMap<>();

            for (Order order : orderList) {
                int orderID = order.getOrderID();
                ArrayList<OrderItem> items = orderManager.getOrderItemsByOrderID(orderID);

                String repName = "Unknown";
                int totalQuantity = 0;
                double totalPrice = 0;

                if (!items.isEmpty()) {
                    int repProductID = items.get(0).getProductID();
                    repName = dao.productManager().fetchProductById(repProductID).getName();

                    for (OrderItem item : items) {
                        totalQuantity += item.getQuantity();
                        double price = dao.productManager().fetchProductById(item.getProductID()).getPrice();
                        totalPrice += item.getQuantity() * price;
                    }
                }

                String displayName = (items.size() > 1)
                        ? repName + " + " + (items.size() - 1) + " items"
                        : repName;
                representativeItemsMap.put(orderID, displayName);
                orderTotalsMap.put(orderID, totalPrice);
            }

            // FORWARD TO JSP
            request.setAttribute("orderList", orderList);
            request.setAttribute("representativeItemsMap", representativeItemsMap);
            request.setAttribute("orderTotalsMap", orderTotalsMap);

            request.getRequestDispatcher("orderhistory.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}