ADVANCE ANALYSIS

/*
1. Retention - "The One-Hit Wonders": Identify the percentage of customers who made a purchase in 2024 but have NOT made a single transaction in 2025.
*/

WITH 
    purchasers_2024 AS (
        -- Customers who made at least one purchase (Debit) in 2024
        SELECT DISTINCT accountid
        FROM gold.fact_transaction
        WHERE date >= '2024-01-01'
          AND date <= '2024-12-31'
          AND transactiontype = 'Debit'
    ),
    
    active_2025 AS (
        -- Customers who had ANY transaction (Debit/Credit/Refund) in 2025
        SELECT DISTINCT accountid
        FROM gold.fact_transaction
        WHERE date >= '2025-01-01'
          AND date <= '2025-12-31'
    )

SELECT 
    COUNT(*) AS one_hit_wonders_count,
    (SELECT COUNT(*) FROM purchasers_2024) AS total_2024_purchasers,
    ROUND(
        100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM purchasers_2024), 0), 
        2
    ) || '%'AS percentage_one_hit_wonders
FROM purchasers_2024 p
WHERE p.accountid NOT IN (SELECT accountid FROM active_2025);

/*===================================================================================================
=====================================================================================================*/

/*
2. Customer Lifetime Value (CLV): Rank customers into "Gold" (Top 10%), "Silver" (Next 20%), and "Bronze" (Rest) based on their cumulative normalized spending.
*/

WITH spenders AS (
SELECT
	accountid,
	SUM(amount) AS total_expenses
FROM gold.fact_transaction
WHERE transactiontype !~ 'Refund'
GROUP BY accountid
)
, tiers AS (
SELECT
	accountid,
	total_expenses,
	NTILE(10) OVER(ORDER BY total_expenses DESC) AS tier
FROM spenders
)

SELECT
	firstname || ' ' || lastname AS Customer_name,
	total_expenses,
	CASE
		WHEN tier = 1 THEN 'Gold'
		WHEN tier = 2 THEN 'Silver'
		ELSE 'Bronze'
	END AS CLV_rank
FROM tiers t1
JOIN gold.dim_customer t2
	ON t1.accountid = t2.accountid
ORDER BY total_expenses DESC

/*===================================================================================================
=====================================================================================================*/

/*
3. Velocity Tracking: Find customers who have made more than 3 transactions within a single 24-hour window. This is a key indicator for both high loyalty and potential fraud.
*/
WITH txn_count_in_24hours AS (
SELECT
	accountid,
	date,
	COUNT(*) OVER(
		PARTITION BY accountid 
		ORDER BY date 
		RANGE BETWEEN INTERVAL '23 hours 59 minutes 59 seconds' PRECEDING AND CURRENT ROW) AS txn_count
FROM gold.fact_transaction
)
, potential_fraud AS (
SELECT DISTINCT
	accountid
FROM txn_count_in_24hours
WHERE txn_count >= 3
)
SELECT
	t1.accountid,
	t2.firstname || ' ' || t2.lastname AS customer_name,
	t2.city AS city
FROM potential_fraud t1
JOIN gold.dim_customer t2
	ON t1.accountid = t2.accountid
	
/*===================================================================================================
=====================================================================================================*/

/*
4. Running Total Growth: Calculate a daily running total of revenue for each month in 2024. I want to see how quickly we hit our monthly targets.
*/

WITH monthlyrev AS (
SELECT
	CAST(DATE_TRUNC('Month', date)AS DATE) AS Month,
	SUM(amount) AS total_sum
FROM gold.fact_transaction
WHERE date >= '2024-01-01' AND date <= '2024-12-31'
GROUP BY CAST(DATE_TRUNC('Month', date)AS DATE)
)
, prev_month_rev AS (
SELECT
	Month,
	total_sum,
	LAG(total_sum,1) OVER(ORDER BY Month) AS Prev_month_rev
FROM monthlyrev
)

