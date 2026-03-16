-- DROP TABLE bronze.payroll;

CREATE TABLE bronze.payroll (
	fiscal_year INT,
	payroll_number INT,
	agency_name TEXT,
	last_name TEXT,
	first_name TEXT,
	mid_init TEXT,
	agency_start_date DATE,
	work_location_borough TEXT,
	title_description TEXT,
	leave_status_as_of_june_30 TEXT,
	base_salary TEXT,
	pay_basis TEXT,
	regular_hours TEXT,
	regular_gross_paid TEXT,
	ot_hours TEXT,
	total_ot_paid TEXT,
	total_other_pay TEXT
);