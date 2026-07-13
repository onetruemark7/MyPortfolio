-- create dim complaint
CREATE OR REPLACE VIEW gold.dim_complaint AS (
	WITH dimcompliant AS (
	SELECT DISTINCT
		complaint
	FROM silver.automobile
	)
	
	SELECT
		'C' || (10+ROW_NUMBER() OVER(ORDER BY complaint))::TEXT AS complaintid,
		complaint
	FROM dimcompliant
);