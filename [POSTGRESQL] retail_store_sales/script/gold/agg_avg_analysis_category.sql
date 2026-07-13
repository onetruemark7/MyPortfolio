-- Shows average purchase of customer
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer
FROM gold.FactSales

-- Shows average purchase of customer in Computer and Electronics category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_CompElectric
FROM gold.FactSales
WHERE Category = 'Computers and electric accessories'

-- Shows average purchase of customer in Milk category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_MilkProducts
FROM gold.FactSales
WHERE Category = 'Milk Products'

-- Shows average purchase of customer in Beverages category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Beverages
FROM gold.FactSales
WHERE Category = 'Beverages'

-- Shows average purchase of customer in Butchers category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Butchers
FROM gold.FactSales
WHERE Category = 'Butchers'

-- Shows average purchase of customer in Patisserie category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Patisserie
FROM gold.FactSales
WHERE Category = 'Patisserie'

-- Shows average purchase of customer in Food category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Food
FROM gold.FactSales
WHERE Category = 'Food'

-- Shows average purchase of customer in Electric Household category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ElectricHousehold
FROM gold.FactSales
WHERE Category = 'Electric household essentials'

-- Shows average purchase of customer in Furniture Household category
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Furniture
FROM gold.FactSales
WHERE Category = 'Furniture'

/*
This lines of codes show average aggregation filtering two columns.
************ COMPUTER AND ELECTRIC ACCESSORIES ************
*/
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ComputerElectricAccessories_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Computers and electric accessories' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ComputerElectricAccessories_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Computers and electric accessories' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ComputerElectricAccessories_Using_Cash
FROM gold.FactSales
WHERE Category = 'Computers and electric accessories' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ MILK PRODUCTS ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_MilkProducts_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Milk Products' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_MilkProducts_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Milk Products' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_MilkProducts_Using_Cash
FROM gold.FactSales
WHERE Category = 'Milk Products' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ BEVERAGES ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Beverages_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Beverages' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Beverages_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Beverages' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Beverages_Using_Cash
FROM gold.FactSales
WHERE Category = 'Beverages' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ BUTCHERS ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Butchers_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Butchers' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Butchers_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Butchers' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Butchers_Using_Cash
FROM gold.FactSales
WHERE Category = 'Butchers' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ PATISSERIE ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Patisserie_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Patisserie' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Patisserie_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Patisserie' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Patisserie_Using_Cash
FROM gold.FactSales
WHERE Category = 'Patisserie' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ FOOD ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Food_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Food' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Food_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Food' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Food_Using_Cash
FROM gold.FactSales
WHERE Category = 'Food' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ ELECTRIC HOUSEHOLD ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ElectricHousehold_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Electric household essentials' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ElectricHousehold_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Electric household essentials' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_ElectricHousehold_Using_Cash
FROM gold.FactSales
WHERE Category = 'Electric household essentials' AND Payment_Method = 'Cash'
-- ***************************************************************************************************


-- ************ ELECTRIC HOUSEHOLD ************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Furniture_Using_CreditCard
FROM gold.FactSales
WHERE Category = 'Furniture' AND Payment_Method = 'Credit Card'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Furniture_Using_DigitalWallet
FROM gold.FactSales
WHERE Category = 'Furniture' AND Payment_Method = 'Digital Wallet'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Spent_Customer_in_Furniture_Using_Cash
FROM gold.FactSales
WHERE Category = 'Furniture' AND Payment_Method = 'Cash'
-- ***************************************************************************************************

-- Shows average sales in online
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) Avg_Sales_Online
FROM gold.FactSales
WHERE Location = 'Online'

-- Shows average sales in walkin store
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) Avg_Sales_inStore
FROM gold.FactSales
WHERE Location = 'In-store'

/*
Shows Average Sales in every Category and in every Location.
*/
-- ************************** COMPUTER AND ELECTRIC ACCESSORIES *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_ComputerElectricAcce_Online
FROM gold.FactSales
WHERE Category = 'Computers and electric accessories' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_ComputerElectricAcce_inStore
FROM gold.FactSales
WHERE Category = 'Computers and electric accessories' AND Location = 'In-store'
-- **************************************************************************************************


-- ************************** MILK PRODUCTS *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_MilkProducts_Online
FROM gold.FactSales
WHERE Category = 'Milk Products' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_MilkProducts_inStore
FROM gold.FactSales
WHERE Category = 'Milk Products' AND Location = 'In-store'
-- **************************************************************************************************


-- ************************** BEVERAGES *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Beverages_Online
FROM gold.FactSales
WHERE Category = 'Beverages' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Beverages_inStore
FROM gold.FactSales
WHERE Category = 'Beverages' AND Location = 'In-store'
-- **************************************************************************************************


-- ************************** BUTCHERS *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Butchers_Online
FROM gold.FactSales
WHERE Category = 'Butchers' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Butchers_inStore
FROM gold.FactSales
WHERE Category = 'Butchers' AND Location = 'In-store'
-- **************************************************************************************************


-- ************************** PATISSERIE *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Patisserie_Online
FROM gold.FactSales
WHERE Category = 'Patisserie' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Patisserie_inStore
FROM gold.FactSales
WHERE Category = 'Patisserie' AND Location = 'In-store'
-- **************************************************************************************************


-- ************************** FOOD *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Food_Online
FROM gold.FactSales
WHERE Category = 'Food' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_Food_inStore
FROM gold.FactSales
WHERE Category = 'Food' AND Location = 'In-store'
-- **************************************************************************************************


-- ************************** ELECTRIC HOUSEHOLD *************************************
SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_ElectricHousehold_Online
FROM gold.FactSales
WHERE Category = 'Electric household essentials' AND Location = 'Online'

SELECT
	CONCAT('$',CAST(AVG(Total_Spent)AS DECIMAL(10,2))) AS Avg_Sales_Of_ElectricHousehold_inStore
FROM gold.FactSales
WHERE Category = 'Electric household essentials' AND Location = 'In-store'
-- **************************************************************************************************

