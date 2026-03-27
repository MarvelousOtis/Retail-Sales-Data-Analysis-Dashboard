CREATE DATABASE Retail_sales;
USE Retail_sales;
SELECT * FROM rd
LIMIT 10;

-- Data Analysis
-- CREATE CUSTOMER SEGMENT VIEW
CREATE VIEW customer_segment AS
SELECT *,
    CASE 
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS Age_Bracket
FROM rd;

-- METRIC ONE: Total Sales
SELECT  SUM(Sales) AS Total_Sales
FROM rd;

-- METRIC TWO: TOTAL Orders
SELECT COUNT(transaction_id) AS Total_orders
FROM rd;

-- METRIC THREE: Sales by Product Category:
SELECT Category, SUM(Sales) AS total_sales
FROM rd
GROUP BY Category;

-- METRIC FOUR: AVERAGE ORDER VALUE(AOV)
SELECT 
    SUM(Sales) / COUNT(DISTINCT transaction_id) AS Average_Order_Value
FROM rd;

-- METRIC FIVE: Total sales by month
SELECT Month, SUM(Sales) AS Total_Sales
FROM rd
GROUP BY month
ORDER BY month;

-- METRIC SIX: Total Sales by Year
SELECT Year, SUM(Sales) AS Total_Sales
FROM rd
GROUP BY Year
ORDER BY Total_Sales Desc;

-- METRIC SEVEN: Total Sales by Gender
SELECT Gender, SUM(Sales) AS Total_Sales
FROM rd
GROUP BY Gender
ORDER BY Total_Sales Desc;

-- METRIC EIGHT: Total sales by age Range
SELECT 
    Age_Bracket,
    SUM(Sales) AS Total_Sales
FROM customer_segment
GROUP BY Age_Bracket
ORDER BY Total_Sales DESC;

-- METRIC NINE: Number of customers by category or products
SELECT Category, COUNT(DISTINCT(user_id)) AS No_of_buyers
FROM rd
GROUP BY Category
ORDER BY No_of_buyers DESC;

-- METRIC TEN: Number of customers by category and gender
SELECT Gender, Category, COUNT(DISTINCT(user_id)) AS No_of_buyers
FROM rd
GROUP BY Gender, Category
ORDER BY No_of_buyers DESC;

-- METRIC 11: RELATIONSHIP BTWN AGE, CATEGORY AND SALES
SELECT 
    Age_Bracket,
    Category,
    SUM(Sales) AS Total_Sales
FROM customer_segment
GROUP BY Age_Bracket, Category
ORDER BY Total_Sales DESC;

-- METRIC 12: Age & Gender Influence
SELECT 
    Gender,
    Age_Bracket,
    COUNT(DISTINCT transaction_id) AS Orders,
    SUM(Sales) AS Total_Sales
FROM customer_segment
GROUP BY Gender, Age_Bracket
ORDER BY Total_Sales DESC;

-- METRIC 13: Total quantity Sold
SELECT SUM(Quantity) AS Total_quant_sold
FROM rd;

-- METRIC 14: Purchase Behavior
SELECT 
    transaction_id,
    SUM(Quantity) AS Total_Items,
    SUM(Sales) AS Total_Sales
FROM rd
GROUP BY transaction_id; 
SELECT 
    CASE 
        WHEN Total_Items = 1 THEN 'Single Item'
        WHEN Total_Items BETWEEN 2 AND 4 THEN 'Small Basket'
        ELSE 'Bulk Purchase'
    END AS Purchase_Type,
    COUNT(*) AS Orders,
    AVG(Total_Sales) AS Avg_Order_Value
FROM (
    SELECT 
        transaction_id,
        SUM(Quantity) AS Total_Items,
        SUM(Sales) AS Total_Sales
    FROM rd
    GROUP BY transaction_id
) AS t
GROUP BY Purchase_Type;

-- METRIC 15: Monthly Category Trends (Seasonality)
SELECT 
    Month,
    Category,
    SUM(Sales) AS Total_Sales
FROM rd
GROUP BY Month, Category
ORDER BY Month;
