--1. Total Revenue Check: Calculate the total revenue generated from all services by summing the service_cost in the fact_transaction table.
SELECT
	TO_CHAR(SUM(service_cost),'$999,999,999.00') AS Total_Revenue
FROM gold.fact_transaction 



--2. Average Repair Duration: Find the average wait_time_mins for all customers to understand typical service speed.
SELECT
	ROUND(AVG(wait_time_mins),2) AS Average_wait_time_mins_for_all_customers
FROM gold.fact_transaction 



--3. Customer Volume: Count the total number of unique customer_id entries to determine the size of the customer base.
SELECT
	COUNT(DISTINCT customer_id) AS total_customers
FROM gold.fact_transaction 



--4. Highest Service Transaction: Identify the maximum service_cost ever recorded for a single transaction.
SELECT
	MAX(service_cost) AS maximum_service_cost
FROM gold.fact_transaction 



--5. Labor Cost Overview: Calculate the total amount spent on labour_cost across the entire dataset.
SELECT
	TO_CHAR(SUM(labour_cost),'$999,999,999.00') AS total_labour_cost
FROM gold.fact_transaction 



--6. Mechanic Workload: Count how many transactions are associated with each mechanic_name_id to see which mechanic has handled the most jobs.
WITH client_count AS (
SELECT
	mechanic_name_id,
	COUNT(DISTINCT id) AS total_number_of_jobs
FROM gold.fact_transaction
GROUP BY
	mechanic_name_id
)

SELECT
	mn.mechanic_name,
	total_number_of_jobs
FROM client_count cc
JOIN gold.dim_mechanicname mn
	ON cc.mechanic_name_id = mn.mechanic_name_id
ORDER BY total_number_of_jobs DESC



--7. Service Type Popularity: Group the data by servicetypeid and count the transactions to find the most common type of service performed.
WITH services AS (
SELECT
	servicetypeid,
	COUNT(DISTINCT id) AS total_service_count
FROM gold.fact_transaction
GROUP BY servicetypeid
)

SELECT
	s2.service_type,
	s1.total_service_count
FROM services s1
JOIN gold.dim_servicetype s2
	ON s1.servicetypeid = s2.servicetypeid
ORDER BY total_service_count DESC



--8. Regional Performance: Find the total service_cost grouped by workshop_location_id to see which location is generating the most revenue.
WITH revenue_per_id AS (
SELECT
	workshop_location_id,
	SUM(DISTINCT service_cost) AS total_revenue_per_location
FROM gold.fact_transaction
GROUP BY workshop_location_id
)

SELECT
	workshop_location,
	TO_CHAR(total_revenue_per_location,'$999,999,999.00') AS total_revenue_per_location
FROM revenue_per_id t1
JOIN gold.dim_workshoplocation t2
	ON t1.workshop_location_id = t2.workshop_location_id
ORDER BY total_revenue_per_location DESC



--9. Customer Satisfaction Mean: Calculate the average rating provided by customers across all service records.
SELECT
	ROUND(AVG(rating::INT),2) average_overall_rating
FROM gold.fact_transaction



--10. Discount Impact: Sum the total discount_given to understand how much revenue is being reduced by promotional offers.
SELECT
	TO_CHAR(SUM(discount_given),'$999,999,999.99') AS total_discount_given
FROM gold.fact_transaction
