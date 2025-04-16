-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS project_db;
USE project_db;

-- Create ClimateData table
CREATE TABLE IF NOT EXISTS ClimateData (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(100) NOT NULL,
    record_date DATE NOT NULL,
    temperature FLOAT NOT NULL,
    precipitation FLOAT NOT NULL
); 