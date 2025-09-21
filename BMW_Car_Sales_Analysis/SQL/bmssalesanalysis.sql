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
-- Import the csv file about the "BMW SALES DATA 2010-2024" 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/BMW_sales_data_(2010-2024).csv' INTO TABLE car_data FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (
    Model,
    Year,
    Region,
    Color,
    Fuel_Type,
    Transmission,
    Engine_Size_L,
    Mileage_KM,
    Price_USD,
    Sales_Volume,
    Sales_Classification
);
-- Car Sales Analytics Project (SQL Case Study)
-- What is the average selling price and total sales volume per region?**
SELECT Region,
    ROUND(AVG(Price_USD), 2) AS Avg_Price,
    SUM(Sales_Volume) AS Total_Sales
FROM car_data
GROUP BY Region
ORDER BY Total_Sales DESC;
--  Which top 3 car models sell the most in each region?**
WITH RankedModels AS (
    SELECT Region,
        Model,
        SUM(Sales_Volume) AS Total_Sales,
        ROW_NUMBER() OVER (
            PARTITION BY Region
            ORDER BY SUM(Sales_Volume) DESC
        ) AS rn
    FROM car_data
    GROUP BY Region,
        Model
)
SELECT Region,
    Model,
    Total_Sales,
    rn AS `rank`
FROM RankedModels
WHERE rn <= 3
ORDER BY Region,
    Total_Sales DESC;
--  Which cars are priced above the global average price?**
SELECT Model,
    Year,
    Price_USD
FROM car_data
WHERE Price_USD > (
        SELECT AVG(Price_USD)
        FROM car_data
    )
ORDER BY Price_USD DESC;
-- How do total sales before 2020 compare with 2020 & later?**
SELECT 'Before 2020' AS Period,
    SUM(Sales_Volume) AS Total_Sales
FROM car_data
WHERE Year < 2020
UNION
SELECT '2020 & Later' AS Period,
    SUM(Sales_Volume) AS Total_Sales
FROM car_data
WHERE Year >= 2020;
-- How can we classify cars by price segment (Budget, Mid-Range, Luxury)?**
-- *Supports pricing strategy and customer segmentation.*
SELECT Model,
    Price_USD,
    CASE
        WHEN Price_USD < 15000 THEN 'Budget'
        WHEN Price_USD BETWEEN 15000 AND 30000 THEN 'Mid-Range'
        ELSE 'Luxury'
    END AS Price_Category
FROM car_data
ORDER BY Price_USD DESC;
--  Which fuel type contributes the most to sales volume?**
-- Helps understand fuel preference (e.g., Electric vs Petrol).*
SELECT Fuel_Type,
    SUM(Sales_Volume) AS Total_Sales,
    ROUND(AVG(Price_USD), 2) AS Avg_Price
FROM car_data
GROUP BY Fuel_Type
ORDER BY Total_Sales DESC;
-- What is the market share of each car model within its region?**
-- *Identifies leading brands in each market.*
WITH RegionSales AS (
    SELECT Region,
        SUM(Sales_Volume) AS Total_Sales
    FROM car_data
    GROUP BY Region
),
ModelSales AS (
    SELECT Model,
        Region,
        SUM(Sales_Volume) AS Model_Sales
    FROM car_data
    GROUP BY Model,
        Region
)
SELECT m.Region,
    m.Model,
    m.Model_Sales,
    ROUND((m.Model_Sales / r.Total_Sales) * 100, 2) AS Market_Share_Percent
FROM ModelSales m
    JOIN RegionSales r ON m.Region = r.Region
ORDER BY m.Region,
    Market_Share_Percent DESC;
--  Which transmission type (Manual vs Automatic) performs better in sales?**
-- Provides insight for manufacturing and marketing focus.*
SELECT Transmission,
    SUM(Sales_Volume) AS Total_Sales,
    ROUND(AVG(Price_USD), 2) AS Avg_Price
FROM car_data
GROUP BY Transmission
ORDER BY Total_Sales DESC;
-- COVID Era Trend Analysis (SQL)
--  Did the average car price increase after COVID?
WITH PriceTrend AS (
    SELECT CASE
            WHEN Year < 2020 THEN 'Pre-COVID'
            ELSE 'Post-COVID'
        END AS Period,
        ROUND(AVG(Price_USD), 2) AS Avg_Price
    FROM car_data
    GROUP BY Period
)
SELECT MAX(
        CASE
            WHEN Period = 'Pre-COVID' THEN Avg_Price
        END
    ) AS Pre_COVID_Avg_Price,
    MAX(
        CASE
            WHEN Period = 'Post-COVID' THEN Avg_Price
        END
    ) AS Post_COVID_Avg_Price,
    ROUND(
        (
            (
                MAX(
                    CASE
                        WHEN Period = 'Post-COVID' THEN Avg_Price
                    END
                ) - MAX(
                    CASE
                        WHEN Period = 'Pre-COVID' THEN Avg_Price
                    END
                )
            ) / MAX(
                CASE
                    WHEN Period = 'Pre-COVID' THEN Avg_Price
                END
            )
        ) * 100,
        2
    ) AS Percentage_Change
