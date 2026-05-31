<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Administration</title>
</head>
<body>
    <h1>Tableau de bord Administrateur</h1>
    <nav>
        <a href="admin.jsp">Rafraichir la liste</a> |
        <a href="profile.jsp">Profile</a> |
        <a href="controller?request_type=logout">Deconnexion</a>
    </nav>
    <section>
        <h2>Gestion des Utilisateurs</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty all_users}">
                        <c:forEach var="user" items="${all_users}">
                            <tr>
                                <td>${user.userId}</td>
                                <td>${user.firstName} ${user.lastName}</td>
                                <td>${user.email}</td>
                                <td>
                                    <form action="controller" method="GET">
                                        <input type="hidden" name="request_type" value="history">
                                        <input type="hidden" name="userId" value="${user.userId}">
                                        <button type="submit" >Voir Historique</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="4">Aucun utilisateur trouve </td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </section>
</body>
</html>
