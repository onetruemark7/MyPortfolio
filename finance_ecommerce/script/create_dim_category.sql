CREATE OR REPLACE VIEW gold.dim_category AS
WITH category_list AS (
	SELECT DISTINCT
		category
	FROM silver.finance_ecommerce
)

SELECT
	10 + ROW_NUMBER() OVER(ORDER BY category) AS categoryid,
	category
FROM category_list
