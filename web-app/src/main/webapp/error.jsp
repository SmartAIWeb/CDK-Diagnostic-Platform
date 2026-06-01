<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Erreur</title>
</head>
<body>
  <%@ include file="header.jsp" %>
  <h2>Une erreur est survenue</h2>
  <% if (request.getAttribute("error_msg") != null) { %>
    <p><%= request.getAttribute("error_msg") %></p>
  <% } %>
  <a href="javascript:history.back()">Retour</a>
</body>
</html>
