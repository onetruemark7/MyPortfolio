-- shows unique data from Category column
SELECT DISTINCT 
	Category
FROM gold.FactSales

-- shows unique data from Item and Price Per Unit columnn exluding low quality data
SELECT DISTINCT 
	Item,
	Price_Per_Unit
FROM gold.FactSales
WHERE Item != 'Other'
ORDER BY Item

-- shows unique data from Payment Method column
SELECT DISTINCT 
	Payment_Method
FROM gold.FactSales

-- shows unique data from Location column
SELECT DISTINCT 
	Location
FROM gold.FactSales