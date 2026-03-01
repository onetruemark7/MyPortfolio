-- this displays total records/data in fact_transaction table
SELECT
	COUNT(*) AS "Total_Records"
FROM gold.fact_transaction

-- displays total transactions made by every customer/client
SELECT
	accountid,
	COUNT(*) AS "Total_Transaction"
FROM gold.fact_transaction
GROUP BY accountid
ORDER BY "Total_Transaction" DESC

-- displays total transactions made by every merchant
SELECT
	merchant,
	COUNT(*) AS "Total_Transaction"
FROM gold.fact_transaction
GROUP BY merchant
ORDER BY "Total_Transaction" DESC

-- displays total transactions made by every transaction type
SELECT
	transactiontype AS "Transaction Type",
	COUNT(*) AS "Total_Transaction"
FROM gold.fact_transaction
GROUP BY transactiontype
ORDER BY "Total_Transaction" DESC

-- displays total transactions by currency
SELECT
	currency AS "Currency",
	COUNT(*) AS "Total_Transaction_by_Fiat"
FROM gold.fact_transaction
GROUP BY currency
ORDER BY "Total_Transaction_by_Fiat" DESC

-- displays total counts by transaction description
SELECT
	notes AS "Remarks",
	COUNT(*) AS "Total_Transaction_by_Note"
FROM gold.fact_transaction
GROUP BY notes
ORDER BY "Total_Transaction_by_Note" DESC

-- displays total counts of fraud transactions
SELECT
	isFraud,
	COUNT(*) AS "Count_of_Fraud_Transaction"
FROM gold.fact_transaction
GROUP BY isFraud
ORDER BY "Count_of_Fraud_Transaction" DESC

-- display total transaction by month in a year 2024
SELECT
    TO_CHAR(date, 'Month') AS "Month",
    COUNT(*) AS total_transactions
FROM gold.fact_transaction
WHERE date >= '2024-01-01'
  AND date <  '2025-01-01'
GROUP BY TO_CHAR(date, 'Month'), DATE_PART('month', date)  -- include numeric month for correct sort
ORDER BY DATE_PART('month', date);

SELECT * FROM gold.fact_transaction