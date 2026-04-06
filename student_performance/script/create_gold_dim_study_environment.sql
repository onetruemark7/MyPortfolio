/*
Create Dim study_environment in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_study_environment AS (
	WITH study_environment_list AS (
		SELECT DISTINCT
			study_environment
		FROM silver.students
	)
	
	SELECT
		'SE' || 10 + ROW_NUMBER() OVER(ORDER BY study_environment) AS study_environment_id,
		ROW_NUMBER() OVER(ORDER BY study_environment) AS study_environment_skey,
		study_environment
	FROM study_environment_list
);

SELECT * FROM gold.dim_study_environment;