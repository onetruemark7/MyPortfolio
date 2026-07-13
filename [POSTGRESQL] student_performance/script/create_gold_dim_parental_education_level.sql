/*
Create Dim parental_education_level in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_parental_education_level AS (
	WITH parent_edu_lvl_list AS (
		SELECT DISTINCT
			parental_education_level
		FROM silver.students
	)
	
	SELECT
		'PEL' || 10 + ROW_NUMBER() OVER(ORDER BY parental_education_level) AS parental_education_level_id,
		ROW_NUMBER() OVER(ORDER BY parental_education_level) AS parental_education_level_skey,
		parental_education_level
	FROM parent_edu_lvl_list
);

SELECT * FROM gold.dim_parental_education_level;