SELECT
	Month AS month_date,
	DATE_PART('Month', Month),
	total_sum AS revenue,
	COALESCE(Prev_month_rev, 0.00) AS previous_month_revenue,
	COALESCE(ROUND(((total_sum - Prev_month_rev)/ Prev_month_rev) * 100,2),0) || '%' AS Running_monthly_growth
FROM prev_month_rev

/*===================================================================================================
=====================================================================================================*/

/*
5. Month-over-Month (MoM) Growth: Calculate the percentage change in total transaction volume between the current month and the previous month.
*/
WITH monthly_rev AS (
SELECT
	DATE_TRUNC('Month', date) AS date_month,
	SUM(amount) AS revenue_in_a_month
FROM gold.fact_transaction
GROUP BY DATE_TRUNC('Month', date)
)
, prev_month_rev AS(
SELECT
	date_month,
	revenue_in_a_month,
	COALESCE(LAG(revenue_in_a_month,1) OVER(ORDER BY date_month) ,0) AS prev_month_revenue
FROM monthly_rev
)

SELECT
	CAST(date_month AS DATE) month_date,
	TO_CHAR(date_month, 'Month') AS month_name,
	revenue_in_a_month,
	prev_month_revenue,
	ROUND(COALESCE(((revenue_in_a_month - prev_month_revenue) / NULLIF(prev_month_revenue,0)) * 100,0),2) || '%' AS growth_pct
FROM prev_month_rev
ORDER BY month_date

/*===================================================================================================
=====================================================================================================*/


/*
6. Currency Impact Analysis: Calculate the total revenue lost or gained by comparing the amount * exchangerate against a "Fixed Budget Rate" (assume a flat rate of 80 for all non-USD transactions).
*/

WITH realized_value AS (
SELECT
	accountid,
	currencyid,
	merchantid,
	CAST(DATE_TRUNC('Month',date)AS DATE) AS month_date,
	TO_CHAR(DATE_TRUNC('Year',date),'YYYY') AS year_date,
	amount,
	exchangerate,
	amount * exchangerate AS actual_realized_value,
	CASE
		WHEN currencyid = 15 THEN amount * exchangerate
		ELSE amount * 80
	END AS budget_realized_value
FROM gold.fact_transaction
WHERE transactiontypeid = 12
)

-- display total gained and total lost
, total_gained_and_lost AS (
SELECT
	 --'$' || TO_CHAR(
		ROUND(
			SUM(CASE
				WHEN actual_realized_value - budget_realized_value > 0 THEN actual_realized_value
				ELSE 0
		END)
		,2) AS total_gained,
	--,'FM999,999,999.00')AS total_gained,

	--'$' || TO_CHAR(
		ROUND(
			SUM(CASE
				WHEN actual_realized_value - budget_realized_value < 0 THEN budget_realized_value
				ELSE 0
			END) 
		,2) AS total_lost
	--,'FM999,999,999.00') AS total_lost
FROM realized_value
)

-- displays net foreign exchange impact
SELECT 
	'$'|| TO_CHAR(ROUND(SUM(actual_realized_value - budget_realized_value),2),'FM999,999,999.00') AS net_fx_impact
FROM realized_value

/*===================================================================================================
=====================================================================================================*/

/*
7. The "Suspect" Merchant: Identify merchants where the average transaction amount for Fraudulent transactions is significantly higher (e.g., 2x higher) than their average Legitimate transaction.
*/

WITH average_expenses_fraud AS (
SELECT
	merchant,
	ROUND(AVG(amount),2) AS average_fraud_expenses
FROM gold.fact_transaction
WHERE isFraud = 'Yes'
GROUP BY merchant
)
, average_expenses_legit AS (
SELECT
	merchant,
	ROUND(AVG(amount),2) average_legit_expenses
FROM gold.fact_transaction
WHERE isFraud = 'No'
GROUP BY merchant
)

SELECT
	t1.merchant AS merchant_name,
	t1.average_fraud_expenses
FROM average_expenses_fraud t1
JOIN average_expenses_legit t2
	ON t1.merchant = t2.merchant
