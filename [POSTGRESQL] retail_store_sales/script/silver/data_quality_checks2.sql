WITH transaction_count AS (
SELECT -- display the records where 1 or 2 out of 3 records contain nulls
	Price_Per_Unit,
	Quantity,
	Total_Spent,
	COUNT(*) as transaction_count
FROM bronze.csv_retail_store
WHERE Quantity IS NULL OR Total_Spent IS NULL OR Price_Per_Unit IS NULL
GROUP BY Price_Per_Unit,
	Quantity,
	Total_Spent
)

SELECT -- counts the number of records that has the same scenario where quantity and total spent in null
SUM(transaction_count) AS two_out_of_three_are_nulls -- txns that has 2 out 3 records are nulls
FROM transaction_count
WHERE Quantity IS NULL AND Total_Spent IS NULL


SELECT -- display count of records that has empty spaces 
	Payment_Method,
	COUNT(*) AS records_empty_spaces
FROM bronze.csv_retail_store
WHERE Payment_Method != TRIM(Payment_Method)
GROUP BY Payment_Method

SELECT -- display count of records that has nulls
	Payment_Method
FROM bronze.csv_retail_store
WHERE Payment_Method IS NULL

SELECT -- shows count of frequent type of discount
	Discount_Applied,
	COUNT(*)
FROM bronze.csv_retail_store
GROUP BY Discount_Applied