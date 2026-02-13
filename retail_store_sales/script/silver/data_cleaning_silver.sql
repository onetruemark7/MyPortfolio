WITH DataQualityChecks AS (
SELECT
	Transaction_ID,
	Customer_ID,
	Category,
	CASE
		WHEN Item IS NULL THEN 'Other'
		ELSE Item
	END AS Item_correction,
	
	CASE
		WHEN Price_Per_Unit IS NULL THEN CAST(Total_Spent AS DECIMAL(10,2))/CAST(Quantity AS DECIMAL(10,2)) --replacing NULLs with right values
		ELSE ROUND(Price_Per_Unit,2)
	END Price_Per_Unit_correction,

	Quantity,
	Total_Spent,
	Payment_Method,
	Location,
	Transaction_Date,
	Discount_Applied
FROM bronze.csv_retail_store
)

SELECT
	Transaction_ID,
	Customer_ID,
	Category,
	Item_correction AS Item,
	Price_Per_Unit_correction AS Price_Per_Unit,
	Quantity,
	Total_Spent,
	Payment_Method,
	Location,
	Transaction_Date,

	CASE
		WHEN Discount_Applied IS NULL THEN 'N/A'
		ELSE Discount_Applied
	END AS Discount_Applied,

	CASE
	WHEN Quantity IS NULL AND Total_Spent IS NULL THEN 'Incomplete Transaction'
	ELSE 'Complete Transaction'
	END AS DataQuality
FROM DataQualityChecks
ORDER BY DataQuality

