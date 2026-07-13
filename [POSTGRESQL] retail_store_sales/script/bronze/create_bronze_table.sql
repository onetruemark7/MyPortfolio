/*
this script creates the table for bronze schema and for Data Ingestion. 
And if the table exists without data on it, 
it gets drop and recreate the table
*/

IF OBJECT_ID ('bronze.csv_retail_store', 'U') IS NOT NULL
	DROP TABLE bronze.csv_retail_store;

CREATE TABLE bronze.csv_retail_store (
	Transaction_ID varchar(50),
	Customer_ID varchar(50),
	Category varchar(50),
	Item varchar(50),
	Price_Per_Unit varchar(50),
	Quantity varchar(50),
	Total_Spent varchar(50),
	Payment_Method varchar(50),
	Location varchar(50),
	Transaction_Date date,
	Discount_Applied varchar(50)
)