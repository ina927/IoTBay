<%@ page contentType="text/html;charset=UTF-8" language="java" import="iotbay.model.User" %>
<%@ page import="iotbay.model.Address" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="iotbay.model.CartItem" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>Checkout - IoT Bay</title>
    <link rel="stylesheet" href="main.css">
    <style>
        .modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); padding-top: 60px; }
        .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; width: 80%; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; }
        .close:hover, .close:focus { color: black; text-decoration: none; cursor: pointer; }
        .delivery-button { padding: 10px 20px; background-color: black; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin: 5px; transition: background-color 0.3s; }
        .delivery-button.selected { background-color: #45a049; }
        .delivery-button.deselected { background-color: black; }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    boolean guestParam = "true".equals(request.getParameter("guestMode"));
    boolean isGuest = (user == null || guestParam);
    ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("cart");
    double itemsTotal = 0.0;
    if(cart != null) {
        for(CartItem item : cart) {
            itemsTotal += (item.getProductPrice() * item.getQuantity());
        }
    }
%>
<div class="container">
    <div class="header">
        <div class="nav">
            <div class="welcome-text">
                <% if(!isGuest) { %>
                Welcome, <%= user.getFirstName() %>
                <% } else { %>
                Welcome Guest
                <% } %>
            </div>
            <% if(!isGuest) { %>
            <a href="logoutpage.jsp" class="button">Logout</a>
            <% } else { %>
            <a href="landing.jsp" class="button">Home</a>
            <% } %>
        </div>
    </div>

    <div class="checkout-container">
        <h1>Checkout</h1>

        <!-- 1. Review Items -->
        <div class="section">
            <div class="section-header"><h2>1. Review Items</h2></div>
            <div class="cart-items">
                <% if(cart != null && !cart.isEmpty()) {
                    for(CartItem item : cart) {
                        double itemTotal = item.getProductPrice() * item.getQuantity();
                %>
                <div class="cart-item" style="display: flex; margin-bottom: 10px; padding: 10px; border-bottom: 1px solid #eee;">
                    <div style="width: 60px; margin-right: 10px;">
                        <img src="<%= request.getContextPath() + item.getImageUrl() %>" width="50" height="50" alt="<%= item.getProductName() %>">
                    </div>
                    <div style="flex-grow: 1;">
                        <strong><%= item.getProductName() %></strong><br>
                        Price: $<%= String.format("%.2f", item.getProductPrice()) %> × <%= item.getQuantity() %>
                    </div>
                    <div style="text-align: right; min-width: 80px;">$<%= String.format("%.2f", itemTotal) %></div>
                </div>
                <% }} else { %>
                <p>Your cart is empty. <a href="BrowseProductServlet">Continue shopping</a></p>
                <% } %>
            </div>
            <div class="total-price">
                <h3>Total: $<%= String.format("%.2f", itemsTotal) %></h3>
            </div>
        </div>

        <!-- 2. Shipping Address -->
        <div class="section">
            <div class="section-header">
                <h2>2. Shipping Address</h2>
                <button onclick="openAddressModal()">Change</button>
            </div>
            <div id="current-address">
                <% if(!isGuest && user.getAddress() != null) {
                    Address address = user.getAddress(); %>
                <strong><%= user.getFirstName() + " " + user.getLastName() %></strong><br>
                <%= address.getAddress() %><br>
                <%= address.getSuburb() %>, <%= address.getPostcode() %><br>
                Phone: <%= user.getContact() %>
                <% } else { %>
                <p>Please add a shipping address</p>
                <button onclick="openAddressModal()">Add Address</button>
                <% } %>
            </div>
        </div>

        <!-- 3. Choose Delivery -->
        <div class="section">
            <div class="section-header"><h2>3. Choose Delivery Date</h2></div>
            <div id="delivery-options">
                <button class="delivery-button deselected" onclick="selectDeliveryOption('Express', this)">Express Delivery (Fee: $9.99) - <span class="duration">1 day</span></button>
                <button class="delivery-button deselected" onclick="selectDeliveryOption('Standard', this)">Standard Delivery (Free) - <span class="duration">3–5 days</span></button>
            </div>
        </div>

        <!-- 4. Payment -->
        <div class="section">
            <div class="section-header">
                <h2>4. Payment Method</h2>
                <button onclick="openPaymentModal()">Change</button>
            </div>
            <div id="current-payment">
                <strong>Credit Card</strong><br>
                **** **** **** 1234<br>
                Expiry: 12/25
            </div>
        </div>

        <!-- Order Summary -->
        <div class="section">
            <div class="section-header"><h2>Order Summary</h2></div>
            <div class="order-summary">
                <% double shippingFee = 0.00;
                    double subtotal = itemsTotal + shippingFee;
                    double tax = subtotal * 0.1;
                    double total = subtotal + tax; %>
                <div>Items: $<%= String.format("%.2f", itemsTotal) %></div>
                <div>Shipping & Handling: <span id="shipping-fee">$<%= String.format("%.2f", shippingFee) %></span></div>
                <div>Total before tax: <span id="subtotal">$<%= String.format("%.2f", subtotal) %></span></div>
                <div>Estimated GST/HST: <span id="tax">$<%= String.format("%.2f", tax) %></span></div>
                <div><strong>Order Total: <span id="total">$<%= String.format("%.2f", total) %></span></strong></div>
            </div>
            <form action="summary.jsp" method="post" style="margin-top: 20px;">
                <button type="submit" style="width: 100%; padding: 12px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer;">Place Your Order</button>
            </form>
        </div>
    </div>
</div>

<!-- Address Modal -->
<div id="address-modal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeAddressModal()">&times;</span>
        <h2>Change Shipping Address</h2>
        <form id="address-form" onsubmit="updateAddress(event)">
            <input type="text" id="address" placeholder="Enter your address" required><br>
            <input type="text" id="suburb" placeholder="Enter suburb" required><br>
            <input type="text" id="postcode" placeholder="Enter postcode" required><br>
            <input type="text" id="contact" placeholder="Enter contact number" required><br>
            <button type="submit">Save Address</button>
        </form>
    </div>
</div>

<!-- Payment Modal -->
<div id="payment-modal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closePaymentModal()">&times;</span>
        <h2>Change Payment Method</h2>
        <form id="payment-form" onsubmit="updatePayment(event)">
            <input type="text" id="cardNumber" placeholder="Enter card number" required><br>
            <input type="text" id="expiry" placeholder="Enter expiry date (MM/YY)" required><br>
            <input type="text" id="cvv" placeholder="Enter CVV" required><br>
            <button type="submit">Save Payment</button>
        </form>
    </div>
</div>

<!-- JavaScript -->
<script>
    function openAddressModal() { document.getElementById('address-modal').style.display = "block"; }
    function closeAddressModal() { document.getElementById('address-modal').style.display = "none"; }
    function openPaymentModal() { document.getElementById('payment-modal').style.display = "block"; }
    function closePaymentModal() { document.getElementById('payment-modal').style.display = "none"; }

    function updateAddress(event) {
        event.preventDefault();
        const address = document.getElementById('address').value;
        const suburb = document.getElementById('suburb').value;
        const postcode = document.getElementById('postcode').value;
        const contact = document.getElementById('contact').value;
        document.getElementById('current-address').innerHTML = `<strong>Your Name</strong><br>${address}<br>${suburb}, ${postcode}<br>Phone: ${contact}`;
        closeAddressModal();
    }

    function updatePayment(event) {
        event.preventDefault();
        const cardNumber = document.getElementById('cardNumber').value;
        const expiry = document.getElementById('expiry').value;
        const cvv = document.getElementById('cvv').value;

        if (!validateCardInfo(cardNumber, expiry, cvv)) {
            alert("Please enter valid card information.");
            return;
        }
        document.getElementById('current-payment').innerHTML = `<strong>Credit Card</strong><br>**** **** **** ${cardNumber.slice(-4)}<br>Expiry: ${expiry}`;
        closePaymentModal();
    }

    function validateCardInfo(cardNumber, expiry, cvv) {
        const cardNumberPattern = /^[0-9]{4}(\s|-)?[0-9]{4}(\s|-)?[0-9]{4}(\s|-)?[0-9]{4}$/;
        const expiryPattern = /^(0[1-9]|1[0-2])\/\d{2}$/;
        const cvvPattern = /^[0-9]{3}$/;
        return cardNumberPattern.test(cardNumber) && expiryPattern.test(expiry) && cvvPattern.test(cvv);
    }

    function selectDeliveryOption(type, button) {
        const shippingFee = type === 'Express' ? 9.99 : 0.00;
        document.querySelectorAll('.delivery-button').forEach(btn => {
            btn.classList.remove('selected');
            btn.classList.add('deselected');
        });
        button.classList.remove('deselected');
        button.classList.add('selected');

        document.getElementById('shipping-fee').textContent = `$${shippingFee.toFixed(2)}`;
        const itemsTotal = <%= itemsTotal %>;
        const subtotal = itemsTotal + shippingFee;
        const tax = subtotal * 0.1;
        const total = subtotal + tax;

        document.getElementById('subtotal').textContent = '$' + subtotal.toFixed(2);
        document.getElementById('tax').textContent = '$' + tax.toFixed(2);
        document.getElementById('total').textContent = '$' + total.toFixed(2);
    }
</script>
</body>
</html>
