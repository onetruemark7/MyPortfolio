
--This script shows total sales, count of orders, and average sales per category
SELECT
	Category,
	SUM(Total_Spent) AS total_sales,
	COUNT(*) AS order_count,
	CAST(AVG(Total_Spent)AS DECIMAL(10,2)) AS average_sales
FROM gold.FactSales
GROUP BY Category




-- this script shows average order per customer
SELECT 
	Customer_ID,
	CAST(SUM(Total_Spent) / COUNT(Total_Spent) AS DECIMAL(10,2))  AS average_order_per_customer
FROM gold.FactSales
WHERE DataQuality = 'Complete Transaction'
GROUP BY
	Customer_ID
ORDER BY average_order_per_customer DESC