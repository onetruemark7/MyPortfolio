/*
Problem 1 — Count Employees by Borough
How many employees work in each work_borough_location? Display the borough name and the total number of employees, sorted from the highest to the lowest count.
*/

SELECT
	work_borough_location,
	COUNT(*) AS number_of_employees 
FROM gold.dim_employee
GROUP BY work_borough_location
ORDER BY number_of_employees DESC

-- ======================================================================================================================================
-- ======================================================================================================================================

/*
Problem 2 — List All Unique Job Titles
Retrieve all distinct title_description values from the employee dimension. How many unique job titles exist in the organization?
*/
SELECT
	COUNT(*) AS number_of_unique_job_titles
FROM
	(SELECT DISTINCT
	title_description
	FROM gold.dim_employee)

-- ======================================================================================================================================
-- ======================================================================================================================================

/*
Problem 3 — Employee Count per Leave Status
Join fact_payroll with dim_leavestatus to find out how many employees fall under each leave status category (Active, Ceased, On Leave, etc.).
*/
SELECT
	dl.leave_status_as_of_june30 AS leave_status,
	COUNT(*) AS number_of_employees
FROM gold.dim_leavestatus dl
JOIN gold.fact_payroll fp
	ON  dl.leave_status_id = fp.leave_status_id
GROUP BY dl.leave_status_as_of_june30
	
-- ======================================================================================================================================
-- ======================================================================================================================================

/*
Problem 4 — Average Base Salary by Pay Basis
Join fact_payroll with dim_paybasis and calculate the average base_salary for each pay basis type (per Annum, per Day, per Hour, Prorated Annual). Round the result to 2 decimal places.
*/

SELECT
	pb.pay_basis,
	AVG(fp.base_salary)::DECIMAL(10,2) AS average_basae_salary
FROM gold.fact_payroll fp
JOIN gold.dim_paybasis pb
	ON fp.id_pay_basis = pb.id_pay_basis
GROUP BY pb.pay_basis

-- ======================================================================================================================================
-- ======================================================================================================================================

/*
Problem 5 — Top 10 Highest Paid Employees
Using fact_payroll and dim_employee, retrieve the top 10 employees with the highest regular_gross_paid. Display their employee_id, full name (first_name + last_name), title_description, and regular_gross_paid.
*/

SELECT
	de.employee_id,
	de.first_name || ' ' || de.last_name AS employee_name,
	de.title_description,
	TO_CHAR(fp.regular_gross_paid,'$999,999,999.00') AS regular_gross_paid
FROM gold.fact_payroll fp
JOIN gold.dim_employee de
	ON fp.employee_id = de.employee_id
ORDER BY fp.regular_gross_paid DESC
LIMIT 10



