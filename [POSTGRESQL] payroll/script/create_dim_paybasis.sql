CREATE OR REPLACE VIEW gold.dim_paybasis AS (
WITH id_pay_basis AS (
SELECT DISTINCT
	pay_basis	
FROM silver.payroll
LIMIT 1000
)

SELECT
	'PB' || ROW_NUMBER() OVER(ORDER BY pay_basis)::TEXT AS id_pay_basis,
	pay_basis
FROM id_pay_basis
);

-- SELECT * FROM gold.dim_paybasis