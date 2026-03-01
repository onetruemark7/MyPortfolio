
-- CREATE OR REPLACE VIEW gold.dim_merchant AS
	WITH merchant_list AS (
	SELECT DISTINCT
		REGEXP_REPLACE(merchant, 'N/A', 'Other') AS merchant
	FROM silver.finance_ecommerce
	)

	, merchantphone_list AS (
	SELECT
		merchantphone
	FROM silver.finance_ecommerce
	WHERE merchantphone != '0'
	ORDER BY merchantphone ASC
	LIMIT 15
	)

	SELECT
		ROW_NUMBER() OVER() + 10 AS merchantid,
		m.merchant,
		REGEXP_REPLACE(LOWER(m.merchant) || '@biz'||'.com','other@biz.com','Unknown') AS merchantemail,
		mp.merchantphone
	FROM merchant_list m
	JOIN merchantphone_list mp
		ON m.merchant > mp.merchantphone
	

	