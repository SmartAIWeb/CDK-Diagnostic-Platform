<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<%
  User currentUser = (User) request.getAttribute("user_info");
  boolean isAdmin = currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole());
%>
<header>
  <nav>
    <% if (currentUser != null) { %>
      <a href="controller?request_type=predict">Prédiction</a>
      <a href="controller?request_type=history">Historique</a>
      <a href="controller?request_type=profile">Profil</a>
      <% if (isAdmin) { %><a href="controller?request_type=admin">Administration</a><% } %>
      <a href="controller?request_type=logout">Déconnexion</a>
    <% } else { %>
      <a href="login.jsp">Connexion</a>
      <a href="register.jsp">Inscription</a>
    <% } %>
  </nav>
</header>

