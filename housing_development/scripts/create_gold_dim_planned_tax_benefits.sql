CREATE OR REPLACE VIEW gold.dim_planned_tax_benefit AS (
	WITH distinct_ptb AS (
	SELECT DISTINCT
		planned_tax_benefit
	FROM silver.housedev
	)
	
	SELECT
		'PTB' || 10 + ROW_NUMBER() OVER(ORDER BY planned_tax_benefit) AS planned_tax_benefit_id,
		planned_tax_benefit
	FROM distinct_ptb
);