<%@ page import="iotbay.model.User, iotbay.model.UserType" %>
<%
  Boolean guestMode = (Boolean) session.getAttribute("GuestMode");
  if (guestMode == null) guestMode = false;
  String navPath;
  User user = (User) session.getAttribute("user");

  if (user == null && !guestMode) {
    navPath = "nav_landing.jsp";
  } else if (user == null) {
    navPath = "nav_guest.jsp";
  } else if (user.getUserType() == UserType.CUSTOMER) {
    request.setAttribute("userName", user.getFirstName());
    navPath = "nav_customer.jsp";
  } else {
    request.setAttribute("userName", user.getFirstName());
    if (user.isAdmin()) {
      navPath = "nav_admin.jsp";
    } else {
      navPath = "nav_staff.jsp";
    }
  }

  request.getRequestDispatcher(navPath).include(request, response);
%>