<%@ page contentType="text/html;charset=UTF-8" language="java" import="iotbay.model.User, iotbay.model.UserType" %>
<%@ page import="iotbay.model.dao.DAO" %>
<%@ page import="iotbay.model.dao.DBConnector" %>


<%
    DAO dao = new DAO(new DBConnector().getConnection());
    session.setAttribute("dao", dao);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>IoTBay</title>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
        }

        #nav-frame {
            width: 100%;
            height: 10vh;
            border: none;
        }

        #content-frame {
            width: 100%;
            height: 90vh;
            border: none;
        }
    </style>
</head>
<body>

<iframe id="nav-frame" src="nav.jsp" name="navFrame"></iframe>

<iframe id="content-frame" src="landing.jsp" name="contentFrame"></iframe>

</body>
</html>