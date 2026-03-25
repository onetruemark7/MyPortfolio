CREATE OR REPLACE PROCEDURE reload_silver_cost_of_living()
language plpgsql
as
	$$
		begin
			TRUNCATE TABLE silver.cost_of_living;

			INSERT INTO silver.cost_of_living (
				office ,
				col_amount ,
				currency 
			)
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
			FROM bronze.cost_of_living;

			raise notice 'loading successfully: silver.cost_of_living';
		end
	$$;

-- call reload_silver_cost_of_living()
-- SELECT * FROM silver.cost_of_living

