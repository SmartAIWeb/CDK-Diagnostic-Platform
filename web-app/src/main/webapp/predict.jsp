<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Prediction - Maladie Renale</title>
</head>
<body>
  <%@ include file="header.jsp" %>
  <h2>Formulaire de Prediction</h2>

  <% if (request.getAttribute("error_msg") != null) { %>
    <p><%= request.getAttribute("error_msg") %></p>
  <% } %>

  <form action="controller" method="POST">
    <input type="hidden" name="request_type" value="predict">

    <h3>Donnees Numeriques</h3>

    <label>Age (ans)</label><br>
    <input type="number" name="age" min="0" max="120" step="1" required><br>

    <label>Pression Arterielle (mm/Hg)</label><br>
    <input type="number" name="blood_pressure" min="0" step="1"><br>

    <label>Gravite Specifique Urinaire</label><br>
    <input type="number" name="urine_specific_gravity" min="1.001" max="1.035" step="0.001"><br>

    <label>Albumine (0-5)</label><br>
    <input type="number" name="albumin" min="0" max="5" step="1"><br>

    <label>Sucre (0-5)</label><br>
    <input type="number" name="sugar" min="0" max="5" step="1"><br>

    <label>Glycemie Aleatoire (mgs/dl)</label><br>
    <input type="number" name="blood_glucose_random" min="0" step="0.1"><br>

    <label>Uree Sanguine (mgs/dl)</label><br>
    <input type="number" name="blood_urea" min="0" step="0.1"><br>

    <label>Creatinine Serique (mgs/dl)</label><br>
    <input type="number" name="serum_creatinine" min="0" step="0.1"><br>

    <label>Sodium (mEq/L)</label><br>
    <input type="number" name="sodium" min="0" step="0.1"><br>

    <label>Potassium (mEq/L)</label><br>
    <input type="number" name="potassium" min="0" step="0.1"><br>

    <label>Hemoglobine (gms)</label><br>
    <input type="number" name="hemoglobin" min="0" step="0.1"><br>

    <label>Volume Globulaire (%)</label><br>
    <input type="number" name="packed_cell_volume" min="0" step="0.1"><br>

    <label>Globules Blancs (cells/cumm)</label><br>
    <input type="number" name="white_blood_cell_count" min="0" step="1"><br>

    <label>Globules Rouges (millions/cmm)</label><br>
    <input type="number" name="red_blood_cell_count" min="0" step="0.1"><br>

    <h3>Examens Urinaires</h3>

    <label>Globules Rouges Urinaires</label><br>
    <select name="red_blood_cells_urine">
      <option value="missing">-- Manquant --</option>
      <option value="normal">Normal</option>
      <option value="abnormal">Anormal</option>
    </select><br>

    <label>Cellules de Pus</label><br>
    <select name="pus_cells">
      <option value="missing">-- Manquant --</option>
      <option value="normal">Normal</option>
      <option value="abnormal">Anormal</option>
    </select><br>

    <label>Amas de Cellules de Pus</label><br>
    <select name="pus_cell_clumps">
      <option value="missing">-- Manquant --</option>
      <option value="notpresent">Absent</option>
      <option value="present">Present</option>
    </select><br>

    <label>Bacteries</label><br>
    <select name="bacteria">
      <option value="missing">-- Manquant --</option>
      <option value="notpresent">Absent</option>
      <option value="present">Present</option>
    </select><br>

    <h3>Antecedents Medicaux</h3>

    <label>Hypertension</label><br>
    <select name="hypertension">
      <option value="missing">-- Manquant --</option>
      <option value="yes">Oui</option>
      <option value="no">Non</option>
    </select><br>

    <label>Diabete Sucre</label><br>
    <select name="diabetes_mellitus">
      <option value="missing">-- Manquant --</option>
      <option value="yes">Oui</option>
      <option value="no">Non</option>
    </select><br>

    <label>Maladie Coronarienne</label><br>
    <select name="coronary_artery_disease">
      <option value="missing">-- Manquant --</option>
      <option value="yes">Oui</option>
      <option value="no">Non</option>
    </select><br>

    <label>Appetit</label><br>
    <select name="appetite">
      <option value="missing">-- Manquant --</option>
      <option value="good">Bon</option>
      <option value="poor">Mauvais</option>
    </select><br>

    <label>Oedeme des Pieds</label><br>
    <select name="pedal_edema">
      <option value="missing">-- Manquant --</option>
      <option value="yes">Oui</option>
      <option value="no">Non</option>
    </select><br>

    <label>Anemie</label><br>
    <select name="anemia">
      <option value="missing">-- Manquant --</option>
      <option value="yes">Oui</option>
      <option value="no">Non</option>
    </select><br>

    <br>
    <button type="submit">Lancer la Prediction</button>
  </form>

  <% if (request.getAttribute("prediction_result") != null) { %>
    <p><strong><%= request.getAttribute("prediction_result") %></strong></p>
  <% } %>

</body>
</html>
