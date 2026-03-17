CREATE OR REPLACE VIEW gold.fact_records AS (
	SELECT
		main.project_id,
		main.project_name,
		dpg.program_group_id,
		main.project_start_date,
		main.project_completion_date,
		deao.extended_affordability_only_id,
		dpws.prevailing_wage_status_id,
		dptb.planned_tax_benefit_id,
		main.extremely_low_income_units,
		main.very_low_income_units,
		main.low_income_units,
		main.moderate_income_units,
		main.middle_income_units,
		main.other_income_units,
		main.counted_rental_units,
		main.counted_homeownership_units,
		main.all_counted_units,
		main.total_units,
		main.senior_units
	FROM silver.housedev main
	JOIN gold.dim_program_group dpg
		ON main.program_group = dpg.program_group
	JOIN gold.dim_planned_tax_benefit dptb
		ON main.planned_tax_benefit = dptb.planned_tax_benefit
	JOIN gold.dim_extended_affordability_only deao
		ON main.extended_affordability_only = deao.extended_affordability_only
	JOIN gold.dim_prevailing_wage_status dpws
		ON main.prevailing_wage_status = dpws.prevailing_wage_status
	ORDER BY main.project_id
);