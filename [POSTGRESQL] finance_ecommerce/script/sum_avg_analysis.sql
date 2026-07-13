-- display sum and average amount garnered by every merchant
SELECT
	merchant,
	SUM(amount) AS sum_amount,
	CAST(AVG(amount)AS DECIMAL(10,2)) AS average_amount
FROM gold.fact_transaction
GROUP BY merchant
ORDER BY sum_amount DESC

-- display sum and average amount gained by type of transaction type
SELECT
	transactiontype,
	SUM(amount) AS sum_amount,
	CAST(AVG(amount)AS DECIMAL(10,2)) AS average_amount
FROM gold.fact_transaction
GROUP BY transactiontype
ORDER BY sum_amount DESC

-- display sum and average amount of currency used in transaction
SELECT
	currency,
	SUM(amount) AS sum_amount,
	CAST(AVG(amount)AS DECIMAL(10,2)) AS average_amount
FROM gold.fact_transaction
GROUP BY currency
ORDER BY sum_amount DESC

-- display sum and average amount of fraud transaction
SELECT
	isFraud,
	SUM(amount) AS sum_amount,
	CAST(AVG(amount)AS DECIMAL(10,2)) AS average_amount
FROM gold.fact_transaction
GROUP BY isFraud
ORDER BY sum_amount DESC

SELECT * FROM gold.fact_transaction