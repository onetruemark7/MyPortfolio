CREATE VIEW gold.DimMerchant AS (
SELECT
	REGEXP_REPLACE(merchant,'N/A','Other','g') AS merchant,
	merchantphone,
	merchantemail,
	country,
	category,
	subcategory
FROM silver.finance_ecommerce
);
