<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Mon Profil</title>
</head>
<body>
  <h2>Profil Utilisateur</h2>
  <%User user = (User) request.getAttribute("user_info");%>
  <%if(user!=null) { %>
    <form method="post" action="controller">
      <input type="hidden" name="request_type" value="update_profile">
      <input type="text" name="firstName" placeholder="Prenom" value="<%= user.getFirstName() %>" readonly required><br>
      <input type="text" name="lastName" placeholder="Nom" value="<%= user.getLastName() %>" readonly required><br>
      <input type="number" name="age" placeholder="Age" value="<%= user.getAge() %>" readonly><br>
      <label>Genre:</label>
      <select name="gender" disabled>
        <option value="M" <%= "M".equals(user.getGender()) ? "selected" : "" %>>Masculin</option>
        <option value="F" <%= "F".equals(user.getGender()) ? "selected" : "" %>>Feminin</option>
      </select><br>
      <input type="email" name="email" placeholder="Email" value="<%= user.getEmail() %>" readonly required><br>
      <input type="password" name="password" placeholder="Mot de passe" readonly><br>
      <button type="button" id="editBtn" onclick="toggleEdit()">Modifier</button>
      <button type="submit" id="submitBtn" style="display:none">Enregistrer</button>
    </form>
    <script>
      function toggleEdit() {
        document.querySelectorAll('input').forEach(i => i.removeAttribute('readonly'));
        document.querySelector('select').removeAttribute('disabled');
        document.getElementById('editBtn').style.display = 'none';
        document.getElementById('submitBtn').style.display = '';
      }
    </script>
    <hr>
    <nav>
      <a href="controller?request_type=predict">Faire une prediction</a> |
      <a href="controller?request_type=history">Voir mon historique</a> |
      <a href="controller?request_type=logout">Deconnexion</a>
    </nav>
  <% } else { %>
    <p>Erreur: Impossible de charger les informations du profil</p>
    <a href="controller?request_type=login">Retour a la connexion</a>
  <% } %>
</body>
</html>
