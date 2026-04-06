/*
Create Dim family_income_range in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_family_income_range AS (
	WITH family_income_range_list AS (
		SELECT DISTINCT
			family_income_range
		FROM silver.students
	)
	
	SELECT
		'FIR' || 10 + ROW_NUMBER() OVER(ORDER BY family_income_range) AS family_income_range_id,
		ROW_NUMBER() OVER(ORDER BY family_income_range) AS family_income_range_skey,
		family_income_range
	FROM family_income_range_list
);

SELECT * FROM gold.dim_family_income_range;