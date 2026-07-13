WITH minmaxorders AS (
SELECT
 Customer_ID,
 MIN(Transaction_Date) AS old_order,
 MAX(Transaction_Date) AS recent_order
FROM gold.FactSales
GROUP BY
	Customer_ID
)

SELECT
	Customer_ID,
	old_order,
	recent_order,
	DATEDIFF(DAY, old_order, recent_order) AS Test
FROM minmaxorders