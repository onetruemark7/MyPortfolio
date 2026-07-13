SELECT
	project_id,
	project_name,
	program_group,
	project_start_date,
	COALESCE(project_completion_date, project_start_date + INTERVAL '1 year')::DATE AS project_completion_date,
	extended_affordability_only,
	prevailing_wage_status,
	TRIM(
		COALESCE(planned_tax_benefit,'Other')
	) AS planned_tax_benefit,
	extremely_low_income_units::NUMERIC AS extremely_low_income_units,
	REPLACE(very_low_income_units,',','')::NUMERIC AS very_low_income_units,
	REPLACE(low_income_units,',','')::NUMERIC AS low_income_units,
	moderate_income_units::NUMERIC,
	REPLACE(middle_income_units,',','')::NUMERIC AS middle_income_units,
	other_income_units::NUMERIC,
	REPLACE(counted_rental_units,',','')::NUMERIC AS counted_rental_units,
	REPLACE(counted_homeownership_units,',','')::NUMERIC AS counted_homeownership_units,
	REPLACE(all_counted_units,',','')::NUMERIC AS all_counted_units,
	REPLACE(total_units,',','')::NUMERIC AS total_units,
	REPLACE(senior_units,',','')::NUMERIC AS senior_units
FROM bronze.housedev

