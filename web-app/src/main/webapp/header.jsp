<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<%
    User currentUser = (User) session.getAttribute("logged_user");
    boolean isAdmin = currentUser != null && "admin".equals(currentUser.getRole());
%>
<nav>
    <% if (currentUser != null) { %>
        <a href="profile.jsp">Profil</a> |
        <a href="controller?request_type=predict_page">Prediction</a> |
        <a href="controller?request_type=history">Historique</a> |
        <% if (isAdmin) { %><a href="admin.jsp">Admin</a> |<% } %>
        <a href="controller?request_type=logout">Deconnexion</a>
    <% } else { %>
        <a href="login.jsp">Connexion</a> |
        <a href="register.jsp">Inscription</a>
    <% } %>
</nav>
<hr>
