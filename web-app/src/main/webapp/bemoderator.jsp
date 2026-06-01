<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Devenir Moderateur</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>Demande de privileges Moderateur</h2>
        <p>Veuillez expliquer pourquoi vous souhaitez devenir modérateur pour notre plateforme :</p>
        
        <form action="controller" method="POST">
            <input type="hidden" name="request_type" value="submit_mod_request">
            
            <div class="form-group">
                <label for="message">Votre motivation :</label>
                <textarea id="message" name="message" rows="5" required style="width: 100%;"></textarea>
            </div>
            
            <button type="submit" class="btn-submit">Envoyer la demande</button>
            <a href="profile.jsp">Annuler</a>
        </form>
    </div>
</body>
</html>