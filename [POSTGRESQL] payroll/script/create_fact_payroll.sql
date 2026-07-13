-- SELECT * FROM gold.fact_payroll;

CREATE OR REPLACE VIEW gold.fact_payroll AS (
SELECT
	main.id,
	de.employee_id,
	dl.leave_status_id,
	main.base_salary,
	dp.id_pay_basis,
	main.regular_hours,
	main.regular_gross_paid,
	main.ot_hours,
	main.ot_hours_paid,
	main.total_other_pay
FROM silver.payroll main
JOIN gold.dim_employee de
	ON main.id = de.id
JOIN gold.dim_leavestatus dl
	ON main.leave_status_as_of_june30 = dl.leave_status_as_of_june30
JOIN gold.dim_paybasis dp
	ON main.pay_basis = dp.pay_basis
);