create or replace view gold.dim_employee as (
	select
	employeeid,
	first_name,
	surname,
	streetaddress,
	zipcode,
	city,
	date_of_birth
from silver.company_data
);


-- select * from gold.dim_employee