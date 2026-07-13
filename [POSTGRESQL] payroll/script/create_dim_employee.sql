-- DROP VIEW gold.dim_employee;
-- SELECT * FROM gold.dim_employee;

CREATE OR REPLACE VIEW gold.dim_employee AS(
SELECT
	id,
	'EMP' || ROW_NUMBER() OVER(ORDER BY agency_start_date DESC)::TEXT AS employee_id,
	first_name,
	last_name,
	mid_init,
	name_suffix,
	agency_start_date,
	work_borough_location,
	title_description
FROM silver.payroll
);