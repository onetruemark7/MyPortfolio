-- this create table for silver schema

DROP TABLE IF EXISTS silver.finance_ecommerce;

CREATE TABLE silver.finance_ecommerce (
	transactionid VARCHAR(50),
	date date,
	accountid VARCHAR(50),
	firstname VARCHAR(50),
	lastname VARCHAR(50),
	transactiontype VARCHAR(50),
	amount DECIMAL(10,2),
	currency VARCHAR(50),
	exchangerate DECIMAL(10,2),
	balance DECIMAL(15,2),
	merchant VARCHAR(50),
	merchantphone VARCHAR(20),
	merchantemail VARCHAR(50),
	category VARCHAR(50),
	subcategory VARCHAR(50),
	country VARCHAR(50),
	city VARCHAR(50),
	postalcode INT,
	cardnumber VARCHAR(50),
	email VARCHAR(50),
	phone VARCHAR(20),
	isFraud VARCHAR(10),
	notes VARCHAR(100),
	customersince date
);