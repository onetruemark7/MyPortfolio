CREATE OR REPLACE VIEW gold.dim_country AS
	WITH country_list AS (
		SELECT DISTINCT
			country
		FROM silver.finance_ecommerce
	)
	
	SELECT
		10 + ROW_NUMBER() OVER(ORDER BY country) AS countryid,
		country
	FROM country_list