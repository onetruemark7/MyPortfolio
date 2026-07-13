SELECT
	CASE office
		WHEN 'NYC' THEN 'New York City'
		WHEN 'SanJose' THEN 'San Jose'
		WHEN 'HongKong' THEN 'Hong Kong'
		WHEN 'SanFran' THEN 'San Francisco'
		ELSE office
	END AS office_clean,

	col_amount,

	currency
FROM bronze.cost_of_living