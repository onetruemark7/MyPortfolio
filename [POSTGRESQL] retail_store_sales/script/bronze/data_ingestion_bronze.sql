/*
this script ingest the raw datasets from the file. It will delete the rows first before inserting the dataset. Refreshes the bronze table.
*/


	TRUNCATE TABLE bronze.csv_retail_store -- resets the tables to empty state

	BULK INSERT bronze.csv_retail_store
	FROM 'C:\Users\Marcus\Desktop\Portfolio\PROJECTX\retail_store_sales\source\retail_store_sales.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	)

	

