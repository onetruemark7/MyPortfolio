CREATE VIEW gold.DimCustomer AS (
SELECT
	accountid,
	firstname,
	lastname,
	phone,
	email,
	city,
	postalcode,
	customersince
FROM silver.finance_ecommerce
);