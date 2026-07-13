/*
1. Program Performance: Calculate the average total_units per program_group. Only include program groups that have more than 5 projects listed.
*/

SELECT
	dpg.program_group,
	ROUND(AVG(total_units),2) AS average_total_units
FROM gold.fact_records fr
JOIN gold.dim_program_group dpg
	ON fr.program_group_id = dpg.program_group_id
GROUP BY dpg.program_group
HAVING AVG(total_units) > 5

--===================================================================================================================================================
--===================================================================================================================================================

/*
2. Affordability Ratios: For each project, calculate the percentage of units that are "Extremely Low Income" relative to the total_units.
*/

SELECT
	project_name,
	extremely_low_income_units,
	total_units,
	((extremely_low_income_units / NULLIF(total_units,0)) * 100)::NUMERIC(10,2) || '%' AS pct_ratio_to_total_units
FROM gold.fact_records
ORDER BY pct_ratio_to_total_units DESC

--===================================================================================================================================================
--===================================================================================================================================================

/*
3. Annual Project Starts: Count how many projects started each year. Sort the results chronologically.
*/

SELECT
	TO_CHAR(DATE_TRUNC('Year',project_start_date),'yyyy') AS year_date,
	COUNT(*) AS number_of_projects
FROM gold.fact_records
GROUP BY DATE_TRUNC('Year',project_start_date)
ORDER BY year_date

--===================================================================================================================================================
--===================================================================================================================================================

/*
4. Wage Status Impact: Compare the average number of all_counted_units between projects marked as "Prevailing Wage" versus those that are not.
*/

SELECT
	dpws.prevailing_wage_status,
	ROUND(AVG(fr.all_counted_units),2) AS average_all_counted_units
FROM gold.fact_records fr
JOIN gold.dim_prevailing_wage_status dpws
	ON fr.prevailing_wage_status_id = dpws.prevailing_wage_status_id
WHERE prevailing_wage_status = 'Prevailing Wage'
GROUP BY dpws.prevailing_wage_status

UNION

SELECT
	dpws.prevailing_wage_status,
	ROUND(AVG(fr.all_counted_units),2) AS average_all_counted_units
FROM gold.fact_records fr
JOIN gold.dim_prevailing_wage_status dpws
	ON fr.prevailing_wage_status_id = dpws.prevailing_wage_status_id
WHERE prevailing_wage_status != 'Prevailing Wage'
GROUP BY dpws.prevailing_wage_status

--===================================================================================================================================================
--===================================================================================================================================================

/*
5. Completion Efficiency: Calculate the average duration (in days) between project_start_date and project_completion_date.
*/

SELECT
	ROUND(AVG(project_completion_date - project_start_date),2) average_duration_in_days
FROM gold.fact_records
WHERE
	project_start_date IS NOT NULL
	OR project_completion_date IS NOT NULL

--===================================================================================================================================================
--===================================================================================================================================================

/*
7. Multi-Demographic Analysis: Find projects where the number of senior_units represents more than 50% of the total_units.
*/

SELECT 
    project_name, 
    senior_units, 
    total_units,
	ROUND((senior_units::numeric / NULLIF(total_units::numeric, 0)),2) AS more_than_50pct
FROM gold.fact_records
WHERE (senior_units::numeric / NULLIF(total_units::numeric, 0)) > 0.5
ORDER BY more_than_50pct;

--===================================================================================================================================================
--===================================================================================================================================================

/*
6. Concentrated Development: Identify which program_group has the highest total sum of low_income_units.
*/

SELECT
	dpg.program_group AS program_group_name,
	SUM(low_income_units) AS total_sum_of_low_income_units
FROM gold.fact_records fr
JOIN gold.dim_program_group dpg
	ON fr.program_group_id = dpg.program_group_id
GROUP BY dpg.program_group
ORDER BY total_sum_of_low_income_units DESC

--===================================================================================================================================================
--===================================================================================================================================================

/*
8. Tiered Classification: Use a CASE statement to categorize projects into "Small" (under 50 units), "Medium" (51-150 units), and "Large" (over 150 units), and count how many projects fall into each category.
*/

SELECT
	CASE
		WHEN total_units > 150 THEN 'Large'
		WHEN total_units >= 51 AND total_units <= 150 THEN 'Medium'
		ELSE 'Small'
	END AS project_category,
	COUNT(*) AS number_of_projects
FROM gold.fact_records
GROUP BY project_category
ORDER BY number_of_projects DESC;

--===================================================================================================================================================
--===================================================================================================================================================

/*
9. Yearly Unit Production: Calculate the total number of all_counted_units produced per year based on the project_completion_date.
*/

SELECT DISTINCT
	TO_CHAR(DATE_TRUNC('Year',project_completion_date),'yyyy') AS year_date,
	SUM(all_counted_units) AS total_counted_units
FROM gold.fact_records
GROUP BY TO_CHAR(DATE_TRUNC('Year',project_completion_date),'yyyy')
ORDER BY TO_CHAR(DATE_TRUNC('Year',project_completion_date),'yyyy')

--===================================================================================================================================================
--===================================================================================================================================================

/*
10. Incomplete High-Volume Projects: List all projects that started more than 3 years ago but still have a NULL project_completion_date, specifically for those with more than 100 total_units.
*/

SELECT
	project_name,
	project_start_date,
	project_completion_date
FROM gold.fact_records
WHERE
	project_start_date < CURRENT_DATE - INTERVAL '3 year'
	AND project_completion_date IS NULL
	AND total_units > 100









