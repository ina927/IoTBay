<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="iotbay.model.CartItem" %>
<%@ page import="iotbay.model.Payment" %>
<%@ page import="iotbay.model.User" %>
<%@ page import="iotbay.model.Address" %>
<%@ page import="iotbay.model.UserCard" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="iotbay.model.Product" %>


<%
    User user = (User) session.getAttribute("user");
    boolean isGuest = (user == null);

    ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new ArrayList<>();

    double cartTotal = 0;
    for (CartItem item : cart) {
        cartTotal += item.getProductPrice() * item.getQuantity();
    }

    Payment payment = (Payment) request.getAttribute("payment");
    List<Payment> list = (List<Payment>) request.getAttribute("paymentList");




    UserCard savedCard = (UserCard) request.getAttribute("savedCard");
    String street = "", suburb = "", state = "", postcode = "";
    if (!isGuest && user.getAddress() != null) {
        street = user.getAddress().getAddress();
        suburb = user.getAddress().getSuburb();
        state = user.getAddress().getState();
        postcode = user.getAddress().getPostcode();
    }


    String savedCardNumber = "", savedCardHolder = "", savedExpiryDate = "", savedCVV = "", savedMethod = "";
    if (savedCard != null) {
        savedCardNumber = savedCard.getCardNumber();
        savedCardHolder = savedCard.getCardHolder();
        savedExpiryDate = savedCard.getExpiryDate();
        savedCVV = savedCard.getCvv();
        savedMethod = savedCard.getPaymentMethod();
    }
%>


