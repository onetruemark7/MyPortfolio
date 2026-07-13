/*
Create Dim extracurricular_participation in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_extracurricular_participation AS (
	WITH extracurri_parti_list AS (
		SELECT DISTINCT
			extracurricular_participation
		FROM silver.students
	)
	
	SELECT
		'EP' || 10 + ROW_NUMBER() OVER(ORDER BY extracurricular_participation) AS extracurricular_participation_id,
		ROW_NUMBER() OVER(ORDER BY extracurricular_participation) AS extracurricular_participation_skey,
		extracurricular_participation
	FROM extracurri_parti_list
);

SELECT * FROM gold.dim_extracurricular_participation;