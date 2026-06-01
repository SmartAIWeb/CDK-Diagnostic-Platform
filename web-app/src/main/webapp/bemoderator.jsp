<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.User" %>
<%
  User user = (User) session.getAttribute("user_info");
  if (user == null) {
      response.sendRedirect("login.jsp");
      return;
  }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Devenir Moderateur</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="form-container">
        <h2>Demande de privileges Moderateur</h2>
        <p>Veuillez expliquer pourquoi vous souhaitez devenir modérateur pour notre plateforme :</p>
        
        <form action="controller" method="POST">
            <input type="hidden" name="request_type" value="submit_mod_request">
            
            <fieldset>
                <legend>Motivation</legend>

                <div class="form-group">
                    <label for="message">Votre motivation :</label>
                    <textarea id="message" name="message" rows="5" required></textarea>
                </div>
            </fieldset>
            
            <div class="form-actions">
                <button type="submit">Envoyer la demande</button>
                <a href="profile.jsp" class="btn">Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>