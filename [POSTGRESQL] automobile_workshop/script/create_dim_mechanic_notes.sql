-- create dim mechanic notes
CREATE OR REPLACE VIEW gold.dim_mechanicnotes AS (
	WITH dim_mechanicnotes AS (
	SELECT DISTINCT
		mechanic_notes
	FROM silver.automobile
	)
	
	SELECT
		'MN' || (10+ROW_NUMBER() OVER(ORDER BY mechanic_notes))::TEXT AS mechanic_notes_id,
		mechanic_notes
	FROM dim_mechanicnotes
);