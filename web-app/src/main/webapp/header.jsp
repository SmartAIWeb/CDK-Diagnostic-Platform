<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<%
  User currentUser = (User) request.getAttribute("user_info");
  boolean isAdmin = currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole());
%>
<header>
  <nav>
    <% if (currentUser != null) { %>
      <a href="profile.jsp">Profil</a> |
      <a href="predict.jsp">Prediction</a> |
      <a href="controller?request_type=history">Historique</a> |
      <% if (isAdmin) { %><a href="admin.jsp">Admin</a> |<% } %>
      <a href="controller?request_type=logout">Deconnexion</a>
    <% } else { %>
      <a href="login.jsp">Connexion</a> |
      <a href="register.jsp">Inscription</a>
    <% } %>
  </nav>
  <link rel="stylesheet" href="css/header.css">
</header>
<hr>
