/* truncate table if exists */
-- TRUNCATE TABLE IF EXISTS bronze.housedev;

/* drop table if exists */
-- DROP TABLE IF EXISTS bronze.housedev;

CREATE TABLE bronze.housedev (
	project_id BIGINT PRIMARY KEY,
	project_name TEXT,
	program_group TEXT,
	project_start_date DATE,
	project_completion_date DATE,
	extended_affordability_only TEXT,
	prevailing_wage_status TEXT,
	planned_tax_benefit TEXT,
	extremely_low_income_units TEXT,
	very_low_income_units TEXT,
	low_income_units TEXT,
	moderate_income_units TEXT,
	middle_income_units TEXT,
	other_income_units TEXT,
	counted_rental_units TEXT,
	counted_homeownership_units TEXT,
	all_counted_units TEXT,
	total_units TEXT,
	senior_units TEXT
);