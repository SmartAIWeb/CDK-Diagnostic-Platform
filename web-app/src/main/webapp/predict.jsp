<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<%
  User user = (User) session.getAttribute("user_info");
  if (user == null) {
      response.sendRedirect("login.jsp");
      return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Prédiction - Maladie Rénale Chronique</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <%@ include file="header.jsp" %>

  <main>

    <div class="hero-section">
      <div class="hero-section-left">
        <div class="hero-badge">Système IA · Diagnostic Médical</div>
        <h1>Chronic Kidney<br><span>Disease</span><br>Prediction</h1>
        <p>Plateforme intelligente d'aide au diagnostic basée sur des algorithmes de Machine Learning entraînés sur des données cliniques réelles.</p>

        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-value">97<span>%</span></div>
            <div class="stat-label">Accuracy</div>
            <div class="stat-sublabel">Random Forest</div>
          </div>
          <div class="stat-card">
            <div class="stat-value">400<span>+</span></div>
            <div class="stat-label">Échantillons</div>
            <div class="stat-sublabel">Dataset UCI</div>
          </div>
          <div class="stat-card">
            <div class="stat-value">24<span>f</span></div>
            <div class="stat-label">ML Model</div>
            <div class="stat-sublabel">Features</div>
          </div>
        </div>
      </div>
      <div class="hero-section-right">
        <img
          src="https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&q=80"
          alt="Medical imaging laboratory"
          onerror="this.style.display='none'"
        />
      </div>
    </div>

    <div class="about-section">
      <div class="about-image">
        <img
          src="https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=600&q=80"
          alt="Kidney anatomy illustration"
          onerror="this.src='https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&q=80'"
        />
      </div>
      <div class="about-content">
        <h2>Maladie Rénale<br><span>Chronique</span></h2>
        <p>
          La maladie rénale chronique (MRC) est une perte progressive et irréversible des fonctions rénales. Elle touche environ 10% de la population mondiale et constitue un problème de santé publique majeur nécessitant un diagnostic précoce.
        </p>
        <p>
          Ce système utilise un modèle de <strong>Random Forest</strong> entraîné sur 400 dossiers patients avec 24 caractéristiques cliniques issues du <strong>UCI Machine Learning Repository</strong>. Il atteint une précision de <strong>97%</strong> en détectant la MRC à partir de paramètres biologiques et d'antécédents médicaux.
        </p>
        <div class="about-tags">
          <span class="about-tag">Random Forest</span>
          <span class="about-tag">UCI Dataset</span>
          <span class="about-tag">24 Features</span>
          <span class="about-tag">Java EE</span>
          <span class="about-tag">Python Flask</span>
          <span class="about-tag">MySQL</span>
        </div>
      </div>
    </div>

    <section class="predict-container">
      <h2>Formulaire de Prédiction</h2>

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
            ? "Maladie rénale chronique détectée"
            : "Aucune maladie rénale chronique détectée";
          String resultClass = (predictionValue == 1) ? "result-positive" : "result-negative";
      %>
          <div class="prediction-result <%= resultClass %>">
            <p><strong>Résultat</strong><%= resultLabel %></p>
            <p><strong>Confiance du modèle</strong><%= predictionProb %>%</p>
          </div>
      <% } %>

      <form action="controller" method="POST" class="predict-form-section">
        <input type="hidden" name="request_type" value="predict">

        <fieldset>
          <legend>Données Numériques</legend>

          <div class="form-group">
            <label for="age">Âge (ans)</label>
            <input type="number" id="age" name="age" min="0" max="120" step="1" placeholder="ex: 45" required>
          </div>
          <div class="form-group">
            <label for="blood_pressure">Pression Artérielle (mm/Hg)</label>
            <input type="number" id="blood_pressure" name="blood_pressure" min="0" step="1" placeholder="ex: 80">
          </div>
          <div class="form-group">
            <label for="urine_specific_gravity">Gravité Spécifique Urinaire</label>
            <input type="number" id="urine_specific_gravity" name="urine_specific_gravity" min="1.001" max="1.035" step="0.001" placeholder="ex: 1.020">
          </div>
          <div class="form-group">
            <label for="albumin">Albumine (0–5)</label>
            <input type="number" id="albumin" name="albumin" min="0" max="5" step="1" placeholder="ex: 0">
          </div>
          <div class="form-group">
            <label for="sugar">Sucre (0–5)</label>
            <input type="number" id="sugar" name="sugar" min="0" max="5" step="1" placeholder="ex: 0">
          </div>
          <div class="form-group">
            <label for="blood_glucose_random">Glycémie Aléatoire (mgs/dl)</label>
            <input type="number" id="blood_glucose_random" name="blood_glucose_random" min="0" step="0.1" placeholder="ex: 121">
          </div>
          <div class="form-group">
            <label for="blood_urea">Urée Sanguine (mgs/dl)</label>
            <input type="number" id="blood_urea" name="blood_urea" min="0" step="0.1" placeholder="ex: 36">
          </div>
          <div class="form-group">
            <label for="serum_creatinine">Créatinine Sérique (mgs/dl)</label>
            <input type="number" id="serum_creatinine" name="serum_creatinine" min="0" step="0.1" placeholder="ex: 1.2">
          </div>
          <div class="form-group">
            <label for="sodium">Sodium (mEq/L)</label>
            <input type="number" id="sodium" name="sodium" min="0" step="0.1" placeholder="ex: 137">
          </div>
          <div class="form-group">
            <label for="potassium">Potassium (mEq/L)</label>
            <input type="number" id="potassium" name="potassium" min="0" step="0.1" placeholder="ex: 4.5">
          </div>
          <div class="form-group">
            <label for="hemoglobin">Hémoglobine (gms)</label>
            <input type="number" id="hemoglobin" name="hemoglobin" min="0" step="0.1" placeholder="ex: 15.4">
          </div>
          <div class="form-group">
            <label for="packed_cell_volume">Volume Globulaire (%)</label>
            <input type="number" id="packed_cell_volume" name="packed_cell_volume" min="0" step="0.1" placeholder="ex: 44">
          </div>
          <div class="form-group">
            <label for="white_blood_cell_count">Globules Blancs (cells/cumm)</label>
            <input type="number" id="white_blood_cell_count" name="white_blood_cell_count" min="0" step="1" placeholder="ex: 7800">
          </div>
          <div class="form-group">
            <label for="red_blood_cell_count">Globules Rouges (millions/cmm)</label>
            <input type="number" id="red_blood_cell_count" name="red_blood_cell_count" min="0" step="0.1" placeholder="ex: 5.2">
          </div>
        </fieldset>

        <fieldset>
          <legend>Examens Urinaires</legend>

          <div class="form-group">
            <label for="red_blood_cells_urine">Globules Rouges Urinaires</label>
            <select id="red_blood_cells_urine" name="red_blood_cells_urine">
              <option value="missing">— Manquant —</option>
              <option value="normal">Normal</option>
              <option value="abnormal">Anormal</option>
            </select>
          </div>
          <div class="form-group">
            <label for="pus_cells">Cellules de Pus</label>
            <select id="pus_cells" name="pus_cells">
              <option value="missing">— Manquant —</option>
              <option value="normal">Normal</option>
              <option value="abnormal">Anormal</option>
            </select>
          </div>
          <div class="form-group">
            <label for="pus_cell_clumps">Amas de Cellules de Pus</label>
            <select id="pus_cell_clumps" name="pus_cell_clumps">
              <option value="missing">— Manquant —</option>
              <option value="notpresent">Absent</option>
              <option value="present">Présent</option>
            </select>
          </div>
          <div class="form-group">
            <label for="bacteria">Bactéries</label>
            <select id="bacteria" name="bacteria">
              <option value="missing">— Manquant —</option>
              <option value="notpresent">Absent</option>
              <option value="present">Présent</option>
            </select>
          </div>
        </fieldset>

        <fieldset>
          <legend>Antécédents Médicaux</legend>

          <div class="form-group">
            <label for="hypertension">Hypertension</label>
            <select id="hypertension" name="hypertension">
              <option value="missing">— Manquant —</option>
              <option value="yes">Oui</option>
              <option value="no">Non</option>
            </select>
          </div>
          <div class="form-group">
            <label for="diabetes_mellitus">Diabète Sucré</label>
            <select id="diabetes_mellitus" name="diabetes_mellitus">
              <option value="missing">— Manquant —</option>
              <option value="yes">Oui</option>
              <option value="no">Non</option>
            </select>
          </div>
          <div class="form-group">
            <label for="coronary_artery_disease">Maladie Coronarienne</label>
            <select id="coronary_artery_disease" name="coronary_artery_disease">
              <option value="missing">— Manquant —</option>
              <option value="no">Non</option>
              <option value="yes">Oui</option>
            </select>
          </div>
          <div class="form-group">
            <label for="appetite">Appétit</label>
            <select id="appetite" name="appetite">
              <option value="missing">— Manquant —</option>
              <option value="good">Bon</option>
              <option value="poor">Mauvais</option>
            </select>
          </div>
          <div class="form-group">
            <label for="pedal_edema">Œdème des Pieds</label>
            <select id="pedal_edema" name="pedal_edema">
              <option value="missing">— Manquant —</option>
              <option value="no">Non</option>
              <option value="yes">Oui</option>
            </select>
          </div>
          <div class="form-group">
            <label for="anemia">Anémie</label>
            <select id="anemia" name="anemia">
              <option value="missing">— Manquant —</option>
              <option value="no">Non</option>
              <option value="yes">Oui</option>
            </select>
          </div>
        </fieldset>

        <div class="form-submit-area form-actions">
          <button type="submit">Lancer la Prédiction</button>
        </div>
      </form>
    </section>

    <div class="predict-page-footer">
      <div class="footer-col">
        <h4>Algorithme</h4>
        <p><strong>Random Forest Classifier</strong><br>Ensemble de 100 arbres de décision. Précision : 97% sur données de test stratifiées.</p>
      </div>
      <div class="footer-col">
        <h4>Données</h4>
        <p><strong>UCI CKD Dataset</strong><br>400 patients · 24 attributs cliniques · 2 classes : CKD / notCKD.</p>
      </div>
      <div class="footer-col">
        <h4>Avertissement</h4>
        <p>Cet outil est à usage <strong>académique uniquement</strong>. Il ne remplace pas un diagnostic médical professionnel.</p>
      </div>
    </div>

  </main>

  <footer data-year="2026"></footer>
</body>
</html>
