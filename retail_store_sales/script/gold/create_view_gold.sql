-- this script creates VIEW for analysis

CREATE VIEW gold.FactSales AS
SELECT
	ROW_NUMBER() OVER(ORDER BY Transaction_Date) AS transaction_key,
	Transaction_ID,
	Customer_ID,
	Category,
	Item,
	Price_Per_Unit,
	Quantity,
	Total_Spent,
	Payment_Method,
	Location,
	Transaction_Date,
	Discount_Applied,
	DataQuality
FROM silver.csv_retail_store