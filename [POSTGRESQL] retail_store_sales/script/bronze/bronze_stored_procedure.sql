/*
this script acts a stored procedure that can be run daily to refresh the dataset
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	TRUNCATE TABLE bronze.csv_retail_store -- resets the tables to empty state

	BULK INSERT bronze.csv_retail_store
	FROM 'C:\Users\Marcus\Desktop\Portfolio\PROJECTX\retail_store_sales\source\retail_store_sales.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	)
END