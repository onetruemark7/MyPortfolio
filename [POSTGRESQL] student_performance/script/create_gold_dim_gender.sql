/*
Create Dim Gender in Gold Schema for table and data normalization purposes.
*/

CREATE OR REPLACE VIEW gold.dim_gender AS (
	WITH gender_list AS (
		SELECT DISTINCT
			gender
		FROM silver.students
	) 
	
	SELECT
		'G' || 10 + ROW_NUMBER() OVER(ORDER BY gender) AS gender_id,
		gender
	FROM gender_list
);

SELECT * FROM gold.dim_gender;