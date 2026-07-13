/*
Create Dim internet_quality in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_internet_quality AS (
	WITH net_quality_list AS (
		SELECT DISTINCT
			internet_quality
		FROM silver.students
	)
	
	SELECT
		'IQ' || 10 + ROW_NUMBER() OVER(ORDER BY internet_quality) AS internet_quality_id,
		ROW_NUMBER() OVER(ORDER BY internet_quality) AS internet_quality_skey,
		internet_quality
	FROM net_quality_list
);

SELECT * FROM gold.dim_internet_quality;