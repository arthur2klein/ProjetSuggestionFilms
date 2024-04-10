CREATE DATABASE movie_db;

\c movie_db;

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS user_saw_movie (
    saw_id SERIAL PRIMARY KEY,
    user_id INT,
    movie_id INT
);

CREATE TABLE IF NOT EXISTS rating (
    rating_id SERIAL PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating FLOAT
);