FROM PriceTrend;
-- How did average sales volume change before vs after COVID?
--  Measures demand trends.
SELECT CASE
        WHEN Year < 2020 THEN 'Pre-COVID'
        ELSE 'Post-COVID'
    END AS Period,
    ROUND(AVG(Sales_Volume), 2) AS Avg_Sales_Per_Model
FROM car_data
GROUP BY Period;
--  Did fuel preferences (Petrol vs Diesel vs Electric) change after COVID?
--  Analyzes demand shifts in fuel type.
WITH FuelSales AS (
    SELECT Fuel_Type,
        CASE
            WHEN Year < 2020 THEN 'Pre-COVID'
            ELSE 'Post-COVID'
        END AS Period,
        SUM(Sales_Volume) AS Total_Sales
    FROM car_data
    GROUP BY Fuel_Type,
        Period
)
SELECT Fuel_Type,
    MAX(
        CASE
            WHEN Period = 'Pre-COVID' THEN Total_Sales
        END
    ) AS Pre_COVID_Sales,
    MAX(
        CASE
            WHEN Period = 'Post-COVID' THEN Total_Sales
        END
    ) AS Post_COVID_Sales,
    ROUND(
        (
            (
                MAX(
                    CASE
                        WHEN Period = 'Post-COVID' THEN Total_Sales
                    END
                ) - MAX(
                    CASE
                        WHEN Period = 'Pre-COVID' THEN Total_Sales
                    END
                )
            ) / MAX(
                CASE
                    WHEN Period = 'Pre-COVID' THEN Total_Sales
                END
            )
        ) * 100,
        2
    ) AS Percentage_Change
FROM FuelSales
GROUP BY Fuel_Type
ORDER BY Percentage_Change DESC;
--  Did regions show different demand trends post-COVID?
-- Identifies regional recovery vs slowdown.
SELECT Region,
    CASE
        WHEN Year < 2020 THEN 'Pre-COVID'
        ELSE 'Post-COVID'
    END AS Period,
    ROUND(AVG(Price_USD), 2) AS Avg_Price
FROM car_data
GROUP BY Region,
    Period
ORDER BY Region,
    Period;
-- Which transmission type gained more popularity post-COVID?
--  Analyzes automatic vs manual shift after COVID.
SELECT Transmission,
    CASE
        WHEN Year < 2020 THEN 'Pre-COVID'
        ELSE 'Post-COVID'
    END AS Period,
    ROUND(AVG(Price_USD),2) AS Total_Sales
FROM car_data
GROUP BY Transmission,
    Period
ORDER BY Transmission,
    Period;
-- Did Luxury cars sell more after COVID?
-- Compares demand by price category before vs after COVID.
SELECT CASE
        WHEN Price_USD < 15000 THEN 'Budget'
        WHEN Price_USD BETWEEN 15000 AND 30000 THEN 'Mid-Range'
        ELSE 'Luxury'
    END AS Price_Category,
    CASE
        WHEN Year < 2020 THEN 'Pre-COVID'
        ELSE 'Post-COVID'
    END AS Period,
    SUM(Sales_Volume) AS Total_Sales
FROM car_data
GROUP BY Price_Category,
    Period
ORDER BY Price_Category,
    Period;
-- Which car models increased in average price post-COVID?
-- Spot price hikes by model.
WITH PrePost AS (
    SELECT Model,
        CASE
            WHEN Year < 2020 THEN 'Pre-COVID'
            ELSE 'Post-COVID'
        END AS Period,
        ROUND(AVG(Price_USD), 2) AS Avg_Price
    FROM car_data
    GROUP BY Model,
        Period
)
SELECT p.Model,
    MAX(
        CASE
            WHEN Period = 'Pre-COVID' THEN Avg_Price
        END
    ) AS Pre_COVID_Price,
    MAX(
        CASE
            WHEN Period = 'Post-COVID' THEN Avg_Price
        END
    ) AS Post_COVID_Price,
    (
        MAX(
            CASE
                WHEN Period = 'Post-COVID' THEN Avg_Price
            END
        ) - MAX(
            CASE
                WHEN Period = 'Pre-COVID' THEN Avg_Price
            END
        )
    ) AS Price_Change
FROM PrePost p
GROUP BY p.Model
ORDER BY Price_Change DESC;