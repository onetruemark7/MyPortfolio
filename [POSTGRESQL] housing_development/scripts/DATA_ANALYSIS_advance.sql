/*
1. Market Share Analysis: For each program_group, identify the project that contributed the highest percentage of units to that specific program’s total. Use a Window Function to calculate the contribution of each project relative to its group total.
*/

WITH totalunits_per_program AS (
SELECT
	program_group_id,
	SUM(total_units) AS total_units_per_program
FROM gold.fact_records
GROUP BY program_group_id
)

SELECT
	tb2.program_group,
	tb1.total_units_per_program,
	ROUND((tb1.total_units_per_program::NUMERIC / NULLIF(SUM(tb1.total_units_per_program::NUMERIC) OVER(),0)) * 100,2) || '%' AS pct_of_units
FROM totalunits_per_program tb1
JOIN gold.dim_program_group tb2
	ON tb1.program_group_id = tb2.program_group_id
ORDER BY pct_of_units DESC;


--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
2. Year-over-Year Growth: Calculate the year-over-year percentage growth in all_counted_units (based on project_completion_date). You will need to aggregate units by year and use the LAG() function to compare with the previous year.
*/
WITH extracted_counted_units_by_year AS (
SELECT
	EXTRACT(YEAR FROM project_completion_date) AS year_date,
	SUM(all_counted_units) AS total_counted_units
FROM gold.fact_records
GROUP BY EXTRACT(YEAR FROM project_completion_date)
)

SELECT
	year_date,
	total_counted_units,
	COALESCE(
		LAG(total_counted_units,1) OVER(ORDER BY year_date)
	,0) AS previous_total_counted_units,
	ROUND((((total_counted_units::NUMERIC -  NULLIF(COALESCE(LAG(total_counted_units,1) OVER(ORDER BY year_date),0),0)) /
	NULLIF(COALESCE(LAG(total_counted_units,1) OVER(ORDER BY year_date),0),0)))*100,2) || '%' AS YoY_growth_pct
FROM extracted_counted_units_by_year;

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
3. Moving Averages: Create a report that shows each project's start date and a 3-project "rolling average" of total_units. This helps smooth out data to see trends in project sizing over time.
*/
WITH total_units_per_month AS (
SELECT
	DATE_TRUNC('Month',project_start_date)::DATE AS month_date,
	SUM(total_units) AS total_units
FROM gold.fact_records
GROUP BY DATE_TRUNC('Month',project_start_date::DATE)
ORDER BY DATE_TRUNC('Month',project_start_date::DATE)
)

SELECT
	month_date,
	total_units,
	ROUND(
		AVG(total_units::NUMERIC) OVER(
			ORDER BY month_date
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		)
	,2) AS threemonth_rolling_average
FROM total_units_per_month

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
4. Complex Data Imputation Logic: Generate a view that selects all projects, but for any project where all_counted_units is 0 or NULL, substitute it with the average all_counted_units of its specific program_group.
*/

WITH average_counted_units_per_group AS (
SELECT
	project_name,
	program_group_id,
	AVG(all_counted_units::NUMERIC) AS average_counted_units
FROM gold.fact_records
GROUP BY
	project_name,
	program_group_id
)

SELECT
	fr.project_name,
	dpg.program_group,
	CASE
		WHEN fr.all_counted_units = 0 OR fr.all_counted_units IS NULL THEN acupg.average_counted_units
		ELSE fr.all_counted_units
	END AS all_counted_units
FROM gold.fact_records fr
JOIN average_counted_units_per_group acupg
	ON fr.project_name = acupg.project_name
JOIN gold.dim_program_group dpg
	ON fr.program_group_id = dpg.program_group_id
ORDER BY all_counted_units DESC;

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
5. Multi-Tiered Ranking: Rank all projects within their respective program_group based on the number of low_income_units. If two projects have the same number of units, they should share a rank, and the next rank should be skipped (Dense vs. Non-Dense ranking logic).
*/

SELECT
	program_group_id,
	project_name,
	low_income_units,
	DENSE_RANK() OVER(
		PARTITION BY program_group_id 
		ORDER BY low_income_units
	) AS dense_ranking,
	
	RANK() OVER(
		PARTITION BY program_group_id 
		ORDER BY low_income_units
	) AS ranking
FROM gold.fact_records

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
6. Project Milestone Velocity: Using a Common Table Expression (CTE), calculate the gap in days between each project's project_start_date and the previous project's project_start_date within the same program_group. Use the LAG() window function to identify if certain programs are accelerating their project intake over time.
*/
WITH previous_project_date AS (
SELECT
	program_group_id,
	project_name,
	project_start_date,
	COALESCE(
		LAG(project_start_date,1) OVER(
			PARTITION BY program_group_id
			ORDER BY project_start_date)
	,project_start_date) AS prev_project_start_date
FROM gold.fact_records
)
, daygaps_between_projects AS (
SELECT
	program_group_id,
	project_name,
	project_start_date,
	prev_project_start_date,
	COALESCE(project_start_date::DATE - prev_project_start_date::DATE,0) AS days_since_last_project
FROM previous_project_date
)

