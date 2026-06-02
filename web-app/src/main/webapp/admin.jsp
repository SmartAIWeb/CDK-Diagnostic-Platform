<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  User user = (User) session.getAttribute("user_info");
  if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect("login.jsp");
      return;
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
      <div class="table-container" style="margin-top:20px;">
        <h2>Demandes de Administration en attente</h2>
        <table>
          <thead>
            <tr>
              <th>Email</th>
              <th>Message</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty mod_requests}">
                <c:forEach var="req" items="${mod_requests}">
                  <tr>
                    <td>${req.email}</td>
                    <td>${req.message}</td>
                    <td>
                      <form action="controller" method="POST" style="display:inline;">
                        <input type="hidden" name="request_type" value="approve_moderator">
                        <input type="hidden" name="request_id" value="${req.id}">
                        <input type="hidden" name="user_id" value="${req.userId}">
                        <button type="submit" class="btn btn-approve">Approuver</button>
                      </form>

                      <form action="controller" method="POST" style="display:inline;">
                        <input type="hidden" name="request_type" value="reject_moderator">
                        <input type="hidden" name="request_id" value="${req.id}">
                        <button type="submit" class="btn btn-reject">Rejeter</button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="3">Aucune demande en attente.</td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </main>
  <footer data-year="2026"></footer>
</body>
</html>
