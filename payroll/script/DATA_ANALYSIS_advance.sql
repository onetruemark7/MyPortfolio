/*
Problem 1 — Payroll Contribution Ranking within Borough
For each employee, calculate their regular_gross_paid as a percentage contribution to their borough's total regular_gross_paid. Then rank employees within each borough from highest to lowest contributor. Display the borough, employee full name, their gross paid, the borough total, the percentage contribution, and their rank. Only show the top 3 employees per borough.
*/
WITH total_gross_paid_per_emp_and_borough AS (
SELECT
	de.employee_id,
	de.work_borough_location,
	SUM(fp.regular_gross_paid) AS subtotal_regular_gross_paid
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
GROUP BY
	de.employee_id,
	de.work_borough_location
)
, emp_borough_ranking AS (
SELECT
	employee_id,
	work_borough_location,
	subtotal_regular_gross_paid,
	SUM(subtotal_regular_gross_paid) OVER(
		PARTITION BY work_borough_location
		) AS total_regular_gross_paid_per_borough,
	ROUND(((subtotal_regular_gross_paid / SUM(subtotal_regular_gross_paid) OVER(PARTITION BY work_borough_location)) * 100),2) contribution_pct,
	ROW_NUMBER() OVER(PARTITION BY work_borough_location ORDER BY subtotal_regular_gross_paid DESC) AS borough_ranking
FROM total_gross_paid_per_emp_and_borough
)

SELECT
	t2.first_name || ' ' || t2.last_name AS employee_fullname,
	t1.work_borough_location,
	t1.subtotal_regular_gross_paid,
	t1.total_regular_gross_paid_per_borough,
	t1.contribution_pct || '%',
	t1.borough_ranking
FROM emp_borough_ranking t1
JOIN gold.dim_employee t2
	ON t1.employee_id = t2.employee_id
WHERE borough_ranking < 4
ORDER BY t1.contribution_pct DESC, t1.borough_ranking

--========================================================================================================================================
--========================================================================================================================================

/*
Problem 2 — Salary Band Classification with Cumulative Coverage
Classify every employee's base_salary into bands: 'Low' (below 20), 'Mid' (20–40), 'High' (above 40). Then, for each band, show the employee count and its percentage of the total workforce. Finally, add a cumulative percentage column that accumulates from Low → Mid → High, so you can see what portion of the workforce is covered up to each band.
*/
WITH ntile_rankers AS (
SELECT
	employee_id,
	base_salary,
	NTILE(5) OVER(ORDER BY base_salary DESC) AS ntile_ranking
FROM gold.fact_payroll
)
, workforce_count AS (
SELECT
	employee_id,
	base_salary,
	ntile_ranking,
	CASE
		WHEN ntile_ranking = 1 OR ntile_ranking = 2 THEN 'High'
		WHEN ntile_ranking = 3 OR ntile_ranking = 4 THEN 'Mid'
		ELSE 'Low'
	END AS bands,

	SUM(
		CASE
		WHEN ntile_ranking = 1 OR ntile_ranking = 2 THEN 1
		ELSE 0
	END
	) OVER() AS number_of_high_band_workforce,

	SUM(
		CASE
		WHEN ntile_ranking = 3 OR ntile_ranking = 4 THEN 1
		ELSE 0
	END
	) OVER() AS number_of_mid_band_workforce,

	SUM(
		CASE
		WHEN ntile_ranking = 5 THEN 1
		ELSE 0
	END
	) OVER() AS number_of_low_band_workforce
FROM ntile_rankers
)
SELECT
	employee_id,
	base_salary,
	bands,
	CASE
		WHEN bands = 'High' THEN number_of_high_band_workforce
		WHEN bands = 'Mid' THEN number_of_mid_band_workforce
		ELSE number_of_low_band_workforce
	END AS band_count,
	
	CASE
		WHEN bands = 'High'
			THEN ((number_of_high_band_workforce::float / 
				(number_of_high_band_workforce + number_of_mid_band_workforce + number_of_low_band_workforce)::float) * 100)
		WHEN bands = 'High'
			THEN ((number_of_mid_band_workforce::float / 
				(number_of_high_band_workforce + number_of_mid_band_workforce + number_of_low_band_workforce)::float) * 100)
		ELSE
			((number_of_low_band_workforce::float / 
			(number_of_high_band_workforce + number_of_mid_band_workforce + number_of_low_band_workforce)::float) * 100) 
	END || '%' AS pct_of_bands_workforce,
	(number_of_high_band_workforce + number_of_mid_band_workforce + number_of_low_band_workforce) AS grand_total_workforce,
	((base_salary::float /  (number_of_high_band_workforce + number_of_mid_band_workforce + number_of_low_band_workforce)::float)*100) || '%' AS cumulative_pct
FROM workforce_count
ORDER BY base_salary DESC

--========================================================================================================================================
--========================================================================================================================================

