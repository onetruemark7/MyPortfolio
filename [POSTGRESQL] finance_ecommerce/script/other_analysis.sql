-- displays total number of clients/customers
SELECT
	COUNT(*) AS Total_Clients
FROM gold.dim_customer

-- display total number of clients in each cities
SELECT
	city,
	COUNT(*) AS number_of_client
FROM gold.dim_customer
GROUP BY city
ORDER BY city DESC

-- display total number of clients in each year
SELECT
	REGEXP_REPLACE(CAST(DATE_PART('year', customersince)AS TEXT),'9999','Unknown','g') AS Year,
	COUNT(*) AS number_of_client
FROM gold.dim_customer
GROUP BY REGEXP_REPLACE(CAST(DATE_PART('year', customersince)AS TEXT),'9999','Unknown','g')
ORDER BY YEAR ASC

-- display count of clients in each month in year 2024
SELECT
	TO_CHAR(customersince,'Month') AS Month,
	COUNT(*) AS number_of_client
FROM gold.dim_customer
WHERE customersince >= '2024-01-01' AND customersince < '2025-01-01'
GROUP BY TO_CHAR(customersince,'Month'), DATE_TRUNC('month', customersince)
ORDER BY DATE_TRUNC('month', customersince)

-- display distinct records of mechant
SELECT DISTINCT
	merchant
FROM gold.dim_merchant

-- display distinct records of countries
SELECT DISTINCT
	country
FROM gold.dim_merchant

-- display distinct records of category
SELECT DISTINCT
	category
FROM gold.dim_merchant

-- display distinct records of subcategory
SELECT DISTINCT
	subcategory
FROM gold.dim_merchant

-- display distinct records of merchantemail that is not unknown of NA
SELECT DISTINCT
	merchantemail
FROM gold.dim_merchant
WHERE merchantemail !~ 'N/A'

SELECT * FROM gold.dim_merchant