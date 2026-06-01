<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Connexion</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>
    <section class="form-container">
      <h2>Connexion</h2>

      <% if (request.getAttribute("error_msg") != null) { %>
        <div class="error-message">
          <p><%= request.getAttribute("error_msg") %></p>
        </div>
      <% } %>

      <form action="controller" method="POST">
        <input type="hidden" name="request_type" value="login">

        <div class="form-group">
          <label for="email">Email :</label>
          <input type="email" id="email" name="email" placeholder="Email" required>
        </div>

        <div class="form-group">
          <label for="password">Mot de passe :</label>
          <input type="password" id="password" name="password" placeholder="Mot de passe" required>
        </div>

        <div class="form-actions">
          <button type="submit">Connexion</button>
        </div>
      </form>

      <p>Vous n'avez pas de compte ? <a href="register.jsp">Creez votre compte ici</a></p>
    </section>
  </main>

  <footer></footer>
</body>
</html>
