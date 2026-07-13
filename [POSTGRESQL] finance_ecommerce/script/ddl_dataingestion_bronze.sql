\copy bronze.finance_ecommerce 
FROM 'C:\Users\Marcus\Desktop\Portfolio\PROJECTX\finance_ecommerce\source\finance_ecommerce.csv' 
WITH ( 
	format csv,
	DELIMITER ',',
	HEADER true
);
