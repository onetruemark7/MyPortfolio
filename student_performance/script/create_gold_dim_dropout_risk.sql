/*
Create Dim dropout_risk in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_dropout_risk AS (
	WITH dropoutrisk_list AS (
		SELECT DISTINCT
			dropout_risk
		FROM silver.students
	)
	
	SELECT
		'DR' || 10 + ROW_NUMBER() OVER(ORDER BY dropout_risk) AS dropout_risk_id,
		ROW_NUMBER() OVER(ORDER BY dropout_risk) AS dropout_risk_skey,
		dropout_risk
	FROM dropoutrisk_list
);

SELECT * FROM gold.dim_dropout_risk;