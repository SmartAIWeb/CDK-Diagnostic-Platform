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
        <p><strong>Prenom :</strong> <%= user.getFirstName() %></p>
        <p><strong>Nom :</strong> <%= user.getLastName() %></p>
        <p><strong>Email :</strong> <%= user.getEmail() %></p>
        <p><strong>Age :</strong> <%= user.getAge() %></p>

        <hr>
        <nav>
            <a href="controller?request_type=predict">Faire une prediction</a> |
            <a href="controller?request_type=history">Voir mon historique</a> |
            <a href="controller?request_type=logout">Deconnexion</a>
        </nav>
    <% } else { %>
        <p >Erreur : Impossible de charger les informations du profil</p>
        <a href="controller?request_type=login">Retour a la connexion</a>
    <% } %>
</body>
</html>