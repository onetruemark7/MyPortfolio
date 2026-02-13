/*
this script creates the silver table. it empties and recreate the table if theres no data in it.
*/


IF OBJECT_ID ('silver.csv_retail_store','U') IS NOT NULL
	DROP TABLE silver.csv_retail_store;

CREATE TABLE silver.csv_retail_store (
	Transaction_ID varchar(50),
	Customer_ID varchar(50),
	Category varchar(50),
	Item varchar(50),
	Price_Per_Unit DECIMAL(10,2),
	Quantity DECIMAL(10,2),
	Total_Spent DECIMAL(10,2),      
	Payment_Method varchar(50),
	Location varchar(50),
	Transaction_Date date,
	Discount_Applied varchar(50),
	creation_date DATETIME2 DEFAULT GETDATE()
)