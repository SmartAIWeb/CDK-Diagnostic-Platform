<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  User user = (User) request.getAttribute("user_info");
  if (user == null) {
%>
  <jsp:forward page="login.jsp" />
<%
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Administration</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>
    <section class="admin-container">
      <h1>Tableau de bord Administrateur</h1>

      <% if (request.getAttribute("error_msg") != null) { %>
        <div class="error-message">
          <p><%= request.getAttribute("error_msg") %></p>
        </div>
      <% } %>

      <div class="table-container">
        <h2>Gestion des Utilisateurs</h2>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Prenom</th>
              <th>Nom</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty all_users}">
                <c:forEach var="u" items="${all_users}">
                  <tr>
                    <td>${u.userId}</td>
                    <td>${u.firstName}</td>
                    <td>${u.lastName}</td>
                    <td>${u.email}</td>
                    <td>${u.role}</td>
                    <td>
                      <a href="controller?request_type=history&userId=${u.userId}">Voir Historique</a>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6">Aucun utilisateur trouve.</td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <footer></footer>
</body>
</html>
