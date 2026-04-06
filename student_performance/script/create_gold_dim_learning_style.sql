/*
Create Dim learning_style in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_diet_learning_style AS (
	WITH learning_style_list AS (
		SELECT DISTINCT
			learning_style
		FROM silver.students
	)
	
	SELECT
		'SL' || 10 + ROW_NUMBER() OVER(ORDER BY learning_style) AS learning_style_id,
		ROW_NUMBER() OVER(ORDER BY learning_style) AS learning_style_skey,
		learning_style
	FROM learning_style_list
);

SELECT * FROM gold.dim_diet_learning_style;