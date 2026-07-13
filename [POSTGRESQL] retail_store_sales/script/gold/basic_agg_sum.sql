-- Shows grand total sales
SELECT
	CONCAT('$',CAST(SUM(Total_Spent)AS DECIMAL(10,2))) AS Grand_Total_Sales
FROM gold.FactSales

-- shows total sales by payment method
SELECT
	Payment_Method,
	CONCAT('$',CAST(SUM(Total_Spent)AS DECIMAL(10,2))) AS Total_Sales
FROM gold.FactSales
GROUP BY Payment_Method

-- shows total sales by location
SELECT
	Location,
	CONCAT('$',CAST(SUM(Total_Spent)AS DECIMAL(10,2))) AS Total_Sales
FROM gold.FactSales
GROUP BY Location

-- shows total sales by payment method and location
SELECT
	Payment_Method,
	Location,
	CONCAT('$',CAST(SUM(Total_Spent)AS DECIMAL(10,2))) AS Total_Sales
FROM gold.FactSales
GROUP BY
	Payment_Method,
	Location
ORDER BY Total_Sales DESC

-- shows total sales by payment method and data quality. Transaction kind referd to those orders that are cancelled or did not proceed
SELECT
	Payment_Method,
	DataQuality AS Transaction_Kind,
	CONCAT('$',CAST(SUM(Total_Spent)AS DECIMAL(10,2))) AS Total_Sales
FROM gold.FactSales
GROUP BY
	Payment_Method,
	DataQuality
ORDER BY Total_Sales DESC

-- shows total sales by transaction kind
SELECT
	DataQuality AS Transaction_Kind,
	CASE
		WHEN CAST(SUM(Total_Spent)AS DECIMAL(10,2)) IS NULL THEN 0
		ELSE CAST(SUM(Total_Spent)AS DECIMAL(10,2))
	END Total_Sales
FROM gold.FactSales
GROUP BY DataQuality
ORDER BY Total_Sales DESC