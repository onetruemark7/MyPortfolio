CREATE OR REPLACE VIEW gold.dim_prevailing_wage_status AS (
	WITH distinct_pws AS (
	SELECT DISTINCT
		prevailing_wage_status
	FROM silver.housedev
	)
	
	SELECT
		('PWS' || 10 + ROW_NUMBER() OVER(ORDER BY prevailing_wage_status))::VARCHAR AS prevailing_wage_status_id,
		prevailing_wage_status
	FROM distinct_pws
);