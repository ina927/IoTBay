<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="iotbay.model.User" %>
<%@ page import="java.util.List" %>

<%
    // servlet redirect
    if (request.getAttribute("userList") == null) {
        response.sendRedirect("AdminUserListServlet");
        return;
    }

    // Controller connection
    List<User> userList = (List<User>) request.getAttribute("userList");
    User editUser = (User) request.getAttribute("editUser");
    String action = (String) request.getAttribute("action");
    String typeFilter = (String) request.getAttribute("typeFilter");
    String nameFilter = (String) request.getAttribute("nameFilter");
    String phoneFilter = (String) request.getAttribute("phoneFilter");
    String error = (String) request.getAttribute("error");
    String createError = (String) request.getAttribute("createError");
    String[] formData = (String[]) request.getAttribute("createFormData");
    String userTypeLabel = (String) request.getAttribute("userTypeLabel");
    String addressDisplay = (String) request.getAttribute("addressDisplay");
    String statusClass = (String) request.getAttribute("statusClass");
    String emailToDelete = (String) request.getAttribute("emailToDelete");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Admin Panel</title>
    <style>
        body { margin:0; font-family:sans-serif; background:#dfdfdf; }
        h1 { text-align:center; margin:20px; color:#333; }
        .controls {
            display:flex; justify-content:center; gap:10px; margin-bottom:20px;
        }
        .controls input, .controls button {
            padding:8px; font-size:14px;
        }
        .create-button {
            background:#546e7a; color:white; border:none; border-radius:8px;
            cursor:pointer;
        }
        .create-button:hover { background:black; }
        table {
            width:90%; margin:auto; border-collapse:collapse; background:whitesmoke;
        }
        th, td {
            border:1px solid #ddd; padding:10px; text-align:center;
        }
        th { background:#5A6E7F; color:#fff; }
        /*.status-enable { color:#00796b; font-weight:bold; }*/
        /*.status-disable { color:gray; font-weight:bold; }*/
        .edit-button, .delete-button {
            padding:5px 10px; border:none; border-radius:6px;
            cursor:pointer; color:white;
        }
        .edit-button { background:#546e7a; }
        .delete-button { background:#914646; }
        .modal-backdrop {
            position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.4); z-index:1000;
        }
        .modal {
            position:fixed; top:50%; left:50%;
            transform:translate(-50%,-50%);
            background:whitesmoke; border-radius:8px;
            width:480px; max-width:95%; z-index:1001;
            box-shadow:0 4px 16px rgba(0,0,0,0.3);
            display:flex; flex-direction:column;
        }
        .modal-header, .modal-footer {
            padding:16px; background:#eeeeee;
        }
        .modal-header { border-bottom:1px solid #ccc; }
        .modal-footer {
            padding:16px; background:#eeeeee;
            border-top:1px solid #ccc;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }
        .modal-title { margin:0; font-size:20px; }
        .modal-body {
            padding:16px;
            display:grid; grid-template-columns:1fr 1fr; gap:12px;
        }
        .modal-body .full { grid-column:1 / -1; }
        .modal-body label {
            display:block; margin-bottom:4px; font-weight:600;
        }
        .modal-body input, .modal-body select {
            width:100%; padding:8px; border:1px solid #ccc;
            border-radius:4px; box-sizing:border-box;
        }
        .btn-primary, .btn-secondary {
            padding:8px 16px; border:none; border-radius:4px;
            cursor:pointer; font-size:14px;
        }
        .btn-primary { background:black; color:#fff; }
        .btn-secondary { background:gray; color:#fff; }
        .error {
            grid-column:1 / -1; color:#c00;
            text-align:center; margin-bottom:8px;
        }
    </style>
</head>
<body>

<h1>Admin Dashboard</h1>

<!-- filter / search -->
<div class="controls">
    <form method="get" action="AdminUserListServlet">
        <input type="text" name="searchFullName" placeholder="Search Full Name"
               value="<%= nameFilter != null ? nameFilter : "" %>">
        <input type="text" name="searchPhone" placeholder="Search Phone"
               value="<%= phoneFilter != null ? phoneFilter : "" %>">
        <button type="submit" name="typeFilter" value="ALL">All</button>
        <button type="submit" name="typeFilter" value="CUSTOMER">Customer</button>
        <button type="submit" name="typeFilter" value="STAFF">Staff</button>
    </form>
    <form method="get" action="AdminUserListServlet">
        <input type="hidden" name="action" value="create">
        <button type="submit" class="create-button">+ Create</button>
    </form>

</div>

<!-- user view -->
<table>
    <thead>
    <tr>
        <th>User Type</th><th>First Name</th><th>Last Name</th>
        <th>Email</th><th>Phone</th><th>Address</th>
        <th>Status</th><th>Action</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (User u : userList) {
            if ("deleted".equals(u.getStatus())) continue;
    %>
    <tr>
        <td><%= request.getAttribute("userTypeLabel_" + u.getId()) %></td>
        <td><%= u.getFirstName() %></td>
        <td><%= u.getLastName()  %></td>
        <td><%= u.getEmail()     %></td>
        <td><%= u.getContact()   %></td>
        <td><%= request.getAttribute("addressDisplay_" + u.getId()) %></td>
        <td class="<%= request.getAttribute("statusClass_" + u.getId()) %>">
            <%= u.getStatus() %>
        </td>
        <td>
            <% if ("deleted".equals(u.getStatus())) { %>
            <span style="color:gray; font-style:italic;">Deleted</span>
            <% } else if ("admin@iotbay.com".equals(u.getEmail())) { %>
            <span style="color:gray; font-weight:bold;">Default</span>
            <% } else { %>
            <form method="get" action="AdminUserListServlet" style="display:inline;">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userId" value="<%= u.getId() %>">
                <button class="edit-button" type="submit">Edit</button>
            </form>
            <form method="get" action="AdminUserListServlet" style="display:inline;">
                <input type="hidden" name="action" value="confirmDelete">
                <input type="hidden" name="userId" value="<%= u.getId() %>">
                <button class="delete-button" type="submit">Delete</button>
            </form>
            <% } %>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>

<!-- create modal -->
<% if ("create".equals(action)) { %>
<div class="modal-backdrop"></div>
<div class="modal">
    <div class="modal-header">
        <h2 class="modal-title">Create New User</h2>
    </div>
    <form action="AdminCreateUserServlet" method="post">
        <div class="modal-body">
            <% if (createError != null) { %>
                <div class="error">
                    <% if ("exists".equals(createError)) { %>
                        This email already exists.
                    <% } else if ("incomplete_address".equals(createError)) { %>
                        Please fill in all address fields or leave all blank.
                    <% } else if ("blank_fields".equals(createError)) { %>
                        Please fill in all required fields.
                    <% } else if ("server".equals(createError)) { %>
                        Server error occurred. Please try again.
                    <% } %>
                </div>
            <% } %>

            <div><label>First Name</label>
                <input type="text" name="firstName" value="<%= formData != null ? formData[0] : "" %>" required></div>
            <div><label>Last Name</label>
                <input type="text" name="lastName" value="<%= formData != null ? formData[1] : "" %>" required></div>
            <div><label>Email</label>
                <input type="email" name="email" value="<%= formData != null ? formData[2] : "" %>" required></div>
            <div><label>Password</label>
                <input type="password" name="password" value="<%= formData != null ? formData[3] : "" %>" required></div>
            <div><label>Phone</label>
                <input type="text" name="contact" value="<%= formData != null ? formData[4] : "" %>" required></div>
            <div class="full"><label>User Type</label>
                <select name="userType" required>
                    <option value="">Select User Type</option>
                    <option value="0" <%= formData != null && "0".equals(formData[5]) ? "selected" : "" %>>Customer</option>
                    <option value="1" <%= formData != null && "1".equals(formData[5]) ? "selected" : "" %>>Staff</option>
                </select>
            </div>

            <div class="full">
                <label for="hasAddress" style="display:inline-flex;align-items:center;gap:6px;margin:0;font-weight:600;white-space:nowrap;">
                    <input type="checkbox" name="hasAddress" id="hasAddress" onclick="toggleAddressFields()">
                    Add Address
                </label>
            </div>

            <div><label>Street Address</label>
                <input type="text" name="street" id="street"></div>
            <div><label>Suburb / City</label>
                <input type="text" name="suburb" id="suburb"></div>
            <div><label>State</label>
                <select name="state" id="state">
                    <option value="">Select State</option>
                    <option value="NSW">NSW</option>
                    <option value="VIC">VIC</option>
                    <option value="QLD">QLD</option>
                </select></div>
            <div><label>Postcode</label>
                <input type="text" name="postcode" id="postcode" pattern="\d{4}"></div>
        </div>
        <div class="modal-footer">
            <a href="AdminUserListServlet" class="btn-secondary">Cancel</a>
            <button type="submit" class="btn-primary">Create</button>
        </div>
    </form>
</div>
<% } %>

<!-- modifiy modal -->
<% if ("edit".equals(action) && editUser != null) { %>
<div class="modal-backdrop"></div>
<div class="modal">
    <div class="modal-header">
        <h2 class="modal-title">Edit User</h2>
    </div>
    <form action="AdminUpdateUserServlet" method="post">
        <div class="modal-body">
            <% if ("blank_fields".equals(error)) { %>
            <div class="error">Please fill in all required fields.</div>
            <% } %>

            <input type="hidden" name="userId" value="<%= editUser.getId() %>">

            <div><label>First Name</label>
                <input type="text" name="firstName" value="<%= editUser.getFirstName() %>" required></div>
            <div><label>Last Name</label>
                <input type="text" name="lastName" value="<%= editUser.getLastName() %>" required></div>
            <div><label>Phone</label>
                <input type="text" name="contact" value="<%= editUser.getContact() %>" required></div>

            <div class="full"><label>Status</label>
                <select name="status">
                    <option value="active" <%= "active".equals(editUser.getStatus())?"selected":"" %>>Active</option>
                    <option value="inactive" <%= "inactive".equals(editUser.getStatus())?"selected":"" %>>Inactive</option>
                </select></div>

            <div class="full">
                <label for="editHasAddress" style="display:inline-flex;align-items:center;gap:6px;margin:0;font-weight:600;white-space:nowrap;">
                    <input type="checkbox" name="hasAddress" id="editHasAddress" onclick="toggleEditAddressFields()">
                    Edit Address
                </label>
            </div>

            <div><label>Street Address</label>
                <input type="text" name="street" id="editStreet"
                       value="<%= (editUser.getAddress()!=null && editUser.getAddress().getAddress()!=null)
                           ? editUser.getAddress().getAddress() : "" %>"></div>
            <div><label>Suburb / City</label>
                <input type="text" name="suburb" id="editSuburb"
                       value="<%= (editUser.getAddress()!=null && editUser.getAddress().getSuburb()!=null)
                           ? editUser.getAddress().getSuburb() : "" %>"></div>
            <div><label>State</label>
                <select name="state" id="editState">
                    <option value="">Select State</option>
                    <option value="NSW" <%= "NSW".equals(editUser.getAddress()!=null
                            ? editUser.getAddress().getState() : "")?"selected":"" %>>NSW</option>
                    <option value="VIC" <%= "VIC".equals(editUser.getAddress()!=null
                            ? editUser.getAddress().getState() : "")?"selected":"" %>>VIC</option>
                    <option value="QLD" <%= "QLD".equals(editUser.getAddress()!=null
                            ? editUser.getAddress().getState() : "")?"selected":"" %>>QLD</option>
                </select></div>
            <div><label>Postcode</label>
                <input type="text" name="postcode" id="editPostcode" pattern="\d{4}"
                       value="<%= (editUser.getAddress()!=null && editUser.getAddress().getPostcode()!=null)
                           ? editUser.getAddress().getPostcode() : "" %>"></div>
        </div>
        <div class="modal-footer">
            <a href="AdminUserListServlet" class="btn-secondary">Cancel</a>
            <button type="submit" class="btn-primary">Update</button>
        </div>
    </form>
</div>
<% } %>

<!-- delte modal -->
<% if ("confirmDelete".equals(action) && emailToDelete != null && !emailToDelete.isEmpty()) { %>
<div class="modal-backdrop"></div>
<div class="modal">
    <div class="modal-header">
        <h2 class="modal-title">Confirm Delete</h2>
    </div>
    <div class="modal-body" style="text-align:center;">
        This user will be permanently deleted from the database.<br><br>
        Are you sure you want to delete?<br>
        <b><%= emailToDelete %></b>
    </div>
    <div class="modal-footer">
        <a href="AdminUserListServlet" class="btn-secondary">Cancel</a>
        <form action="AdminDeleteUserServlet" method="post" style="display:inline;">
            <input type="hidden" name="userId" value="<%= request.getParameter("userId") %>">
            <button type="submit" class="btn-primary">Delete</button>
        </form>
    </div>
</div>
<% } %>

<script>
    function toggleAddressFields() {
        var checked = document.getElementById('hasAddress').checked;
        document.getElementById('street').disabled = !checked;
        document.getElementById('suburb').disabled = !checked;
        document.getElementById('state').disabled = !checked;
        document.getElementById('postcode').disabled = !checked;
    }
    function toggleEditAddressFields() {
        var checked = document.getElementById('editHasAddress').checked;
        document.getElementById('editStreet').disabled = !checked;
        document.getElementById('editSuburb').disabled = !checked;
        document.getElementById('editState').disabled = !checked;
        document.getElementById('editPostcode').disabled = !checked;
    }
    window.onload = function() {
        if (document.getElementById('hasAddress')) toggleAddressFields();
        if (document.getElementById('editHasAddress')) toggleEditAddressFields();
    };
</script>

</body>
</html>