<html>
<head>
    <title>Payment</title>
    <link rel="stylesheet" href="main.css">
    <style>
        body {
            font-family: sans-serif;
            background-color: #dfdfdf;
            margin: 0;
            padding: 30px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            background-color: white;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        h1, h2 {
            text-align: center;
            margin-bottom: 20px;
            color: black;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: black;
            color: white;
        }

        input[type="text"], input[type="date"], select {
            width: 100%;
            padding: 10px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"], button {
            padding: 12px 20px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 0;
            width: 100%;
        }

        input[type="submit"]:hover, button:hover {
            background-color: #333;
        }

        .search-bar input[type="text"] {
            padding: 6px;
            width: 160px;
            margin-right: 8px;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            margin-bottom: 20px;
        }

        .welcome-text {
            font-weight: bold;
            font-size: 16px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }

        hr {
            margin: 30px 0;
            border: 1px solid #ccc;
        }
    </style>


    <script>

        function updateDelivery() {
            const delivery = document.querySelector('input[name="delivery"]:checked').value;
            const cartTotal = parseFloat(document.getElementById('cartTotal').value);
            let deliveryFee = 0;
            let expectation = "";

            if (delivery === 'express') {
                expectation = "1-2 days";
            } else {
                expectation = "5-7 days";
            }

            const total = cartTotal + deliveryFee;
            document.getElementById("deliveryFeeText").innerText = "$" + deliveryFee.toFixed(2);
            document.getElementById("totalText").innerText = "$" + total.toFixed(2);
            document.getElementById("amount").value = total.toFixed(2);
        }

        function toggleAddressEdit() {
            const enabled = document.getElementById("editAddress").checked;
            document.getElementsByName("address")[0].readOnly = !enabled;
            document.getElementsByName("suburb")[0].readOnly = !enabled;
            document.getElementsByName("state")[0].readOnly = !enabled;
            document.getElementsByName("postcode")[0].readOnly = !enabled;
        }

        function formatCardNumber(input) {
            input.value = input.value
                .replace(/\D/g, '')
                .replace(/(.{4})/g, '$1 ')
                .trim();
        }

        function formatExpiryDate(input) {
            input.value = input.value
                .replace(/\D/g, '')
                .replace(/(\d{2})(\d{1,2})/, '$1/$2')
                .substring(0, 5);
        }
    </script>

</head>
<body onload="updateDelivery()">

<% if (request.getAttribute("cardMessage") != null) { %>
<div style="color: red;">
    <%= request.getAttribute("cardMessage") %>
</div>
<% } %>
<div class="container">
    <div class="main-content">
        <h1> Review & Checkout</h1>
        <h2> Cart Summary</h2>
        <table border="1">
            <tr><th>Name</th><th>Price</th><th>Qty</th><th>Total</th></tr>
            <%
                Map<Integer, Product> productMap = (Map<Integer, Product>) request.getAttribute("productMap");
                if (cart != null && !cart.isEmpty()) {
                    for (CartItem item : cart) {
                        Product product = (productMap != null) ? productMap.get(item.getProductID()) : null;
            %>
            <tr>
                <td><%= (product != null) ? product.getName() : item.getProductName() %></td>
                <td>$<%= String.format("%.2f", item.getProductPrice()) %></td>
                <td><%= item.getQuantity() %></td>
                <td>$<%= String.format("%.2f", item.getProductPrice() * item.getQuantity()) %></td>
            </tr>
            <%  }
            } else { %>
            <tr><td colspan="4">Your cart is empty.</td></tr>
            <% } %>

        </table>


        <p><strong>Subtotal: $<%= String.format("%.2f", cartTotal) %></strong></p>

        <!-- 2. Delivery Info -->
        <hr/>
        <h2>Delivery Address</h2>
        <form method="post" action="PaymentServlet">
            <input type="checkbox" id="editAddress" onclick="toggleAddressEdit()"> Change Delivery Address Temporarily<br/><br/>

            <label>Street:</label><br/>
            <input type="text" name="address" value="<%= street %>" readonly required/><br/>
            <label>Suburb:</label><br/>
            <input type="text" name="suburb" value="<%= suburb %>" readonly required/><br/>
            <label>State:</label><br/>
            <input type="text" name="state" value="<%= state %>" readonly required/><br/>
            <label>Postcode:</label><br/>
            <input type="text" name="postcode" value="<%= postcode %>" readonly required/><br/><br/>

            <label>Delivery Option:</label><br/>
            <input type="radio" name="delivery" value="normal" checked onclick="updateDelivery()"/> Normal (5-7 days)<br/>
            <input type="radio" name="delivery" value="express" onclick="updateDelivery()"/> Express (1-2 days)<br/><br/>
            <p><strong>📅 Expected Delivery:</strong> <span id="expectation"></span></p>

            <!-- 3. Payment Info -->


            <hr/>
            <h2>Payment Details</h2>
            <input type="hidden" name="action" value="<%= (payment != null) ? "update" : "create" %>"/>
            <% if (payment != null) { %>
            <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>"/>
            <% } %>
            <input type="hidden" id="cartTotal" value="<%= cartTotal %>"/>
            <input type="hidden" name="amount" id="amount"/>

            <label>Card Number:</label><br/>
            <input type="text" name="cardNumber" id="cardNumber" maxlength="19" required
                   pattern="\d{4} \d{4} \d{4} \d{4}"
                   oninput="formatCardNumber(this)"
                   value="<%= payment != null ? payment.getCardNumber() : savedCardNumber %>"
                   class="card-input"/>

            <label>Card Holder:</label><br/>
            <input type="text" name="cardHolder" required
                   value="<%= payment != null ? payment.getCardHolder() : savedCardHolder %>"
                   class="card-input"/><br/>

            <label>Expiry Date:</label><br/>
            <input type="text" name="expiryDate" id="expiryDate" maxlength="5"
                   placeholder="MM/YY"
                   pattern="(0[1-9]|1[0-2])\/\d{2}" required
                   oninput="formatExpiryDate(this)"
                   value="<%= payment != null ? payment.getExpiryDate() : savedExpiryDate %>"
                   class="card-input"/><br/>

            <label>CVV:</label><br/>
            <input type="text" name="cvv" maxlength="4" pattern="\d{3,4}" required
                   value="<%= payment != null ? payment.getCvv() : savedCVV %>"
                   class="card-input"/><br/>

            Payment Method:
            <select name="method">
                <option value="Visa" <%= ("Visa".equals(payment != null ? payment.getPaymentMethod() : savedMethod)) ? "selected" : "" %>>Visa</option>
                <option value="Mastercard" <%= ("Mastercard".equals(payment != null ? payment.getPaymentMethod() : savedMethod)) ? "selected" : "" %>>Mastercard</option>
                <option value="AMEX" <%= ("AMEX".equals(payment != null ? payment.getPaymentMethod() : savedMethod)) ? "selected" : "" %>>AMEX</option>
            </select><br/>
            Payment Date: <input type="date" name="paymentDate" value="<%= (payment != null) ? payment.getPaymentDate() : java.time.LocalDate.now() %>" required /><br/>
            <% if (!isGuest) { %>
            <br/>
            <label>
                <input type="checkbox" name="saveCard" value="true"/>
                Save this card information to my account
            </label><br/>
            <% } %>




            <!-- 4. Total Summary -->
            <hr/>
            <h2>Final Total</h2>
            <p>Cart Total: $<%= String.format("%.2f", cartTotal) %></p>
            <p>Delivery Fee: <span id="deliveryFeeText">$0.00</span></p>
            <p><strong>Final Total: <span id="totalText">$<%= String.format("%.2f", cartTotal) %></span></strong></p>

            <input type="submit" value="<%= (payment != null) ? "Update Payment" : "Confirm & Pay" %>"/>
        </form>


        <form method="get" action="PaymentServlet" style="margin-top: 20px;">
            <input type="submit" value="Show Saved Payment Info" />
        </form>
        <% if (!isGuest && savedCard != null) { %>
        <form method="post" action="DeleteCardServlet" style="margin: 10px 0;">
            <button type="submit"
                    style="font-size: 12px; padding: 4px 8px; background-color: #000000; color: white; border: none; border-radius: 4px; width: auto; min-width: 150px; display: inline-block;"
                    onclick="return confirm('Are you sure you want to delete your stored card details?');">
                Delete Stored Card
            </button>
        </form>
        <% } %>


        <!-- 5. Payment History -->
        <hr/>
        <h2>Payment History</h2>

        <form method="get" action="PaymentServlet">
            <input type="text" name="paymentId" placeholder="Search by Payment ID">
            <input type="text" name="date" placeholder="YYYY-MM-DD">
            <input type="submit" value="Search">
        </form>


        <table border="1">
            <tr>
                <th>Payment ID</th>
                <th>Order ID</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
            <% if (list != null && !list.isEmpty()) {
                for (Payment p : list) { %>
            <tr>
                <td><%= p.getPaymentId() %></td>
                <td><%= p.getOrderId() %></td>
                <td>$<%= String.format("%.2f", p.getAmount()) %></td>
                <td><%= p.getPaymentDate() %></td>
                <td>
                    <a href="PaymentServlet?action=edit&paymentId=<%= p.getPaymentId() %>">Edit</a> |
                    <form method="post" action="PaymentServlet" style="display:inline;">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>"/>
                        <input type="submit" value="Delete" onclick="return confirm('Delete this payment?');"/>
                    </form>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="5">No saved payments found.</td></tr>
            <% } %>
        </table>


    </div>
</div>

</body>
</html>