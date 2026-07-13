-- TRUNCATE TABLE silver.payroll

CREATE TABLE silver.payroll (
	id TEXT PRIMARY KEY,
	first_name TEXT,
	last_name TEXT,
	mid_init TEXT,
	name_suffix TEXT,
	agency_start_date DATE,
	work_borough_location TEXT,
	title_description TEXT,
	leave_status_as_of_june30 TEXT,
	base_salary NUMERIC(10,2),
	pay_basis TEXT,
	regular_hours NUMERIC(10,2),
	regular_gross_paid NUMERIC(10,2),
	ot_hours NUMERIC(10,2),
	ot_hours_paid NUMERIC(10,2),
	total_other_pay NUMERIC(10,2),
	created_at TIMETZ
);