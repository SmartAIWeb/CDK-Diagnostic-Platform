<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Prediction - Maladie Renale Chronique</title>
  <link rel="stylesheet" href="css/predict.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>
    <section class="predict-container">
      <h2>Formulaire de Prediction - Maladie Renale Chronique</h2>

      <% if (request.getAttribute("error_msg") != null) { %>
        <div class="error-message">
          <p><%= request.getAttribute("error_msg") %></p>
        </div>
      <% } %>

      <%
        Integer predictionValue = (Integer) request.getAttribute("prediction_result");
        Number  predictionProb  = (Number)  request.getAttribute("prediction_probability");

        if (predictionValue != null && predictionProb != null) {
          String resultLabel = (predictionValue == 1)
            ? "Maladie renale chronique detectee"
            : "Aucune maladie renale chronique detectee";
          String resultClass = (predictionValue == 1) ? "result-positive" : "result-negative";
      %>
          <div class="prediction-result <%= resultClass %>">
            <p><strong>Resultat :</strong> <%= resultLabel %></p>
            <p><strong>Confiance :</strong> <%= predictionProb %>%</p>
          </div>
      <% } %>

      <form action="controller" method="POST">
        <input type="hidden" name="request_type" value="predict">

        <fieldset>
          <legend>Donnees Numeriques</legend>

          <div class="form-group">
            <label for="age">Age (ans) :</label>
            <input type="number" id="age" name="age" min="0" max="120" step="1" required>
          </div>

          <div class="form-group">
            <label for="blood_pressure">Pression Arterielle (mm/Hg) :</label>
            <input type="number" id="blood_pressure" name="blood_pressure" min="0" step="1">
          </div>

          <div class="form-group">
            <label for="urine_specific_gravity">Gravite Specifique Urinaire :</label>
            <input type="number" id="urine_specific_gravity" name="urine_specific_gravity" min="1.001" max="1.035" step="0.001">
          </div>

          <div class="form-group">
            <label for="albumin">Albumine (0-5) :</label>
            <input type="number" id="albumin" name="albumin" min="0" max="5" step="1">
          </div>

          <div class="form-group">
            <label for="sugar">Sucre (0-5) :</label>
            <input type="number" id="sugar" name="sugar" min="0" max="5" step="1">
          </div>

          <div class="form-group">
            <label for="blood_glucose_random">Glycemie Aleatoire (mgs/dl) :</label>
            <input type="number" id="blood_glucose_random" name="blood_glucose_random" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="blood_urea">Uree Sanguine (mgs/dl) :</label>
            <input type="number" id="blood_urea" name="blood_urea" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="serum_creatinine">Creatinine Serique (mgs/dl) :</label>
            <input type="number" id="serum_creatinine" name="serum_creatinine" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="sodium">Sodium (mEq/L) :</label>
            <input type="number" id="sodium" name="sodium" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="potassium">Potassium (mEq/L) :</label>
            <input type="number" id="potassium" name="potassium" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="hemoglobin">Hemoglobine (gms) :</label>
            <input type="number" id="hemoglobin" name="hemoglobin" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="packed_cell_volume">Volume Globulaire (%) :</label>
            <input type="number" id="packed_cell_volume" name="packed_cell_volume" min="0" step="0.1">
          </div>

          <div class="form-group">
            <label for="white_blood_cell_count">Globules Blancs (cells/cumm) :</label>
            <input type="number" id="white_blood_cell_count" name="white_blood_cell_count" min="0" step="1">
          </div>

          <div class="form-group">
            <label for="red_blood_cell_count">Globules Rouges (millions/cmm) :</label>
            <input type="number" id="red_blood_cell_count" name="red_blood_cell_count" min="0" step="0.1">
          </div>
        </fieldset>

        <fieldset>
          <legend>Examens Urinaires</legend>

          <div class="form-group">
            <label for="red_blood_cells_urine">Globules Rouges Urinaires :</label>
            <select id="red_blood_cells_urine" name="red_blood_cells_urine">
              <option value="missing">-- Manquant --</option>
              <option value="normal">Normal</option>
              <option value="abnormal">Anormal</option>
            </select>
          </div>

          <div class="form-group">
            <label for="pus_cells">Cellules de Pus :</label>
            <select id="pus_cells" name="pus_cells">
              <option value="missing">-- Manquant --</option>
              <option value="normal">Normal</option>
              <option value="abnormal">Anormal</option>
            </select>
          </div>

          <div class="form-group">
            <label for="pus_cell_clumps">Amas de Cellules de Pus :</label>
            <select id="pus_cell_clumps" name="pus_cell_clumps">
              <option value="missing">-- Manquant --</option>
              <option value="notpresent">Absent</option>
              <option value="present">Present</option>
            </select>
          </div>

          <div class="form-group">
            <label for="bacteria">Bacteries :</label>
            <select id="bacteria" name="bacteria">
              <option value="missing">-- Manquant --</option>
              <option value="notpresent">Absent</option>
              <option value="present">Present</option>
            </select>
          </div>
        </fieldset>

        <fieldset>
          <legend>Antecedents Medicaux</legend>

          <div class="form-group">
            <label for="hypertension">Hypertension :</label>
            <select id="hypertension" name="hypertension">
              <option value="missing">-- Manquant --</option>
              <option value="yes">Oui</option>
              <option value="no">Non</option>
            </select>
          </div>

          <div class="form-group">
            <label for="diabetes_mellitus">Diabete Sucre :</label>
            <select id="diabetes_mellitus" name="diabetes_mellitus">
              <option value="missing">-- Manquant --</option>
              <option value="yes">Oui</option>
              <option value="no">Non</option>
            </select>
          </div>

          <div class="form-group">
            <label for="coronary_artery_disease">Maladie Coronarienne :</label>
            <select id="coronary_artery_disease" name="coronary_artery_disease">
              <option value="missing">-- Manquant --</option>
              <option value="no">Non</option>
              <option value="yes">Oui</option>
            </select>
          </div>

          <div class="form-group">
            <label for="appetite">Appetit :</label>
            <select id="appetite" name="appetite">
              <option value="missing">-- Manquant --</option>
              <option value="good">Bon</option>
              <option value="poor">Mauvais</option>
            </select>
          </div>

          <div class="form-group">
            <label for="pedal_edema">Oedeme des Pieds :</label>
            <select id="pedal_edema" name="pedal_edema">
              <option value="missing">-- Manquant --</option>
              <option value="no">Non</option>
              <option value="yes">Oui</option>
            </select>
          </div>

          <div class="form-group">
            <label for="anemia">Anemie :</label>
            <select id="anemia" name="anemia">
              <option value="missing">-- Manquant --</option>
              <option value="no">Non</option>
              <option value="yes">Oui</option>
            </select>
          </div>
        </fieldset>

        <div class="form-actions">
          <button type="submit">Lancer la Prediction</button>
        </div>
      </form>
    </section>
  </main>

  <footer></footer>
</body>
</html>
