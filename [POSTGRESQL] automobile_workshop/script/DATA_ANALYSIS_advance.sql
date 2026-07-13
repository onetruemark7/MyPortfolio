/*
Running Total & Contribution: Calculate a daily running total of revenue for each workshop location throughout the year and show what percentage the current day's revenue contributes to that running total.
*/
WITH sub_revenue AS (
SELECT
	workshop_location_id,
	DATE_TRUNC('DAY',date)::DATE AS txn_date,
	SUM(service_cost) AS subtotal_revenue
FROM gold.fact_transaction
WHERE
	date >= '2025-01-01' AND
	date <= '2025-12-31'
GROUP BY
	workshop_location_id,
	DATE_TRUNC('DAY',date)::DATE
)
, runningtotal AS (
SELECT
	workshop_location_id,
	txn_date,
	subtotal_revenue,
	SUM(subtotal_revenue) OVER(
		PARTITION BY workshop_location_id 
		ORDER BY txn_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total
FROM sub_revenue
)

SELECT
	t2.workshop_location,
	t1.txn_date,
	t1.subtotal_revenue AS day_revenue,
	t1.running_total AS running_total_revenue,
	((t1.subtotal_revenue::NUMERIC / NULLIF(t1.running_total,0)) * 100)::DECIMAL(10,0) || '%' AS pct_growth
FROM runningtotal t1
JOIN gold.dim_workshoplocation t2
	ON t1.workshop_location_id = t2.workshop_location_id
-- WHERE t2.workshop_location IN ('Main Bay') -- can change location, according to liking
ORDER BY txn_date

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Mechanic Performance Quartiles: Use a window function to divide mechanics into four quartiles (NTILE) based on their total generated revenue. Who are the mechanics in the top 25%?
*/

WITH mechanic_revenue AS (
SELECT
	mechanic_name_id,
	SUM(service_cost) AS revenue
FROM gold.fact_transaction
GROUP BY mechanic_name_id
)

SELECT
	t2.mechanic_name,
	TO_CHAR(t1.revenue,'$999,999,999.99') AS revenue,
	-- NTILE(4) OVER(ORDER BY t1.revenue DESC) AS quartiles,
	CASE
		WHEN NTILE(4) OVER(ORDER BY t1.revenue DESC) = 1 THEN '25th'
		WHEN NTILE(4) OVER(ORDER BY t1.revenue DESC) = 2 THEN '50th'
		WHEN NTILE(4) OVER(ORDER BY t1.revenue DESC) = 3 THEN '75th'
		ELSE '100th'
	END AS quartiles
FROM mechanic_revenue t1
JOIN gold.dim_mechanicname t2
	ON t1.mechanic_name_id = t2.mechanic_name_id

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Customer Churn Risk: Identify "at-risk" customers. These are defined as customers who have visited at least twice in the past, but whose last visit was more than 90 days ago compared to the most recent date in the dataset.
*/
WITH orderdates AS (
SELECT
	customer_id,
	date,
	MIN(date) OVER(PARTITION BY customer_id) AS first_purchase_date,
	MAX(date) OVER(
		PARTITION BY customer_id 
		ORDER BY date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS nxt_purchase_date
FROM gold.fact_transaction
ORDER BY customer_id
)
, daygaps AS (
SELECT
	customer_id,
	date,
	first_purchase_date,
	nxt_purchase_date,
	EXTRACT(DAY FROM AGE(first_purchase_date , nxt_purchase_date)) as DayGaps
FROM orderdates
)

SELECT
	customer_id,
	date,
	first_purchase_date,
	nxt_purchase_date,
	DayGaps
FROM daygaps
WHERE daygaps > 90

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Month-over-Month (MoM) Growth: Calculate the percentage growth in total revenue for each month compared to the previous month. Highlight months where growth was negative.
*/
WITH monthly_revenue AS (
SELECT
	DATE_TRUNC('Month',date)::DATE AS month_date,
	SUM(service_cost) AS revenue
FROM gold.fact_transaction
GROUP BY DATE_TRUNC('Month',date)::DATE
)
, running_total AS (
SELECT
	month_date,
	revenue,
	SUM(revenue) OVER(
		ORDER BY month_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total_revenue
FROM monthly_revenue
)

SELECT
	month_date,
	revenue,
	running_total_revenue,
	ROUND(((revenue / NULLIF(running_total_revenue,0)) * 100),2) || '%' AS growth_pct
FROM running_total

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Service Sequence Analysis: For customers with multiple visits, find the most common "next service." (e.g., if a customer gets an 'Oil Change', what is the most frequent service they get on their very next visit?)
*/
WITH services_count AS (
SELECT
	customer_id,
	servicetypeid,
	COUNT(*) AS number_services_availed
FROM gold.fact_transaction
GROUP BY
	customer_id,
	servicetypeid
)

SELECT
	customer_id,
	servicetypeid,
	number_services_availed,
	FIRST_VALUE(servicetypeid) OVER(PARTITION BY customer_id ORDER BY number_services_availed DESC) AS most_frequent_service,
	LEAD(servicetypeid,1) OVER(PARTITION BY customer_id ORDER BY number_services_availed DESC) AS next_possible_service
FROM services_count
ORDER BY customer_id, number_services_availed DESC

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Outlier Detection (Wait Times): Calculate the Standard Deviation of wait_time_mins. Identify all transactions where the wait time was more than 2 standard deviations above the mean for that specific service type.
*/
WITH calculations AS (
SELECT
	servicetypeid,
	ROUND(STDDEV(wait_time_mins),2)  AS standard_deviation_mins,
	ROUND(AVG(wait_time_mins),2) AS mean
FROM gold.fact_transaction
WHERE wait_time_mins IS NOT NULL 
GROUP BY servicetypeid
)
, threshold_calc AS (
SELECT
	servicetypeid,
	standard_deviation_mins,
	mean,
	mean + (2*standard_deviation_mins) AS Threshold
FROM calculations
)

SELECT
	t1.id,
	t3.service_type,
	t1.wait_time_mins
FROM gold.fact_transaction t1
JOIN threshold_calc t2
	ON t1.servicetypeid = t2.servicetypeid
JOIN gold.dim_servicetype t3
	ON t2.servicetypeid = t3.servicetypeid
WHERE t1.wait_time_mins > t2.Threshold

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Location Loyalty Rate: Calculate the "Loyalty Rate" for each workshop—defined as the number of unique customers who have visited that specific location more than once, divided by the total number of unique customers for that location.
*/

WITH aggre_unique_customer AS (
SELECT
	workshop_location_id,
	customer_id,
	COUNT(*) AS customer_count
FROM gold.fact_transaction
GROUP BY 
	workshop_location_id,
	customer_id
HAVING COUNT(*) > 1
)
, totalcustomer_per_location AS (
SELECT
	workshop_location_id,
	customer_id,
	customer_count,
	SUM(customer_count) OVER(PARTITION BY workshop_location_id) AS total_customer
FROM aggre_unique_customer 
)

SELECT DISTINCT
	t2.workshop_location,
	((t1.customer_count / t1.total_customer)*100)::NUMERIC(10,2) || '%' AS loyalty_rate
FROM totalcustomer_per_location t1
JOIN gold.dim_workshoplocation t2
	ON t1.workshop_location_id = t2.workshop_location_id
	
/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Cumulative Discount Impact: Find the "Break-even" point for each month. This is the day of the month when the cumulative service_cost finally exceeded the total discount_given for that entire month.
*/
WITH revenue_discount_daily AS (
SELECT
	DATE_TRUNC('Day',date)::DATE AS date_month,
	SUM(service_cost) AS revenue_daily,
	SUM(discount_given) AS discount_offered
FROM gold.fact_transaction
GROUP BY DATE_TRUNC('Day',date)::DATE
)
, breakeven_date AS (
SELECT
	date_month AS date_daily,
	TO_CHAR(date_month,'YYYY-Month') AS date_month,
	revenue_daily,
	SUM(revenue_daily) OVER(
		PARTITION BY DATE_TRUNC('Month',date_month)::DATE
		ORDER BY DATE_TRUNC('Day',date_month)::DATE
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS running_daily_revenue,
	SUM(discount_offered) OVER(PARTITION BY DATE_TRUNC('Month',date_month)) AS total_discount_given_in_a_month
FROM revenue_discount_daily
ORDER BY DATE_TRUNC('Day',date_month)::DATE
)
, fetching_breakeven_date AS (
SELECT
	date_daily,
	date_month,
	revenue_daily,
	running_daily_revenue,
	total_discount_given_in_a_month,
	ROW_NUMBER() OVER(
		PARTITION BY DATE_TRUNC('Month',date_daily::DATE)
		ORDER BY DATE_TRUNC('Month',date_daily::DATE)
	) AS rank_by_breakeven_date
FROM breakeven_date
WHERE
	running_daily_revenue >= total_discount_given_in_a_month
)

SELECT
	TO_CHAR(date_daily,'YYYY Month DD') AS date,
	revenue_daily,
	running_daily_revenue,
	total_discount_given_in_a_month
FROM fetching_breakeven_date
WHERE rank_by_breakeven_date = 1

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
The "Slow-Motion" Mechanic: Identify mechanics whose average wait_time_mins is increasing month-over-month over a three-month period.
*/
WITH average_wait_per_mechanic AS (
SELECT
	DATE_TRUNC('Month',date)::DATE AS date,
	mechanic_name_id,
	AVG(wait_time_mins)::NUMERIC(10,2) AS average_wait_time_mins
FROM gold.fact_transaction
GROUP BY
	DATE_TRUNC('Month',date)::DATE,
	mechanic_name_id
)
, growth_per_mechanic AS (
SELECT
	date,
	mechanic_name_id,
	average_wait_time_mins,
	((average_wait_time_mins / NULLIF(SUM(average_wait_time_mins) OVER(),0)) * 100)::NUMERIC(10,2) AS growth_pct
FROM average_wait_per_mechanic
)
, lead_growth_pct AS (
SELECT
	date,
	mechanic_name_id,
	average_wait_time_mins,
	growth_pct,
	LEAD(growth_pct,1) OVER() AS nxt_growth_pct,
	LEAD(growth_pct,2) OVER() AS nxt_nxt_growth_pct,
	CASE
		WHEN
			LEAD(growth_pct,2) OVER() > LEAD(growth_pct,1) OVER() AND
			LEAD(growth_pct,1) OVER() > growth_pct
				THEN 'three_month_performer'
		ELSE 'in progress'
	END AS MoM_Performer_Remark
FROM growth_per_mechanic
)
SELECT
	date,
	mechanic_name_id,
	average_wait_time_mins,
	growth_pct,
	nxt_growth_pct AS nxt_month_growth_pct,
	nxt_nxt_growth_pct AS nxt_nxt_month_growth_pct,
	MoM_Performer_Remark
FROM 
	(SELECT
		date,
		mechanic_name_id,
		average_wait_time_mins,
		growth_pct,
		LEAD(growth_pct,1) OVER() AS nxt_growth_pct,
		LEAD(growth_pct,2) OVER() AS nxt_nxt_growth_pct,
		MoM_Performer_Remark
		FROM lead_growth_pct
		ORDER BY
			mechanic_name_id,
			date
	)m
WHERE MoM_Performer_Remark = 'three_month_performer'
	
/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Revenue Gap Analysis: Find the average number of days between visits for repeat customers. Group this by service_type to see which services lead to the fastest return visits.
*/
WITH order_dates AS (
SELECT
	customer_id,
	date AS order_date,
	servicetypeid,
	LEAD(date,1)
		OVER(
			PARTITION BY customer_id
			ORDER BY date
		) AS nxt_order_date
FROM gold.fact_transaction
)

SELECT
	t2.service_type AS service_type,
	AVG(
		COALESCE(
			EXTRACT(DAY FROM AGE(t1.nxt_order_date,t1.order_date))
		,0) 
	)::NUMERIC(10,2) AS average_day_gaps_of_purchases
FROM order_dates t1
JOIN gold.dim_servicetype t2
	ON t1.servicetypeid = t2.servicetypeid
GROUP BY t2.service_type
ORDER BY average_day_gaps_of_purchases

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Top N Percentile of Spending: Identify the specific customers whose total spending falls into the top 10% of the entire customer base. Return their customer_id and total spent, sorted by the highest spenders first.
*/

WITH expenses_per_customer AS (
SELECT
	customer_id,
	SUM(service_cost) AS total_expenses
FROM gold.fact_transaction
GROUP BY customer_id
ORDER BY total_expenses DESC
)

SELECT
	customer_id,
	TO_CHAR(total_expenses,'$999,999,999.00') AS total_expenses,
	CASE
		WHEN ranking_by_expenses = 1 THEN 'Top 10%'
		ELSE ''
	END AS ranking_by_expenses
FROM
	(SELECT
		customer_id,
		total_expenses,
		NTILE(10)
			OVER(
				ORDER BY total_expenses DESC
			) AS ranking_by_expenses
	FROM expenses_per_customer)
WHERE ranking_by_expenses = 1
ORDER BY total_expenses DESC

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Market Basket Analysis (Service Pairing): Determine which two services are most frequently performed together for the same customer on the same visit (or within 24 hours). This requires a self-join on the fact table.
*/

-- counts all transactions. or total baskets. this baskets were transactions of products/services bought/availed recorded. basically, a fact.
WITH total_basket AS (
SELECT 
	COUNT(DISTINCT id) AS total_txn
FROM gold.fact_transaction
)

-- this displays the transactions where product/service (A) are paired with product/service (B)
, service_pairs AS (
SELECT
	t1.servicetypeid AS item_a,
	t2.servicetypeid AS item_b,
	COUNT(DISTINCT t1.id) AS count_occurrence
FROM gold.fact_transaction t1
JOIN gold.fact_transaction t2
	ON t1.servicetypeid = t2.servicetypeid
WHERE t1.servicetypeid < t2.servicetypeid
GROUP BY
	t1.servicetypeid,
	t2.servicetypeid
)

-- this displays the number of times where services are availed in the entire transaction
, services_txn AS (
SELECT
	servicetypeid AS item,
	COUNT(DISTINCT id) AS item_count
FROM gold.fact_transaction
GROUP BY servicetypeid
)

-- this display the metrics
SELECT
	sp.item_a,
	sp.item_b,
	sp.count_occurrence,

	sp.count_occurrence::FLOAT / tb.total_txn AS support, -- this displays SUPPORT
	sp.count_occurrence::FLOAT / st1.item_count AS confidence, -- this displays CONFIDENCE
	((sp.count_occurrence::FLOAT / st1.item_count) / (st2.item_count / tb.total_txn)) AS lift -- this displays LIFTS
FROM service_pairs sp
CROSS JOIN total_basket tb
JOIN services_txn st1
	ON sp.item_a = st1.item
JOIN services_txn st2
	ON sp.item_b = st1.item

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Customer Retention Heatmap Data: For each month, calculate the "New Customer Rate" (customers whose first-ever visit was that month) versus the "Returning Customer Rate" (customers who had visited in any previous month).
*/

WITH cust_first_ever_txn AS (
SELECT DISTINCT
	customer_id,
	MIN(date) AS first_ever_transaction_date
FROM gold.fact_transaction
GROUP BY customer_id
)
, customer_type AS (
SELECT
	ft.customer_id,
	ft.date AS visit_date,
	fe.first_ever_transaction_date,
	
	CASE
		WHEN fe.first_ever_transaction_date = DATE_TRUNC('Month',ft.date) THEN 'New'
		ELSE 'Returning'
	END AS customer_type
FROM gold.fact_transaction ft
JOIN cust_first_ever_txn fe
	ON ft.customer_id = fe.customer_id
)
, number_of_cust AS (
SELECT
	DATE_TRUNC('Month',visit_date)::DATE date_month,
	customer_type,
	COUNT(DISTINCT customer_id) AS number_of_customers
FROM customer_type
GROUP BY
	DATE_TRUNC('Month',visit_date)::DATE,
	customer_type
)

SELECT
	date_month,
	customer_type,
	number_of_customers,
	SUM(number_of_customers) OVER(PARTITION BY date_month) AS total_customer,
	((number_of_customers / SUM(number_of_customers) OVER(PARTITION BY date_month)) * 100)::NUMERIC(10,2) || '%' AS pct_rate
FROM number_of_cust

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Consecutive Rating Declines: Identify any mechanic who has had a "rating streak" of at least three consecutive jobs where the customer rating was lower than the rating of their previous job.
*/

WITH sorted_rating_per_mechanic AS (
SELECT
	mechanic_name_id,
	date,
	rating,
	COUNT(DISTINCT id)
FROM gold.fact_transaction
GROUP BY
	mechanic_name_id,
	date,
	rating
)
, marking_perf_status AS (
SELECT
	mechanic_name_id,
	date,
	rating,
	CASE
		WHEN
			LAG(rating,0) OVER(ORDER BY mechanic_name_id, date) < LAG(rating,1) OVER(ORDER BY mechanic_name_id, date)
			AND
			LAG(rating,1) OVER(ORDER BY mechanic_name_id, date) < LAG(rating,2) OVER(ORDER BY mechanic_name_id, date)
				THEN 'Consecutive_Low_Perf'
		ELSE ''
	END AS performance_status
FROM sorted_rating_per_mechanic
WHERE rating::INT != 0
)
, categorized_list_mechanic AS (
SELECT
	mechanic_name_id,
	date,
	rating,
	performance_status
FROM marking_perf_status
WHERE performance_status = 'Consecutive_Low_Perf'
)

SELECT
	t2.mechanic_name,
	COUNT(*) AS number_times_consecutive_low_performances
FROM categorized_list_mechanic t1
JOIN gold.dim_mechanicname t2
	ON t1.mechanic_name_id = t2.mechanic_name_id
GROUP BY t2.mechanic_name
ORDER  BY number_times_consecutive_low_performances DESC

/*
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*/

/*
Service Life-Cycle Predicton: For each service_type, calculate the average, minimum, and maximum "Time-to-Return" (the number of days until the customer comes back for any service). Use this to identify which service types have the shortest customer lifecycle.
*/
WITH date_compression AS (
SELECT
	servicetypeid,
	DATE_TRUNC('Day',date)::DATE AS date_day,
	COUNT(DISTINCT id) AS number_of_txn
FROM gold.fact_transaction
GROUP BY
	servicetypeid,
	DATE_TRUNC('Day',date)
)
, prev_days AS (
SELECT
	servicetypeid,
	date_day,
	COALESCE(
		LAG(date_day,1)
			OVER(
				PARTITION BY servicetypeid
				ORDER BY date_day
			) 
	,date_day) AS prev_date
FROM date_compression
)

SELECT
	t2.service_type,
	MIN(
		EXTRACT(DAY FROM AGE(t1.date_day,t1.prev_date))
	) AS minimum_number_of_days_before_customer_needs_service_again,
	MAX(
		EXTRACT(DAY FROM AGE(t1.date_day,t1.prev_date))
	) AS maximum_number_of_days_before_customer_needs_service_again,
	AVG(
		EXTRACT(DAY FROM AGE(t1.date_day,t1.prev_date))
	)::NUMERIC(10,2) AS average_number_of_days_before_customer_needs_service_again
FROM prev_days t1
JOIN gold.dim_servicetype t2
	ON t1.servicetypeid = t2.servicetypeid
GROUP BY
	t2.service_type
ORDER BY
	minimum_number_of_days_before_customer_needs_service_again,
	maximum_number_of_days_before_customer_needs_service_again,
	average_number_of_days_before_customer_needs_service_again