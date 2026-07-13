/*
High-Value Locations: List all workshop locations that have generated a total revenue of more than 5,000, excluding any discounts.
*/
WITH revenues AS (
SELECT
	workshop_location_id,
	SUM(parts_cost) AS parts_cost_revenue,
	SUM(labour_cost) AS labour_cost_revenue,
	SUM(service_cost) AS service_cost_revenue
FROM gold.fact_transaction
GROUP BY workshop_location_id
HAVING
	SUM(parts_cost) > 5000 AND
	SUM(labour_cost) > 5000 AND
	SUM(service_cost) > 5000
)

SELECT
	workshop_location,
	TO_CHAR((parts_cost_revenue + labour_cost_revenue + service_cost_revenue),'$999,999,999.99') AS total_revenue_per_workshop_location
FROM revenues r
JOIN gold.dim_workshoplocation wsl
	ON r.workshop_location_id = wsl.workshop_location_id
ORDER BY total_revenue_per_workshop_location DESC




/*
Mechanic Efficiency: Identify which mechanics have an average wait_time_mins higher than the overall company average.
*/
WITH average_per_mechanic AS (
SELECT
	mechanic_name_id,
	ROUND(AVG(wait_time_mins),2) AS average_wait_time_mins
FROM gold.fact_transaction
GROUP BY mechanic_name_id
)

SELECT
	mechanic_name,
	average_wait_time_mins
FROM average_per_mechanic t1
JOIN gold.dim_mechanicname t2
	ON t1.mechanic_name_id = t2.mechanic_name_id
WHERE
	average_wait_time_mins > (
		SELECT
			ROUND(AVG(wait_time_mins),2) AS overall_average_wait_time_mins
		FROM gold.fact_transaction
	)
ORDER BY average_wait_time_mins DESC




/*
Revenue Contribution Percentage: For each service_type, calculate what percentage of the total global revenue it represents.
*/
WITH revenue_per_service AS (
SELECT
	servicetypeid,
	SUM(service_cost) AS total_revenue
FROM gold.fact_transaction
GROUP BY servicetypeid
)

SELECT
	t2.service_type,
	TO_CHAR(t1.total_revenue,'$999,999,999.00') AS total_revenue,
	TO_CHAR(SUM(t1.total_revenue) OVER(),'$999,999,999.00') AS global_revenue,
	ROUND((t1.total_revenue / SUM(t1.total_revenue) OVER()) * 100,2) || '%' AS pct_of_global_revenue
FROM revenue_per_service t1
JOIN gold.dim_servicetype t2
	ON t1.servicetypeid = t2.servicetypeid
ORDER BY pct_of_global_revenue DESC



/*
Repeat Customer Count: Find the number of customers who have visited the workshop more than once.
*/
SELECT
	customer_id,
	COUNT(*) AS number_of_visits
FROM gold.fact_transaction
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY number_of_visits DESC




/*
Monthly Growth Trend: Extract the month from the created_at column and calculate the total number of transactions per month to see if business is increasing.
*/
SELECT
	TO_CHAR(DATE_TRUNC('Month', date),'Month') AS month_date,
	COUNT(*) AS number_of_txn
FROM gold.fact_transaction
GROUP BY
	DATE_TRUNC('Month', date)
ORDER BY DATE_TRUNC('Month', date)



/*
Top-Rated Services: List the service_type names that have received an average rating of 4 or higher, but only for services that have been performed at least 5 times.
*/

SELECT
	ft.servicetypeid,
	st.service_type,
	COUNT(DISTINCT ft.id) AS number_of_performance,
	ROUND(AVG(ft.rating::INT),2) AS average_rating
FROM gold.fact_transaction ft
JOIN gold.dim_servicetype st
	ON ft.servicetypeid = st.servicetypeid
GROUP BY
	ft.servicetypeid,
	st.service_type
-- HAVING AVG(ft.rating::INT) > 4 -- wont display any records since all records are less than 4
ORDER BY number_of_performance DESC, average_rating DESC



/*
Labor vs. Parts Ratio: For each transaction, calculate the ratio of labour_cost to the total service_cost. Which service type has the highest labor-to-cost ratio?
*/
WITH total_cost AS (
SELECT
	id,
	servicetypeid,
	SUM(labour_cost) AS subtotal_labour_cost,
	SUM(service_cost) AS subtotal_service_cost
FROM gold.fact_transaction 
GROUP BY
	id,
	servicetypeid
)

SELECT
	id,
	servicetypeid,
	subtotal_labour_cost,
	subtotal_service_cost,
	(subtotal_labour_cost / subtotal_labour_cost) || ':' || (subtotal_service_cost / subtotal_labour_cost) AS labor_to_cost_ratio
FROM total_cost
ORDER BY id




/*
Underperforming Workshops: Identify workshops where the average customer rating is below 3.0. Include the location name and the count of poor ratings.
*/
SELECT
	t2.workshop_location,
	count_poor_ratings
FROM(
	SELECT
		workshop_location_id,
		COUNT(*) AS count_poor_ratings
	FROM gold.fact_transaction
	WHERE rating::INT < (
		SELECT
			AVG(rating::BIGINT)
		FROM gold.fact_transaction
	)
	GROUP BY 
		workshop_location_id
)m
JOIN gold.dim_workshoplocation t2
	ON m.workshop_location_id = t2.workshop_location_id
ORDER BY count_poor_ratings DESC



/*
Most Dispatched Mechanics: Find the top 3 mechanics who have handled the most "Emergency" or "Repair" service types (filter by service_type name).
*/
SELECT
	t2.mechanic_name,
	SUM(t1.services_count) AS total_services_jobs
FROM
	(SELECT
		ft.mechanic_name_id,
		sp.service_priority,
		s.service_type,
		COUNT(DISTINCT id) AS services_count
	FROM gold.fact_transaction ft
	JOIN gold.dim_servicepriority sp
		ON ft.service_priority_id = sp.service_priority_id
	JOIN gold.dim_servicetype s
		ON ft.servicetypeid = s.servicetypeid
	WHERE
		sp.service_priority = 'Emergency' OR
		s.service_type = 'Engine Repair'
	GROUP BY
		ft.mechanic_name_id,
		sp.service_priority,
		s.service_type
	) AS t1
JOIN gold.dim_mechanicname AS t2
	ON t1.mechanic_name_id = t2.mechanic_name_id
GROUP BY 
	t2.mechanic_name
ORDER BY total_services_jobs DESC



/*
Peak Hour Analysis: Using the created_at timestamp, determine which hour of the day receives the most service check-ins across all locations.
*/
SELECT
	TO_CHAR(DATE_TRUNC('Day',date),'Month dd, YYYY') AS date,
	COUNT(*) AS transaction_count
FROM gold.fact_transaction
GROUP BY DATE_TRUNC('Day',date)
ORDER BY transaction_count DESC