/*
Problem 1 — Overtime Pay Rate Analysis
For employees who have worked overtime (ot_hours > 0), calculate the effective overtime pay rate per hour (ot_hours_paid / ot_hours) for each employee. Then find the average, minimum, and maximum overtime rate across all those employees. Round all results to 2 decimal places.
*/
WITH overtime_rate AS (
SELECT
	employee_id,
	ot_hours,
	ot_hours_paid,
	ot_hours_paid / ot_hours AS overtime_rate_per_hour
FROM gold.fact_payroll
WHERE ot_hours > 0
)

SELECT
	ROUND(MIN(overtime_rate_per_hour),2) AS overall_minimum_overtime_rate,
	ROUND(MAX(overtime_rate_per_hour),2) AS overall_maximum_overtime_rate,
	ROUND(AVG(overtime_rate_per_hour),2) AS overall_average_overtime_rate
FROM overtime_rate
limit 3000

--=============================================================================================================================
--=============================================================================================================================

/*
Problem 2 — Borough Payroll Summary
Join fact_payroll with dim_employee to produce a payroll summary per borough. For each work_borough_location, show the total number of employees, total regular_gross_paid, total ot_hours_paid, and total total_other_pay. Sort by total regular_gross_paid descending.
*/
SELECT
	de.work_borough_location,
	TO_CHAR(COUNT(DISTINCT de.employee_id),'$999,999,999,999.000') AS total_number_of_employee,
	TO_CHAR(SUM(fp.regular_gross_paid),'$999,999,999,999.000') AS total_regular_gross_paid,
	TO_CHAR(SUM(fp.ot_hours_paid),'$999,999,999,999.000') AS total_ot_hours_paid,
	TO_CHAR(SUM(fp.total_other_pay),'$999,999,999,999.000') AS total_total_other_pay
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
GROUP BY
	work_borough_location
ORDER BY total_regular_gross_paid DESC
LIMIT 1000

--=============================================================================================================================
--=============================================================================================================================

/*
Problem 3 — Pay Basis Distribution per Job Title
Find the top 5 most common job titles (title_description) and for each of those titles, show the breakdown of how many employees are paid under each pay_basis type. Your result should show the job title, pay basis, and employee count.
*/

SELECT
	de.title_description,
	pb.pay_basis,
	COUNT(DISTINCT fp.employee_id) AS total_count_of_employees
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
JOIN gold.dim_paybasis pb
	ON fp.id_pay_basis = pb.id_pay_basis
GROUP BY
	de.title_description,
	pb.pay_basis
limit 1000

--=============================================================================================================================
--=============================================================================================================================

/*
Problem 4 — Active vs Non-Active Payroll Comparison
Using all three dimension tables and fact_payroll, compare the average regular_gross_paid between employees who are Active vs all other leave statuses combined. Label the groups as 'Active' and 'Non-Active' in your result.
*/

SELECT
	TO_CHAR(ROUND(AVG(regular_gross_paid) FILTER(WHERE leave_status_as_of_june30 = 'Active' ),2), '$999,999,999,999.00') AS active_regular_gross_paid,
	TO_CHAR(ROUND(AVG(regular_gross_paid) FILTER(WHERE leave_status_as_of_june30 != 'Active' ),2), '$999,999,999,999.00')  AS non_active_regular_gross_paid
FROM gold.fact_payroll fp
JOIN gold.dim_leavestatus dl
	ON fp.leave_status_id = dl.leave_status_id
JOIN gold.dim_paybasis dp
	ON dp.id_pay_basis = dp.id_pay_basis
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
LIMIT 1000

--=============================================================================================================================
--=============================================================================================================================

/*
Problem 5 — Employees with No Overtime but High Base Salary
Identify employees whose ot_hours = 0 and ot_hours_paid = 0 (no overtime at all), but whose base_salary is above the overall average base salary of all employees. Display their employee_id, full name, title_description, work_borough_location, and base_salary. Sort by base_salary descending.
*/

SELECT
	de.employee_id,
	de.first_name || ' ' || de.last_name AS employee_full_name,
	de.title_description,
	de.work_borough_location,
	fp.base_salary
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
WHERE
	fp.ot_hours = 0
	AND fp.ot_hours_paid = 0
	AND fp.base_salary > (SELECT AVG(base_salary) FROM gold.fact_payroll)
ORDER BY fp.base_salary DESC
LIMIT 100
