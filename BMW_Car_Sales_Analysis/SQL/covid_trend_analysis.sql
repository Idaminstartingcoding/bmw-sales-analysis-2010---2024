

--  Did fuel preferences (Petrol vs Diesel vs Electric vs Hybrid) change after COVID?
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
