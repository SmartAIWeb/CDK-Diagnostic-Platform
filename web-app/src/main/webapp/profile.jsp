<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
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
  <title>Mon Profil</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>
    <section class="profile-container">
      <h2>Profil Utilisateur</h2>

      <% if (request.getAttribute("error_msg") != null) { %>
        <div class="error-message">
          <p><%= request.getAttribute("error_msg") %></p>
        </div>
      <% } %>

      <form method="POST" action="controller">
        <input type="hidden" name="request_type" value="edit_info">
        <input type="hidden" name="email" value="<%= user.getEmail() %>">

        <div class="form-group">
          <label for="firstName">Prenom :</label>
          <input type="text" id="firstName" name="firstName" value="<%= user.getFirstName() != null ? user.getFirstName() : "" %>" readonly required>
        </div>

        <div class="form-group">
          <label for="lastName">Nom :</label>
          <input type="text" id="lastName" name="lastName" value="<%= user.getLastName() != null ? user.getLastName() : "" %>" readonly required>
        </div>

        <div class="form-group">
          <label for="age">Age :</label>
          <input type="number" id="age" name="age" value="<%= user.getAge() %>" readonly min="0" max="150">
        </div>

        <div class="form-group">
          <label for="gender">Genre :</label>
          <select id="gender" name="gender" disabled>
            <option value="male"   <%= "male".equals(user.getGender())   ? "selected" : "" %>>Masculin</option>
            <option value="female" <%= "female".equals(user.getGender()) ? "selected" : "" %>>Feminin</option>
          </select>
        </div>

        <div class="form-actions">
          <button type="button" id="editBtn" onclick="toggleEdit()">Modifier</button>
          <button type="submit" id="submitBtn" hidden>Enregistrer</button>
          <button type="button" id="cancelBtn" hidden onclick="cancelEdit()">Annuler</button>
        </div>
      </form>
    </section>
  </main>

  <footer data-year="2026"></footer>

  <script>
    var origValues = {};

    function toggleEdit() {
      ['firstName', 'lastName', 'age'].forEach(function(id) {
        var el = document.getElementById(id);
        origValues[id] = el.value;
        el.removeAttribute('readonly');
      });
      var g = document.getElementById('gender');
      origValues['gender'] = g.value;
      g.removeAttribute('disabled');

      document.getElementById('editBtn').hidden   = true;
      document.getElementById('submitBtn').hidden = false;
      document.getElementById('cancelBtn').hidden = false;
    }

    function cancelEdit() {
      ['firstName', 'lastName', 'age'].forEach(function(id) {
        var el = document.getElementById(id);
        el.value = origValues[id];
        el.setAttribute('readonly', 'readonly');
      });
      var g = document.getElementById('gender');
      g.value = origValues['gender'];
      g.setAttribute('disabled', 'disabled');

      document.getElementById('editBtn').hidden   = false;
      document.getElementById('submitBtn').hidden = true;
      document.getElementById('cancelBtn').hidden = true;
    }
  </script>
</body>
</html>
