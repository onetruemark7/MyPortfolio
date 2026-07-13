create or replace view gold.dim_cost_of_living as (
	SELECT
		'O' || 10 + ROW_NUMBER() OVER(ORDER BY office) as office_id,
		office,
		col_amount as cost_of_living_amount,
		currency
	FROM silver.cost_of_living
);

-- select * from gold.dim_cost_of_living