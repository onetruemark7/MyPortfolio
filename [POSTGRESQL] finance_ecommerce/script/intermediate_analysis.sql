/*
1. High-Value Merchant Identification
"I need to know which merchants are driving the most value. Can you identify the top 5 merchants based on the total transaction volume (normalized to our base currency)? Please filter for only 'Debit' transactions and use the formula amount * exchangerate for the calculation."
*/

WITH totalvolume AS (
SELECT
	merchant,
	amount,
	exchangerate,
	CAST(amount * exchangerate AS DECIMAL(10,2)) AS total_volume
FROM gold.fact_transaction
WHERE transactiontype = 'Debit'
)

SELECT
	merchant AS "Merchant Name",
	SUM(total_volume) AS "Total Sum"
FROM totalvolume
GROUP BY merchant
ORDER BY "Total Sum" DESC
LIMIT 5

-- ===============================================================================================================================

/*
2. Regional Spending Insights
"We want to understand which cities are our biggest markets. Could you provide a breakdown of total spending and average transaction value per city? You'll need to link the transactions to the customers' city for this."
*/

SELECT
	c.city AS "City",
	CAST(SUM(ft.amount)AS DECIMAL(10,2)) AS total_spending,
	CAST(AVG(ft.amount)AS DECIMAL(10,2)) AS average_value
FROM gold.fact_transaction ft
LEFT JOIN gold.dim_customer c
	ON ft.accountid = c.accountid
WHERE c.city !~ 'N/A' OR c.city IS NULL
GROUP BY c.city
ORDER BY total_spending DESC, average_value DESC


-- ===============================================================================================================================

/*
3. Category Fraud Risk Assessment
"Security is a priority. Which merchant category (e.g., Electronics, Travel, etc.) has the highest count of transactions flagged as fraud (isfraud = 'Yes')? This will help us decide where to tighten our verification processes."
*/

SELECT
	category AS "Category",
	COUNT(*) AS "Fraud Count"
FROM gold.fact_transaction ft
JOIN gold.dim_merchant m
	ON ft.merchant = m.merchant
WHERE isFraud = 'Yes'
GROUP BY "Category"
ORDER BY "Fraud Count" DESC

-- ===============================================================================================================================

/*
4. Refund Rate by Category
"A high refund rate can indicate issues with service or product quality. For each merchant category, what is the percentage of 'Refund' transactions compared to the total number of transactions in that category?"
*/

WITH transaction_count AS (
SELECT
	category,
	REGEXP_REPLACE(transactiontype,'N/A','Other','g') AS transactiontype,
	COUNT(*) AS total_transaction
FROM gold.fact_transaction ft
JOIN gold.dim_merchant m
	ON ft.merchant = m.merchant
GROUP BY category,
	transactiontype
)
, transaction_sum AS (
SELECT
	category,
	transactiontype,
	total_transaction,
	SUM(total_transaction) OVER(PARTITION BY category) AS total_transaction_by_category
FROM transaction_count
)
SELECT 
	category,
	transactiontype,
	total_transaction AS total_transaction_by_refund,
	total_transaction_by_category,
	
	  CASE
		WHEN transactiontype = 'Refund'
			THEN CAST((total_transaction / total_transaction_by_category) * 100 AS DECIMAL(10,2))
		ELSE 0
	END || '%' AS refund_rate
FROM transaction_sum
WHERE transactiontype = 'Refund'


-- ===============================================================================================================================

/*
5. Temporal Volume Trends
"I'd like to see how our business grew last year. Can you show the monthly trend of total transaction volume (normalized) for the calendar year 2024? I want to see if there are specific months where spending peaks."
*/

WITH monthlysum AS (
SELECT
	TO_CHAR(date, 'Month') AS Month,
	SUM(amount) AS total_sum
FROM gold.fact_transaction
WHERE date >= '2024-01-01' AND date < '2025-01-01'
GROUP BY TO_CHAR(date, 'Month'), DATE_PART('Month',date)
)
SELECT
	Month,
	'$'|| total_sum,
	ROW_NUMBER() OVER(ORDER BY total_sum DESC) AS rank_based_on_total_volume
FROM monthlysum