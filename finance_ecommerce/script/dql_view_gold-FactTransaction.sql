CREATE VIEW gold."FactTransaction" AS (
SELECT
	transactionid,
	accountid,
	merchant,
	date,
	transactiontype,
	currency,
	amount,
	exchangerate,
	balance,
	cardnumber,
	notes,
	isFraud
FROM silver.finance_ecommerce
)