SELECT *
FROM bronze.housedev

-- check duplicates
SELECT
	project_id,
	COUNT(*)
FROM bronze.housedev
GROUP BY project_id
HAVING COUNT(*) > 1

-- check distinct values from program_group column
SELECT DISTINCT
	program_group
FROM bronze.housedev

-- check distinct values from extended_affordability_only column
SELECT DISTINCT
	extended_affordability_only
FROM bronze.housedev

-- check distinct values from prevailing_wage_status column
SELECT DISTINCT
	prevailing_wage_status
FROM bronze.housedev

-- check distinct values from planned_tax_benefit column
SELECT DISTINCT
	planned_tax_benefit
FROM bronze.housedev

SELECT
	extremely_low_income_units,
	very_low_income_units,
	low_income_units,
	moderate_income_units,
	middle_income_units,
	other_income_units
FROM bronze.housedev
WHERE very_low_income_units ~* ','