
-- this script shows top performer among category based on their sales and average sales
SELECT
	Category,
	SUM(Total_Spent) AS Total_Sales,
	CAST(AVG(Total_Spent)AS DECIMAL(10,2)) AS Average_Sales,
	ROW_NUMBER() OVER(ORDER BY SUM(Total_Spent)) AS Ranking
FROM gold.FactSales
GROUP BY Category

-- this script shows top performer among location based on their sales and average sales
SELECT
	Location,
	SUM(Total_Spent) AS Total_Sales,
	CAST(AVG(Total_Spent)AS DECIMAL(10,2)) AS Average_Sales,
	ROW_NUMBER() OVER(ORDER BY SUM(Total_Spent)) AS Ranking
FROM gold.FactSales
GROUP BY Location

-- this script shows top 10 loyal customers based on their expenses
SELECT TOP 10
	Customer_ID,
	SUM(Total_Spent) AS Sales_Per_Customer,
	CAST(AVG(Total_Spent)AS DECIMAL(10,2)) AS Average_Sales_Per_Customer,
	ROW_NUMBER() OVER(ORDER BY SUM(Total_Spent) DESC) AS Rank
FROM gold.FactSales
GROUP BY Customer_ID

-- this script shows top and bottom performers based on sales distribution 
SELECT
	Category,
	SUM(Total_Spent) AS Sales_Per_Customer,
	CAST(AVG(Total_Spent)AS DECIMAL(10,2)) AS Average_Sales_Per_Customer,
	NTILE(4) OVER(ORDER BY SUM(Total_Spent) DESC) AS Quartile_Rank
FROM gold.FactSales
GROUP BY Category


SELECT
	Category,
	SUM(Total_Spent) AS Sales_Per_Customer,
	CAST(AVG(Total_Spent)AS DECIMAL(10,2)) AS Average_Sales_Per_Customer,
	CONCAT(CUME_DIST() OVER(ORDER BY SUM(Total_Spent) DESC) * 100, '%') AS Sales_Distribution_by_Pct
FROM gold.FactSales
GROUP BY Category