/*
Problem 3 — Overtime Dependency Index per Job Title
For each title_description, calculate an "Overtime Dependency Index" — defined as the ratio of total ot_hours_paid to total regular_gross_paid, expressed as a percentage. Only include job titles with at least 10 employees. Rank titles from most overtime-dependent to least, and flag any title where the index exceeds 5% as 'High Dependency', otherwise 'Normal'.
*/
WITH count_of_emp_per_jobtitle AS ( 
SELECT
	title_description,
	COUNT(*) AS number_of_emp_per_jop_position
FROM gold.dim_employee
GROUP BY title_description
HAVING COUNT(*) > 10
)
, agg_ot_and_regular AS (
SELECT
	epj.title_description,
	SUM(fp.ot_hours_paid) AS total_ot_hours_paid,
	SUM(fp.regular_gross_paid) AS regular_gross_paid
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
JOIN count_of_emp_per_jobtitle epj
	ON de.title_description = epj.title_description
GROUP BY epj.title_description
)
, ot_dependent AS (
SELECT
	title_description,
	total_ot_hours_paid,
	regular_gross_paid,
	ROUND((total_ot_hours_paid / (total_ot_hours_paid + regular_gross_paid)) * 100,2) AS pct_ot_hours,
	ROUND((regular_gross_paid / (total_ot_hours_paid + regular_gross_paid)) * 100,2) AS pct_regular_gross,
	ROW_NUMBER() OVER(
		ORDER BY
			((total_ot_hours_paid / (total_ot_hours_paid + regular_gross_paid)) * 100) DESC
	) AS ranking_dependent_ot
FROM agg_ot_and_regular
)

SELECT
	title_description,
	total_ot_hours_paid,
	regular_gross_paid,
	pct_ot_hours AS ot_hours_ratio,
	pct_regular_gross AS regular_gross_ratio,
	ranking_dependent_ot,
	CASE
		WHEN pct_ot_hours > 4.99 THEN 'High Dependency'
		ELSE 'Normal'
	END AS flag
FROM ot_dependent

--========================================================================================================================================
--========================================================================================================================================

/*
Problem 4 — Employee Payroll Anomaly Detection
Within each pay_basis group, identify employees whose regular_gross_paid deviates from the group mean by more than 2 standard deviations (i.e., statistical outliers). Display the employee full name, pay basis, their regular_gross_paid, the group mean, the group standard deviation, and how many standard deviations away they are. Label each as 'Above Average Outlier' or 'Below Average Outlier'.
*/
WITH mean_stddev AS (
SELECT
	AVG(regular_gross_paid) AS mean,
	STDDEV_SAMP(regular_gross_paid) AS stddev
FROM gold.fact_payroll
)
, mean_with_twice_stddev AS (
SELECT
	de.first_name || ' ' || de.last_name AS employee_name,
	fp.regular_gross_paid,
	dp.pay_basis,
	ROUND(mean_stddev.mean,2) AS mean,
	ROUND(mean_stddev.stddev,2) AS stddev
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
JOIN gold.dim_paybasis dp
	ON fp.id_pay_basis = dp.id_pay_basis
CROSS JOIN mean_stddev
WHERE fp.regular_gross_paid > mean_stddev.mean + (2 * mean_stddev.stddev)
)

SELECT
	employee_name,
	regular_gross_paid,
	pay_basis,
	mean,
	stddev AS standard_deviation_stddev,
	ROUND(AVG(regular_gross_paid) OVER(PARTITION BY pay_basis),2) AS group_mean,
	ROUND(STDDEV_SAMP(regular_gross_paid) OVER(PARTITION BY pay_basis),2) AS group_stddev,
	ROUND(((mean / stddev) * 100),2) || '%' pct_away_from_stddev_by_every_emp,
	CASE
		WHEN regular_gross_paid > stddev THEN 'Above Average Outlier'
		ELSE 'Below Average Outlier'
	END AS outlier_type
FROM mean_with_twice_stddev
	
--========================================================================================================================================
--========================================================================================================================================

/*
Problem 5 — Cumulative Headcount Growth by Agency Start Date
Using agency_start_date from dim_employee, calculate the cumulative number of employees hired over time, ordered by start date. For each distinct start date, show the number of new employees who joined on that date, the running cumulative total, and the month-over-month growth rate (as a percentage) of the cumulative headcount compared to the previous date entry.
*/
WITH cumulative_numbers AS (
SELECT
	agency_start_date,
	COUNT(*) OVER(
		ORDER BY agency_start_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_number_of_employees_hired
FROM gold.dim_employee
)
, running_cumulative AS (
SELECT
	agency_start_date,
	cumulative_number_of_employees_hired,
	SUM(cumulative_number_of_employees_hired) OVER(
		ORDER BY agency_start_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_cumulative_total_of_hired_individuals
FROM cumulative_numbers
)
, monthly_headcount AS(
SELECT
	agency_start_date,
	cumulative_number_of_employees_hired,
	running_cumulative_total_of_hired_individuals,
	SUM(running_cumulative_total_of_hired_individuals) OVER(
		PARTITION BY DATE_TRUNC('Month',agency_start_date)
		ORDER BY agency_start_date ) AS total_monthly_headcount
FROM running_cumulative
)
, mom_growth AS (
SELECT
	agency_start_date,
	cumulative_number_of_employees_hired,
	running_cumulative_total_of_hired_individuals,
	total_monthly_headcount,
	ROUND(
		(((total_monthly_headcount - LAG(total_monthly_headcount,1) OVER(ORDER BY agency_start_date)) /
			NULLIF(LAG(total_monthly_headcount,1) OVER(ORDER BY agency_start_date),0)) * 100)
	,2) AS MoM_growth_rate
FROM monthly_headcount
)

SELECT
	*
FROM mom_growth
ORDER BY agency_start_date