<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Inscription</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>
    <section class="form-container">
      <h2>Creer un compte</h2>

      <% if (request.getAttribute("error_msg") != null) { %>
        <div class="error-message">
          <p><%= request.getAttribute("error_msg") %></p>
        </div>
      <% } %>

      <form action="controller" method="POST">
        <input type="hidden" name="request_type" value="register">

        <div class="form-group">
          <label for="firstName">Prenom :</label>
          <input type="text" id="firstName" name="firstName" placeholder="Prenom" required>
        </div>

        <div class="form-group">
          <label for="lastName">Nom :</label>
          <input type="text" id="lastName" name="lastName" placeholder="Nom" required>
        </div>

        <div class="form-group">
          <label for="age">Age :</label>
          <input type="number" id="age" name="age" placeholder="Age" min="0" max="150">
        </div>

        <div class="form-group">
          <label for="gender">Genre :</label>
          <select id="gender" name="gender">
            <option value="male">Masculin</option>
            <option value="female">Feminin</option>
          </select>
        </div>

        <div class="form-group">
          <label for="email">Email :</label>
          <input type="email" id="email" name="email" placeholder="Email" required>
        </div>

        <div class="form-group">
          <label for="password">Mot de passe :</label>
          <input type="password" id="password" name="password" placeholder="Mot de passe" required>
        </div>

        <div class="form-actions">
          <button type="submit">S'inscrire</button>
        </div>
      </form>

      <p>Vous avez deja un compte ? <a href="login.jsp">Connectez-vous ici</a></p>
    </section>
  </main>

  <footer></footer>
</body>
</html>
