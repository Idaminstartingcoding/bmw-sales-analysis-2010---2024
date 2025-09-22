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
