
package iotbay.controller;

import iotbay.model.*;
import iotbay.model.dao.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        DAO dao = (DAO) session.getAttribute("dao");
        User user = (User) session.getAttribute("user");

        if (dao == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            if (user != null) {
                UserCardManager userCardManager = dao.userCardManager();
                UserCard savedCard = userCardManager.getCardByUserId(user.getId());
                if (savedCard != null) {
                    request.setAttribute("savedCard", savedCard);
                } else {
                    request.setAttribute("cardMessage", "No saved card found for this user.");
                }
            }

            PaymentManager paymentManager = dao.paymentManager();
            String action = request.getParameter("action");
            String dateRaw = request.getParameter("date");
            String paymentIdStr = request.getParameter("paymentId");

            if ("edit".equals(action) && paymentIdStr != null) {
                int paymentId = Integer.parseInt(paymentIdStr);
                Payment payment = paymentManager.findPaymentById(paymentId);
                request.setAttribute("payment", payment);

            } else if (paymentIdStr != null && !paymentIdStr.isEmpty()) {
                try {
                    int paymentId = Integer.parseInt(paymentIdStr);
                    Payment payment = paymentManager.findPaymentById(paymentId);
                    List<Payment> result = new ArrayList<>();
                    if (payment != null) result.add(payment);
                    request.setAttribute("paymentList", result);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid Payment ID format");
                }

            } else if (dateRaw != null && !dateRaw.isEmpty()) {
                String formattedDate = dateRaw.replace("-", "/");
                List<Payment> payments = paymentManager.searchPaymentsByFormattedDate(formattedDate);
                request.setAttribute("paymentList", payments);

            } else {
                int userId = (user != null) ? user.getId() : 0;
                List<Payment> payments = paymentManager.fetchPaymentsByUser(userId);
                request.setAttribute("paymentList", payments);
            }

            request.getRequestDispatcher("Payment.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading payment history.");
            request.getRequestDispatcher("Payment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        DAO dao = (DAO) session.getAttribute("dao");
        ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("cart");
        try {
            InventoryManager inventoryManager = dao.inventoryManager();
            for (CartItem item : cart) {
                int availableStock = inventoryManager.getStockQuantity(item.getProductID());
                if (item.getQuantity() > availableStock) {
                    request.setAttribute("error", "Not enough stock for " + item.getProductName() + ". Only " + availableStock + " left.");
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during stock verification.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        if (dao == null || cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String action = request.getParameter("action");
        PaymentManager paymentManager = dao.paymentManager();
        UserCardManager cardManager = dao.userCardManager();

        try {
            if ("delete".equals(action)) {
                int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                paymentManager.deletePayment(paymentId);
                response.sendRedirect("PaymentServlet");
                return;
            }

            String address = request.getParameter("address");
            String suburb = request.getParameter("suburb");
            String state = request.getParameter("state");
            String postcode = request.getParameter("postcode");

            String method = request.getParameter("method");
            String cardNumber = request.getParameter("cardNumber");
            String cardHolder = request.getParameter("cardHolder");
            String expiryDate = request.getParameter("expiryDate");
            String cvv = request.getParameter("cvv");
            String amountStr = request.getParameter("amount");
            String rawDate = request.getParameter("paymentDate");
            boolean saveCard = "true".equals(request.getParameter("saveCard"));

            java.time.LocalDate dateObj = java.time.LocalDate.parse(rawDate);
            String paymentDate = dateObj.format(java.time.format.DateTimeFormatter.ofPattern("yyyy/MM/dd"));

            if (method == null || cardNumber == null || cardHolder == null || expiryDate == null ||
                    cvv == null || amountStr == null || paymentDate == null) {
                throw new Exception("Need fill in correct format");
            }

            int userId = (user != null) ? user.getId() : 0;
            double amount = Double.parseDouble(amountStr);

            OrderManager orderManager = dao.orderManager();
            String orderDate = java.time.LocalDate.now().toString();
            orderManager.addOrder(userId != 0 ? userId : null, orderDate, "Confirmed");
            int orderId = orderManager.getLatestOrderID();

            for (CartItem item : cart) {
                orderManager.addOrderItem(orderId, item.getProductID(), item.getQuantity());
            }

            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setUserId(userId);
            payment.setPaymentMethod(method);
            payment.setCardNumber(cardNumber);
            payment.setCardHolder(cardHolder);
            payment.setExpiryDate(expiryDate);
            payment.setCvv(cvv);
            payment.setAmount(amount);
            payment.setPaymentDate(paymentDate);
            payment.setAddress(address);
            payment.setSuburb(suburb);
            payment.setState(state);
            payment.setPostcode(postcode);

            if (user != null && saveCard) {
                UserCard card = new UserCard();
                card.setUserId(userId);
                card.setCardNumber(cardNumber);
                card.setCardHolder(cardHolder);
                card.setExpiryDate(expiryDate);
                card.setCvv(cvv);
                card.setPaymentMethod(method);
                cardManager.addCard(card);
            }

            if ("update".equals(action)) {
                payment.setPaymentId(Integer.parseInt(request.getParameter("paymentId")));
                paymentManager.updatePayment(payment);
            } else {
                paymentManager.addPayment(payment);
            }

            cart.clear();
            session.setAttribute("cart", cart);

            ArrayList<OrderItem> orderItems = orderManager.getOrderItemsByOrderID(orderId);
            Map<Integer, Product> productMap = new HashMap<>();
            for (OrderItem item : orderItems) {
                Product product = dao.productManager().fetchProductById(item.getProductID());
                if (product != null) {
                    productMap.put(item.getProductID(), product);
                }
            }

            double total = 0;
            for (OrderItem item : orderItems) {
                Product product = productMap.get(item.getProductID());
                if (product != null) {
                    total += product.getPrice() * item.getQuantity();
                }
            }

            request.setAttribute("payment", payment);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("productMap", productMap);
            request.setAttribute("orderTotal", total);

            request.getRequestDispatcher("summary.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Payment.jsp");
        }
    }
}
