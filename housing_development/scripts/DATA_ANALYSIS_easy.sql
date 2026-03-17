/*
1. Project Overview: Retrieve a list of all project names and their corresponding program groups from the database
*/

SELECT DISTINCT
	fr.project_name,
	fpg.program_group
FROM gold.fact_records fr
JOIN gold.dim_program_group fpg
	ON fr.program_group_id = fpg.program_group_id

--================================================================================================================================
--================================================================================================================================

/*
2. Date-Based Filtering: List all housing projects that started after January 1, 2020.
*/

SELECT
	project_name,
	project_start_date
FROM gold.fact_records
WHERE project_start_date > '2020-01-01'
ORDER BY project_start_date

--================================================================================================================================
--================================================================================================================================

/*
3. Specific Program Search: Find all projects that belong specifically to the "Multifamily Finance Program".
*/

SELECT
	project_name,
	dpg.program_group
FROM gold.fact_records ft
JOIN gold.dim_program_group dpg
	ON ft.program_group_id = dpg.program_group_id
WHERE dpg.program_group = 'Multifamily Finance Program';

--================================================================================================================================
--================================================================================================================================

/*
4. Incomplete Projects: Identify projects that have a project_start_date but do not yet have a project_completion_date (NULL values).
*/

SELECT
	project_name,
	project_start_date,
	project_completion_date
FROM gold.fact_records ft
WHERE
	project_start_date IS NOT NULL
	AND project_completion_date IS NULL
	
--================================================================================================================================
--================================================================================================================================

/*
5. Sorting by Scale: Retrieve all projects and sort them by their total_units in descending order so the largest developments appear first.
*/

SELECT
	project_name,
	total_units
FROM gold.fact_records ft
ORDER BY total_units DESC

--================================================================================================================================
--================================================================================================================================

/*
6. Senior Housing Focus: List the names of projects that have at least one unit dedicated to seniors.
*/

SELECT
	project_name,
	senior_units
FROM gold.fact_records ft
WHERE senior_units > 1

--================================================================================================================================
--================================================================================================================================

/*
7. Unit Type Comparison: Select project names along with their extremely_low_income_units and very_low_income_units to compare the distribution of low-income housing.
*/

SELECT
	project_name,
	extremely_low_income_units,
	very_low_income_units
FROM gold.fact_records;

--================================================================================================================================
--================================================================================================================================

/*
8. Status Check: Find all projects where the prevailing_wage_status is marked as "Prevailing Wage".
*/

SELECT
	fr.project_name,
	dpws.prevailing_wage_status
FROM gold.fact_records fr
JOIN gold.dim_prevailing_wage_status dpws
	ON fr.prevailing_wage_status_id = dpws.prevailing_wage_status_id
WHERE dpws.prevailing_wage_status = 'Prevailing Wage'

--================================================================================================================================
--================================================================================================================================

/*
9. Basic Counting: Calculate the total number of projects currently stored in the housedev table.
*/

SELECT
	COUNT(*) AS total_number
FROM gold.fact_records

--================================================================================================================================
--================================================================================================================================

/*
10. High-Impact Projects: List projects that have more than 100 total units and were started between 2015 and 2018.
*/

SELECT
	project_name,
	project_start_date,
	CURRENT_DATE - project_start_date AS days_since_started
FROM gold.fact_records
WHERE
	project_start_date >= '2015-01-01'
	AND project_start_date <= '2018-12-31'
ORDER BY days_since_started ASC