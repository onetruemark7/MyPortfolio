/*
Create Dim access_to_tutoring in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_access_to_tutoring AS (
	WITH access_to_tutoring_list AS (
		SELECT DISTINCT
			access_to_tutoring
		FROM silver.students
	)
	
	SELECT
		'ATT' || 10 + ROW_NUMBER() OVER(ORDER BY access_to_tutoring) AS access_to_tutoring_id,
		ROW_NUMBER() OVER(ORDER BY access_to_tutoring) AS access_to_tutoring_skey,
		access_to_tutoring
	FROM access_to_tutoring_list
);

SELECT * FROM gold.dim_access_to_tutoring;