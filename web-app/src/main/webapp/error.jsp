<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Erreur</title>
  <link rel="stylesheet" href="css/error.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>
    <section class="error-container">
      <h2>Une erreur est survenue</h2>

      <div class="error-message">
        <% if (request.getAttribute("error_msg") != null) { %>
          <p><%= request.getAttribute("error_msg") %></p>
        <% } else { %>
          <p>Une erreur inattendue s'est produite.</p>
        <% } %>
      </div>

      <div class="error-actions">
        <a href="javascript:history.back()">Retour</a> |
        <a href="profile.jsp">Accueil</a>
      </div>
    </section>
  </main>

  <footer></footer>
</body>
</html>
