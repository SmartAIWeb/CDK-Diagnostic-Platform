# CKD Diagnostic Platform

A containerized web application for predicting chronic kidney disease from clinical patient data, built with Java/Tomcat, Python/Flask, and MariaDB.

## Overview

Clinicians enter patient lab values through a web form. The application persists the record to MariaDB and forwards it to a Flask microservice, which runs the data through a trained ML model and returns a **CKD / Not CKD** prediction with the stored history viewable per patient.

## Architecture

```
Browser ──► jee-tomcat (:8080) ──► jee-ml (:5000)
                  │
            jee-db (MariaDB)
```

| Container    | Technology          | Port |
|--------------|---------------------|------|
| `jee-tomcat` | Java 21 + Tomcat    | 8080 |
| `jee-ml`     | Python 3 + Flask    | 5000 |
| `jee-db`     | MariaDB 11          | —    |

**Startup order** — `jee-tomcat` waits for `jee-db` to pass its health check before starting, preventing connection errors on cold boot.

**Hot-swappable models** — ML model files are bind-mounted from `./ml-api/models/` at runtime. Swap in a new model file and restart `jee-ml` without rebuilding the image.

## Screenshots

![Home](https://cdn.jsdelivr.net/gh/SmartAIWeb/CDK-Diagnostic-Platform@main/screenshots/home_1.png)
![Result](https://cdn.jsdelivr.net/gh/SmartAIWeb/CDK-Diagnostic-Platform@main/screenshots/prediction.png)
![History](https://cdn.jsdelivr.net/gh/SmartAIWeb/CDK-Diagnostic-Platform@main/screenshots/user_history.png)

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes the Compose plugin)

### Run

```bash
docker compose up --build
```

| Service   | URL                   |
|-----------|-----------------------|
| Web app   | http://localhost:8080 |
| Flask API | http://localhost:5000 |

To stop and remove containers:

```bash
docker compose down
```

## Project Structure

```
├── web-app/                  # Jakarta + Tomcat
├── ml-api/
│   ├── api/app.py            # Flask prediction endpoint
│   ├── models/               # Trained model files
│   └── notebooks/            # Model training notebooks
├── database/
│   └── schema.sql            # MariaDB schema
└── docker-compose.yml
```

## Tech Stack

| Layer      | Technology |
|------------|------------|
| Frontend   | Java 21 · Jakarta Servlets · Apache Tomcat |
| ML API     | Python · Flask · scikit-learn |
| Database   | MariaDB 11 |
| Infra      | Docker · Docker Compose |
