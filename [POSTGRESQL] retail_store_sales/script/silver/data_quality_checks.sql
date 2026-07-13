/*
DATA QUALITY CHECKS
*/

-- this code checks if theres duplicate in this particular column. shows duplicates
SELECT
	Transaction_ID,
	COUNT(*)
FROM bronze.csv_retail_store
GROUP BY Transaction_ID
HAVING COUNT(Transaction_ID) > 1 OR Transaction_ID IS NULL

-- this code checks if theres leading and trailing spaces. checks empty spaces. checks null values
SELECT
	Customer_ID
FROM bronze.csv_retail_store
WHERE Customer_ID != TRIM(Customer_ID) OR Customer_ID = '' OR Customer_ID IS NULL

