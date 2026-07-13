-- this script shows revenue per year
SELECT
	YEAR(DATETRUNC(YEAR, Transaction_Date)) AS Year,
	SUM(Total_Spent) AS Revenue
FROM gold.FactSales
GROUP BY DATETRUNC(YEAR, Transaction_Date)
ORDER BY Year

-- this script shows revenue per month
SELECT
	DATETRUNC(MONTH, Transaction_Date) AS Month,
	SUM(Total_Spent) AS Revenue
FROM gold.FactSales
GROUP BY DATETRUNC(MONTH, Transaction_Date)
ORDER BY Month

-- this script shows revenue per week in january through the end of march (Q1) 2022
SELECT
	DATETRUNC(WEEK, Transaction_Date) AS Week,
	SUM(Total_Spent) AS Revenue
FROM gold.FactSales
GROUP BY DATETRUNC(WEEK, Transaction_Date)
HAVING DATETRUNC(WEEK, Transaction_Date) >= '2022-01-01' AND DATETRUNC(WEEK, Transaction_Date) <= '2022-03-31'
ORDER BY Week

-- **************************************************************************************************************************
/*
This script shows daily running average sales and growth percentage in December 2023 by Beverages
*/
WITH avgagg AS (
SELECT
	Category,
	DATETRUNC(DAY, Transaction_Date) AS Date,
	AVG(Total_Spent) AS Sales
FROM gold.FactSales
GROUP BY
	Category,
	DATETRUNC(DAY, Transaction_Date)
)

SELECT
	Category,
	Date,
	CAST(Sales AS DECIMAL(10,2)) AS Avg_Sales,
	COALESCE(CAST(LAG(Sales,1) OVER(ORDER BY Date)AS DECIMAL(10,2)),0) AS Previous_Avg_Sales,
	CAST(AVG(Sales) OVER(PARTITION BY Category ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)AS DECIMAL(10,2)) Running_Avg_Sales
FROM avgagg
WHERE Date >= '2023-12-01' AND Date <= '2023-12-31' AND Category = 'Beverages'
-- **************************************************************************************************************************


-- **************************************************************************************************************************
/*
This script shows month over month sales and growth percentage by Computer and Electric Accessory category
*/
WITH sum_agg AS (
SELECT
	Category,
	DATETRUNC(MONTH,Transaction_Date) AS Txn_Date,
	SUM(Total_Spent) AS total_Sales
FROM gold.FactSales
WHERE DataQuality = 'Complete Transaction' 
GROUP BY Category,
		DATETRUNC(MONTH,Transaction_Date)
)

SELECT
	Category,
	Txn_Date,
	total_Sales,
	COALESCE(LAG(total_Sales,1) OVER(ORDER BY Txn_Date),0) AS Prev_Sales,
	COALESCE(
			CAST(
				((total_Sales - LAG(total_Sales,1) OVER(ORDER BY Txn_Date)) / 
					LAG(total_Sales,1) OVER(ORDER BY Txn_Date)) * 100
			AS DECIMAL(10,2))
		,0) AS Growth_Pct
FROM sum_agg
WHERE Category = 'Computers and electric accessories'
-- **************************************************************************************************************************
