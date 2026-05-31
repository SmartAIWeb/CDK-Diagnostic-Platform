<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Inscription</title>
</head>
<body>
    <h2>Creer un compte</h2>
    <%  
        if(request.getAttribute("error_msg")!=null){ %>
            <p><%= request.getAttribute("error_msg") %></p>
    <%}%>
    <form action="controller" method="POST">
        <input type="hidden" name="request_type" value="register">
        <input type="text" name="firstName" placeholder="Prenom" required><br>
        <input type="text" name="lastName" placeholder="Nom" required><br>
        <input type="number" name="age" placeholder="Age"><br>
        <label>Genre:</label>
        <select name="gender">
            <option value="M">Masculin</option>
            <option value="F">Feminin</option>
        </select><br>
        <input type="email" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Mot de passe" required><br>
        <button type="submit">S'inscrire</button>
    </form>    
</body>
</html>