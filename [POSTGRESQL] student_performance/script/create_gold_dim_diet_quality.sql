/*
Create Dim diet_quality in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_diet_quality AS (
	WITH dietquality_list AS (
		SELECT DISTINCT
			diet_quality
		FROM silver.students
	)
	
	SELECT
		'DQ' || 10 + ROW_NUMBER() OVER(ORDER BY diet_quality) AS diet_quality_id,
		ROW_NUMBER() OVER(ORDER BY diet_quality) AS diet_quality_skey,
		diet_quality
	FROM dietquality_list
);

SELECT * FROM gold.dim_diet_quality;