<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Inscription</title>
</head>
<body>
    <%@ include file="header.jsp" %>
    <h2>Connexion</h2>
    <%  
        if(request.getAttribute("error_msg")!=null){ %>
            <p><%= request.getAttribute("error_msg") %></p>
    <%}%>
    <form action="controller" method="POST">
        <input type="hidden" name="request_type" value="login">
        <input type="email" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Mot de passe" required><br>
        <button type="submit">Connexion</button>
    </form>    
    <p>Vous n'avez pas de compte ?<a href="register.jsp">Creez votre compte ici</a></p>
</body>
</html>
