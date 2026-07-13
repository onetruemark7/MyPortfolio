-- display min and max amount of transaction by merchant
SELECT
	merchant,
	MIN(amount) AS minimum_amount,
	MAX(amount) AS maximum_amount
FROM gold.fact_transaction
GROUP BY merchant
ORDER BY minimum_amount, maximum_amount DESC

-- display min and max amount of transaction by type of transaction type
SELECT
	transactiontype,
	MIN(amount) AS minimum_amount,
	MAX(amount) AS maximum_amount
FROM gold.fact_transaction
GROUP BY transactiontype
ORDER BY minimum_amount, maximum_amount DESC

-- display min and max amount of transaction by months in year 2025
SELECT
	TO_CHAR(date, 'Month') AS Month,
	MIN(amount) AS minimum_amount,
	MAX(amount) AS maximum_amount
FROM gold.fact_transaction
WHERE date >= '2025-01-01' AND date < '2026-01-01'
GROUP BY TO_CHAR(date, 'Month'), DATE_PART('Month', date)
ORDER BY DATE_PART('Month', date);

SELECT * FROM gold.fact_transaction