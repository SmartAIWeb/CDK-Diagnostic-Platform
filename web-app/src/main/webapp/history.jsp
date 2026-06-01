<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.Prediction" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Collections" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  List<Prediction> history = (List<Prediction>) request.getAttribute("prediction_history");
  Set<String> dynamicKeys = Collections.emptySet();

  if (history != null && !history.isEmpty()) {
    JsonObject firstRecord = JsonParser.parseString(history.get(0).getInputFeatures()).getAsJsonObject();
    dynamicKeys = firstRecord.keySet();
  }

  int totalColumns = 4 + dynamicKeys.size();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Historique des Predictions</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <%@ include file="header.jsp" %>
  <main>
    <section class="history-container">
      <h2>Historique des Predictions</h2>

      <% if (request.getAttribute("error_msg") != null) { %>
        <div class="error-message">
          <p><%= request.getAttribute("error_msg") %></p>
        </div>
      <% } %>

      <div class="table-container">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Date</th>
              <th>Prediction</th>
              <th>Probabilite (%)</th>
              <% 
                for (String key : dynamicKeys) { 
                  String label = key.replace("_", " ");
                  label = label.substring(0, 1).toUpperCase() + label.substring(1);
              %>
                <th><%= label %></th>
              <% } %>
            </tr>
          </thead>
          <tbody>
            <%
              if (history != null && !history.isEmpty()) {
                for (Prediction p : history) {
                  JsonObject features = JsonParser.parseString(p.getInputFeatures()).getAsJsonObject();
                  int predRes = p.getPredictionRes();
                  int predProb = p.getPredictionProbability();
                  String predLabel = predRes == 1 ? "Positif (1)" : predRes == 0 ? "Negatif (0)" : "—";
            %>
            <tr>
              <td><%= p.getHistoryId() %></td>
              <td><%= p.getDate() %></td>
              <td class="<%= predRes == 1 ? "pred-positive" : "pred-negative" %>"><%= predLabel %></td>
              <td><%= predProb >= 0 ? predProb + "%" : "—" %></td>

              <% 
                for (String key : dynamicKeys) { 
                  String val = "—";
                  if (features.has(key) && !features.get(key).isJsonNull()) {
                    val = features.get(key).getAsString();
                    if ("-1".equals(val) || "-1.0".equals(val)) {
                      val = "—";
                    }
                  }
              %>
                <td><%= val %></td>
              <% } %>
            </tr>
            <%
                }
              } else {
            %>
            <tr>
              <td colspan="<%= totalColumns %>">Aucune prediction enregistree.</td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </section>
  </main>
  <footer data-year="2026"></footer>
</body>
</html>
