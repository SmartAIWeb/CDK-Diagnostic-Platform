<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Accueil - Système de Diagnostic MRC</title>
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
        
        <div style="margin-top: 40px;">
          <a href="predict.jsp" class="btn-primary">Commancer</a>
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
