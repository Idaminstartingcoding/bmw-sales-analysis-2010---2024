--create database and table to store the data
CREATE DATABASE IF NOT EXISTS car_sales;
USE car_sales;
CREATE TABLE car_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Model VARCHAR(100),
    Year INT,
    Region VARCHAR(100),
    Color VARCHAR(50),
    Fuel_Type VARCHAR(50),
    Transmission VARCHAR(50),
    Engine_Size_L DECIMAL(5, 2),
    Mileage_KM INT,
    Price_USD DECIMAL(12, 2),
    Sales_Volume INT,
    Sales_Classification VARCHAR(50)
);
