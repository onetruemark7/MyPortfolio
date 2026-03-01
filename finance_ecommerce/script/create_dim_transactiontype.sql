CREATE OR REPLACE VIEW gold.dim_transactiontype AS
	WITH transactiontype_list AS (
		SELECT DISTINCT
			transactiontype
		FROM silver.finance_ecommerce
	)
	
	SELECT
		10 + ROW_NUMBER() OVER(ORDER BY transactiontype) AS transactiontypeid,
		transactiontype
	FROM transactiontype_list;