WHERE t1.average_fraud_expenses >= t2.average_legit_expenses * 2

/*===================================================================================================
=====================================================================================================*/

/*
8. Category Concentration: For each customer, identify their "Preferred Category" (the category where they spend the most money).
*/
WITH subtotal_rev AS (
SELECT
	ft1.accountid,
	ft2.category,
	SUM(ft1.amount) AS subtotal
FROM gold.fact_transaction ft1
JOIN silver.finance_ecommerce ft2
	ON ft1.accountid = ft2.accountid
GROUP BY 
	ft1.accountid,
	ft2.category
)

SELECT
	accountid,
	category,
	subtotal
FROM (
	SELECT
		accountid,
		category,
		subtotal,
		ROW_NUMBER() OVER(
			PARTITION BY accountid
			ORDER BY subtotal
		) AS subtotal_rank
	FROM subtotal_rev
) t
WHERE subtotal_rank = 1
ORDER BY subtotal DESC

/*===================================================================================================
=====================================================================================================*/

/*
9. Gap Analysis: Find the average number of days between a customer's first purchase and their second purchase.
*/
WITH customer_purchase_dates AS (
SELECT
	accountid,
	date
FROM gold.fact_transaction
ORDER BY accountid, date
)
, nextorder_date AS (
SELECT
	accountid,
	date,
	next_order_date,
	COUNT(*) 
FROM (SELECT
	accountid,
	date,
	LEAD(date,1) OVER(PARTITION BY accountid ORDER BY date) AS next_order_date
FROM customer_purchase_dates)
WHERE next_order_date IS NOT NULL
GROUP BY 
	accountid,
	date,
	next_order_date
HAVING COUNT(*) = 1
)

SELECT
	accountid,
	date,
	next_order_date,
	ROUND(AVG(EXTRACT(DAYS FROM AGE(next_order_date, date))),0) || ' days' AS average_days_between_first_and_second_purchase
FROM nextorder_date
GROUP BY
	accountid,
	date,
	next_order_date
HAVING AVG(EXTRACT(DAYS FROM AGE(next_order_date, date))) != 0
ORDER BY average_days_between_first_and_second_purchase

/*===================================================================================================
=====================================================================================================*/

/*
10. Cross-Border Patterns: List customers who have used their card at merchants located in more than 3 different countries within the same month.
*/

WITH monthly_country_counts AS (
    SELECT 
        t.accountid,
        DATE_TRUNC('month', t.date) AS month_start,
        COUNT(DISTINCT t.countryid) AS distinct_countries,
        ARRAY_AGG(DISTINCT c.country ORDER BY c.country) AS countries_used
    FROM gold.fact_transaction t
    JOIN gold.dim_country c ON t.countryid = c.countryid
    WHERE t.transactiontypeid = 12                     -- Debit only
      AND t.countryid != 14                            -- exclude N/A
      AND t.date IS NOT NULL
    GROUP BY t.accountid, DATE_TRUNC('month', t.date)
    HAVING COUNT(DISTINCT t.countryid) > 3             -- more than 3
),

enriched AS (
    SELECT 
        m.accountid,
        m.month_start,
        m.distinct_countries,
        m.countries_used,
        cust.firstname,
        cust.lastname,
        cust.city,
        cust.customersince::date,
        COUNT(*) OVER (PARTITION BY m.accountid) AS qualifying_months_for_this_customer
    FROM monthly_country_counts m
    LEFT JOIN gold.dim_customer cust 
           ON m.accountid = cust.accountid
)

SELECT 
    accountid,
    firstname || ' ' || lastname AS customer_name,
    city,
    TO_CHAR(month_start, 'YYYY-MM') AS month_year,
    distinct_countries,
    countries_used,
    qualifying_months_for_this_customer AS times_this_customer_triggered,
    customersince
FROM enriched
ORDER BY 
    qualifying_months_for_this_customer DESC,
    distinct_countries DESC,
    month_start DESC,
    accountid;