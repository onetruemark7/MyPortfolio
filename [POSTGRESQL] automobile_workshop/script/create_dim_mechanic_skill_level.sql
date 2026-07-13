-- create dim mechanic skill level
CREATE OR REPLACE VIEW gold.dim_mechanicskilllevel AS (
	WITH dim_mechanicskilllevel AS (
	SELECT DISTINCT
		mechanic_skill_level
	FROM silver.automobile
	)
	
	SELECT
		'MSL' || (10+ROW_NUMBER() OVER(ORDER BY mechanic_skill_level))::TEXT AS mechanic_skill_level_id,
		mechanic_skill_level
	FROM dim_mechanicskilllevel
);