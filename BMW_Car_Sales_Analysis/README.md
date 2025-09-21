# 🚗 BMW Car Sales Analysis (2010–2024)

##  Project Overview  
This project analyzes BMW car sales data from **2010 to 2024** across multiple regions. The goal is to uncover sales and pricing trends, identify key market insights, and **deep dive into the impact of the COVID-19 era (2020 onwards)**.  

The analysis demonstrates SQL skills such as:  
- **Aggregation** (SUM, AVG, COUNT)  
- **Joins** (fuel type mapping, region-based analysis)  
- **CTEs** (ranking models, market share)  
- **Subqueries** (cars priced above global average)  
- **UNION** (pre vs post COVID comparisons)  
- **CASE statements** (categorization into COVID-era and price bands)  

---

##  Dataset Description  

The dataset contains BMW car sales records with the following columns:  

| Column             | Description |
|--------------------|-------------|
| **Model**          | Car model name (e.g., X1, 5 Series, i8) |
| **Year**           | Manufacturing/sales year (2010–2024) |
| **Region**         | Sales region (Asia, Europe, North America, South America, Middle East) |
| **Color**          | Car color |
| **Fuel_Type**      | Type of fuel (Petrol, Diesel, Electric, Hybrid) |
| **Transmission**   | Transmission type (Manual, Automatic) |
| **Engine_Size_L**  | Engine capacity (liters) |
| **Mileage_KM**     | Mileage in kilometers |
| **Price_USD**      | Price of the car in USD |
| **Sales_Volume**   | Number of units sold |
| **Sales_Classification** | Category of sales (High, Medium, Low) |

---

##  Key Insights & Analysis  

### 🔹 General Trends (2010–2024)
- **Average Price & Sales**: Not inflated in any particular region, but **Asia leads** with both the **highest average price** and **highest average sales volume**.  
- **Top 5 Cars Sold Above Global Average Price**:  
  - i8 (2010)  
  - X6 (2019)  
  - i8 (2024)  
  - X1 (2016)  
  - 3 Series (2019)  
- **Fuel Type Trends**:  
  - **Hybrid cars** had the **highest average sales volume** while maintaining the **lowest average price**.  
  - Followed by Petrol → Electric → Diesel in terms of demand.  
- **Regional Market Leaders**:  
  - **Asia** → 5 Series & X1 dominate.  
  - **Europe** → i8 is most popular.  
  - **Middle East** → 7 Series leads.  
  - **North America** → 7 Series leads.  
  - **South America** → X6 leads.  
- **Transmission Trends**:  
  - **Manual cars outsold automatics**.  
  - Manual cars had **lower prices**, indicating cost sensitivity in several markets.  

---

### 🔹 COVID-19 Impact (Pre-2020 vs Post-2020)

- **Average Price Change**:  
  - Prices **increased slightly (+0.19%)** post-COVID.  
  - Suggests BMW kept prices stable to match reduced consumer purchasing power.  

- **Sales Trend**:  
  - **Model-wise average sales increased post-COVID**, showing strong recovery in demand despite global disruptions.  

- **Regional Price Impact**:  
  - **Every region except Europe** saw an increase in average price post-COVID.  
  - Europe remained flat or slightly declined, indicating market sensitivity.  

- **Transmission Trend**:  
  - Both **Automatic and Manual cars saw small price increases** post-COVID.  

- **Models with Significant Price Increase (Post-COVID)**:  
  | Model     | Pre-COVID Avg Price | Post-COVID Avg Price | Difference (USD) |
  |-----------|----------------------|----------------------|------------------|
  | 3 Series  | 75,198.00           | 76,304.62           | +1,106.62 |
  | M3        | 74,511.73           | 75,491.33           | +979.60 |
  | X6        | 74,149.73           | 74,966.93           | +817.20 |
  | X1        | 75,061.33           | 75,676.25           | +614.92 |
  | 5 Series  | 75,114.46           | 75,636.55           | +522.09 |

---

##  SQL Concepts Demonstrated  

- **Aggregation** → Average price/sales by region, fuel type, and transmission.  
- **CTEs** → Ranking top-selling models by region.  
- **Subqueries** → Cars priced above the global average.  
- **Joins** → Mapping external fuel efficiency categories.  
- **UNION** → Comparing pre-COVID vs post-COVID trends.  
- **CASE Statements** → Classifying cars into budget/mid-range/luxury.  

---

##  Key Takeaways  

- **Asia** dominates in both sales volume and pricing.  
- **Hybrid cars** provide maximum sales with low prices, indicating customer preference for affordability and efficiency.  
- **Manual cars** outsold automatics, but at lower prices.  
- **Post-COVID:**  
  - BMW strategically kept **prices almost stable (+0.19%)**, which helped increase sales.  
  - **Electric & hybrid adoption increased** while diesel lost ground.  
  - **Luxury models (3 Series, X6, M3)** saw notable price increases post-COVID.  
  - Europe struggled with post-COVID price recovery, unlike other regions.  

---

##  Project Structure  

```
BMW_Car_Sales_SQL_Project/
│
├── data/
│   └── bmw_car_data.csv
├── sql/
│   ├── create_table.sql
│   ├── data_load.sql
│   ├── general_analysis.sql
│   ├── covid_trend_analysis.sql
│   └── insights_queries.sql
└── README.md   <-- This report
```