SELECT
	program_group_id,
	project_name,
	project_start_date,
	prev_project_start_date,
	days_since_last_project,
	ROUND(
		AVG(COALESCE(days_since_last_project,0))
			OVER(
				PARTITION BY program_group_id
			)
	,2)AS avg_days_project_intake_over_time
FROM daygaps_between_projects

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
7. Affordability Quartile Benchmarking: Use the NTILE(4) function to divide projects into four quartiles based on their extremely_low_income_units. Then, write a query that shows the average total_units for each quartile to see if higher affordability targets correlate with smaller or larger overall project sizes.
*/

WITH ntile_ranking AS (
SELECT
	project_name,
	extremely_low_income_units,
	total_units,
	NTILE(4) OVER(ORDER BY extremely_low_income_units) AS quartile_rankings
FROM gold.fact_records
)

SELECT
	quartile_rankings,
	ROUND(
		AVG(total_units)
	,2) AS average_total_units_in_each_quartile
FROM ntile_ranking
GROUP BY quartile_rankings
ORDER BY quartile_rankings

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
8. Outlier Detection (Z-Score): Identify "outlier" projects where the all_counted_units is more than two standard deviations away from the mean for their specific program_group. This will require calculating the average and standard deviation using window functions (AVG(...) OVER(...) and STDDEV(...) OVER(...)).
*/
WITH avg_stddev_calc AS (
SELECT
	all_counted_units,
	program_group_id,
	AVG(all_counted_units::NUMERIC) OVER(PARTITION BY program_group_id) AS mean_counted_units,
	STDDEV_SAMP(all_counted_units::NUMERIC) OVER(PARTITION BY program_group_id) AS std_dev_counted_units
FROM gold.fact_records
)
, zscore_categ AS (
SELECT
	all_counted_units,
	program_group_id,
	mean_counted_units,
	std_dev_counted_units,
	all_counted_units - mean_counted_units AS distance_from_mean,
	((all_counted_units - mean_counted_units) / COALESCE(NULLIF(std_dev_counted_units,0),0)) AS z_score,
	CASE
		WHEN ((all_counted_units - mean_counted_units) / COALESCE(NULLIF(std_dev_counted_units,0),0)) > mean_counted_units THEN 'Positive'
		WHEN ((all_counted_units - mean_counted_units) / COALESCE(NULLIF(std_dev_counted_units,0),0)) < mean_counted_units THEN 'Negative'
		ELSE 'Mean-Equal'
	END AS score
FROM avg_stddev_calc
)

SELECT
	dpg.program_group,
	zc.all_counted_units,
	ROUND(zc.mean_counted_units,2) AS mean_counted_units,
	ROUND(zc.std_dev_counted_units,2) AS std_dev_counted_units,
	ROUND(zc.distance_from_mean,2) AS distance_from_mean,
	ROUND(zc.z_score,2) AS z_score,
	zc.score
FROM zscore_categ zc
JOIN gold.dim_program_group dpg
	ON zc.program_group_id = dpg.program_group_id
WHERE zc.z_score >= zc.mean_counted_units + (2 * zc.std_dev_counted_units)

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
9. Cumulative Unit Targets: Create a running total (cumulative sum) of low_income_units produced over time, ordered by project_completion_date. The report should show the project_name, completion_date, and the cumulative_total at that specific point in time for the entire history of the database.
*/

SELECT
	project_name,
	project_completion_date,
	low_income_units,
	SUM(low_income_units) OVER(
		ORDER BY project_completion_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS cumulative_total_low_income_units
FROM gold.fact_records

--************************************************************************************************************************************************************************************************************************
--************************************************************************************************************************************************************************************************************************

/*
10. Dynamic Efficiency Ranking: For each year, rank the top 3 projects that achieved the fastest completion time (the shortest interval between start and completion). Your output should show only the top 3 per year, handling ties using DENSE_RANK() and filtering the results using a subquery or CTE.
*/

SELECT
	*
FROM
	(SELECT
		EXTRACT(YEAR FROM project_completion_date) AS year_date,
		project_name,
		project_start_date,
		project_completion_date,
		project_completion_date - project_start_date AS duration_of_entire_project_in_days,
		DENSE_RANK()
			OVER(
				PARTITION BY EXTRACT(YEAR FROM project_completion_date)
				ORDER BY (project_completion_date - project_start_date)
			) AS ranking
	FROM gold.fact_records
	WHERE project_completion_date - project_start_date > 0)
WHERE ranking < 4