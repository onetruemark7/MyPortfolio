/*
Create Dim Major in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_major AS (
	WITH major_list AS (
		SELECT DISTINCT
			major
		FROM silver.students
	)
	
	SELECT
		'M' || 10 + ROW_NUMBER() OVER(ORDER BY major) AS major_id,
		major
	FROM major_list
); 

SELECT * FROM gold.dim_major;