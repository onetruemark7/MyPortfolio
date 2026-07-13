-- TRUNCATE TABLE IF EXISTS silver.housedev;
-- DROP TABLE IF EXISTS silver.housedev;

CREATE TABLE silver.housedev(
	project_id BIGINT,
	project_name TEXT,
	program_group TEXT,
	project_start_date DATE,
	project_completion_date DATE,
	extended_affordability_only TEXT,
	prevailing_wage_status TEXT,
	planned_tax_benefit TEXT,
	extremely_low_income_units NUMERIC,
	very_low_income_units NUMERIC,
	low_income_units NUMERIC,
	moderate_income_units NUMERIC,
	middle_income_units NUMERIC,
	other_income_units NUMERIC,
	counted_rental_units NUMERIC,
	counted_homeownership_units NUMERIC,
	all_counted_units NUMERIC,
	total_units NUMERIC,
	senior_units NUMERIC
);