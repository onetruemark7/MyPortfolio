CREATE OR REPLACE VIEW gold.fact_transaction AS
SELECT
	fe.transactionid,
	fe.accountid,
	fe.date,
	t.transactiontypeid,
	fe.amount,
	c.currencyid,
	fe.exchangerate,
	fe.balance,
	m.merchantid,
	cat.categoryid,
	sc.subcategoryid,
	co.countryid,
	fe.cardnumber,
	fe.isFraud,
	fe.notes
FROM silver.finance_ecommerce fe
JOIN gold.dim_transactiontype t
	ON fe.transactiontype = t.transactiontype
JOIN gold.dim_currency c
	ON fe.currency = c.currency
JOIN gold.dim_merchant m
	ON fe.merchant = m.merchant
JOIN gold.dim_category cat
	ON fe.category = cat.category
JOIN gold.dim_subcategory sc
	ON fe.subcategory = sc.subcategory
JOIN gold.dim_country co
	ON fe.country = co.country
ORDER BY date


-- SELECT * FROM silver.finance_ecommerce ORDER BY date