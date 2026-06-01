CREATE DATABASE IF NOT EXISTS prediction_app_db;
USE prediction_app_db;

CREATE TABLE IF NOT EXISTS Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  age INT,
  gender ENUM('male', 'female'),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  role ENUM('user', 'admin') DEFAULT 'user',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS History(
  history_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  inputed_features JSON,
  prediction_res boolean,
  prediction_probability INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Admin_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);