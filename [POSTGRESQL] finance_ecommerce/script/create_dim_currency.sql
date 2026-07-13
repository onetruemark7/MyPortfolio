CREATE OR REPLACE VIEW gold.dim_currency AS
	WITH currency_list AS (
	SELECT DISTINCT
		currency
	FROM silver.finance_ecommerce
	)
	
	SELECT
		10 + ROW_NUMBER() OVER(ORDER BY currency) AS currencyid,
		currency
	FROM currency_list;