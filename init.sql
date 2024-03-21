CREATE DATABASE IF NOT EXISTS movie_streaming_db;
USE movie_streaming_db;

CREATE USER IF NOT EXISTS 'utilisateur'@'localhost' IDENTIFIED BY 'lesfilmscestbien';

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    genre VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS movies_seen (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    movie_title VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS user_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

GRANT ALL PRIVILEGES ON movie_streaming_db.* TO 'utilisateur'@'localhost'; 
GRANT INSERT, DELETE, UPDATE, SELECT ON *.* TO 'utilisateur'@'localhost';