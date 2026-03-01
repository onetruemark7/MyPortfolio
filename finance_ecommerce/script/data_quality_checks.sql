/*============================================  =============================================================*/
/*=====================================================================================================================*/

/*============================================ transactionid_col =============================================================*/
-- shows if theres records of leading and trailing spaces
SELECT
	transactionid
FROM bronze.finance_ecommerce
WHERE transactionid != TRIM(transactionid)

-- shows if theres records of duplicates
SELECT *
FROM bronze.finance_ecommerce
WHERE transactionid IN (
    SELECT transactionid
    FROM bronze.finance_ecommerce
    GROUP BY transactionid
    HAVING COUNT(*) > 1
)
ORDER BY transactionid
/*=====================================================================================================================*/


/*============================================ accoundid_col =============================================================*/
-- shows if theres records of leading and trailing spaces
SELECT
	accountid 
FROM bronze.finance_ecommerce
WHERE accountid  != TRIM(accountid)

-- shows if theres a records containing special characters
SELECT
	accountid 
FROM bronze.finance_ecommerce
WHERE accountid SIMILAR TO '%[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]%'
/*=====================================================================================================================*/


/*============================================ accountname_col =============================================================*/
SELECT 
	accountname 
FROM bronze.finance_ecommerce
WHERE accountname  != TRIM(accountname)

SELECT
	accountname 
FROM bronze.finance_ecommerce
WHERE accountname  SIMILAR TO '%[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]%'
/*=====================================================================================================================*/


/*============================================ transactiontype_col =============================================================*/
SELECT DISTINCT transactiontype FROM bronze.finance_ecommerce --shows distinct records

-- shows distinct records. expectatations: only 4 types/rows
SELECT DISTINCT
*
FROM (SELECT
	CASE
		WHEN transactiontype = 'CREDIT' THEN 'Credit'
		WHEN transactiontype = 'debit' THEN 'Debit'
		WHEN transactiontype IS NULL THEN 'N/A'
		ELSE transactiontype
	END AS transactiontype
FROM bronze.finance_ecommerce)

/*=====================================================================================================================*/

/*============================================ currency_col =============================================================*/
SELECT DISTINCT
	CASE
		WHEN currency = 'inr' OR currency = 'INRr' THEN 'INR'
		WHEN currency = 'usd' OR currency = 'usd ' THEN 'USD'
		WHEN currency = 'gbp' THEN 'GBP'
		WHEN currency = 'aed' THEN 'AED'
		WHEN currency IS NULL THEN 'N/A'
		ELSE TRIM(currency)
	END
FROM bronze.finance_ecommerce

SELECT
	currency
FROM bronze.finance_ecommerce
WHERE currency SIMILAR TO '%[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]%'
/*=====================================================================================================================*/

/*============================================ exchangerate_col =============================================================*/
-- shows when theres records of null, if there is, replace it with 0 numeric
SELECT *
FROM(SELECT 
	CASE
		WHEN exchangerate IS NULL THEN 0
		ELSE exchangerate
	END AS exchangerate
FROM bronze.finance_ecommerce)
WHERE exchangerate IS NULL


/*=====================================================================================================================*/

/*============================================ balance_col =============================================================*/
SELECT
	balance
FROM bronze.finance_ecommerce
WHERE balance LIKE '%[!@#$%^&*()_+\-=\[\]{}|;:<>/\\]%' -- removed comma, period, and question mark. comma(,) and period(.) is part of money
/*=====================================================================================================================*/

/*============================================ merchant_col =============================================================*/
SELECT
merchant 
FROM bronze.finance_ecommerce
WHERE merchant != Trim(merchant)

SELECT DISTINCT
	CASE
		WHEN merchant IS NULL THEN 'N/A'
		ELSE merchant
	END AS merchant
FROM bronze.finance_ecommerce

/*=====================================================================================================================*/

/*============================================ merchantphone_col =============================================================*/
SELECT 
	merchantphone,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE merchantphone IS NULL -- show null counts
GROUP BY merchantphone
HAVING COUNT(*) > 1

SELECT
	merchantphone
FROM bronze.finance_ecommerce
WHERE merchantphone SIMILAR TO '%[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]%'
/*=====================================================================================================================*/

/*============================================ merchantemail_col =============================================================*/
SELECT
	merchantemail
FROM bronze.finance_ecommerce
WHERE merchantemail != TRIM(merchantemail)

SELECT
	merchantemail,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE merchantemail IS NULL
GROUP BY merchantemail
HAVING COUNT(*) > 1
/*=====================================================================================================================*/

/*============================================ merchantemail_col =============================================================*/
SELECT DISTINCT
	Category 
FROM bronze.finance_ecommerce

SELECT
	Category,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE Category IS NULL
GROUP BY Category
HAVING COUNT(*) > 1

/*=====================================================================================================================*/

/*============================================ merchantemail_col =============================================================*/
SELECT DISTINCT
	subcategory 
FROM bronze.finance_ecommerce

SELECT
	subcategory,
	COUNT(*)
FROM bronze.finance_ecommerce
GROUP BY subcategory
HAVING COUNT(*) > 1

SELECT
	subcategory 
FROM bronze.finance_ecommerce
WHERE subcategory != TRIM(subcategory)
/*=====================================================================================================================*/

/*============================================ country_col =============================================================*/
SELECT DISTINCT
	country
FROM bronze.finance_ecommerce

SELECT
	country,
	COUNT(*)
FROM bronze.finance_ecommerce
GROUP BY country
HAVING COUNT(*) > 1
/*=====================================================================================================================*/

/*============================================ city_col =============================================================*/
SELECT DISTINCT
	city
FROM bronze.finance_ecommerce

SELECT
	city,
	COUNT(*)
FROM bronze.finance_ecommerce
GROUP BY city
HAVING COUNT(*) > 1

SELECT
	city 
FROM bronze.finance_ecommerce
WHERE city != TRIM(city)
/*=====================================================================================================================*/

/*============================================ postalcode_col =============================================================*/
SELECT
	postalcode
FROM bronze.finance_ecommerce

SELECT
	postalcode,
	COUNT(*)
FROM bronze.finance_ecommerce
GROUP BY postalcode
HAVING COUNT(*) > 1

SELECT
	postalcode,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE postalcode SIMILAR TO '%[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]%'
GROUP BY postalcode
HAVING COUNT(*) > 1

SELECT
	postalcode,
	COUNT(*)
FROM (SELECT
	CASE
		WHEN postalcode IS NULL OR postalcode = 'N/A' THEN '0'
		ELSE postalcode
	END AS postalcode
FROM bronze.finance_ecommerce)
GROUP BY postalcode
HAVING COUNT(*) > 1
ORDER BY postalcode
/*=====================================================================================================================*/

/*============================================ postalcode_col =============================================================*/
SELECT
	cardnumber,
	COUNT(*) AS count_cards
FROM bronze.finance_ecommerce
WHERE cardnumber LIKE '%+%'
GROUP BY cardnumber
HAVING COUNT(*) > 1

SELECT
	cardnumber,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE cardnumber IS NULL
GROUP BY cardnumber
HAVING COUNT(*) >1

SELECT
	cardnumber
FROM bronze.finance_ecommerce
WHERE cardnumber != TRIM(cardnumber)
/*=====================================================================================================================*/

/*============================================ email_col =============================================================*/

SELECT
	email,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE email IS NULL
GROUP BY email
HAVING COUNT(*) >1

SELECT
	email
FROM bronze.finance_ecommerce
WHERE email != TRIM(email)
/*=====================================================================================================================*/

/*============================================ email_col =============================================================*/
SELECT
	CASE
		WHEN phone IS NULL THEN '0'
		ELSE REPLACE(TRIM(phone),'-','')
	END AS phone
FROM bronze.finance_ecommerce

SELECT
	phone,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE phone IS NULL
GROUP BY phone
HAVING COUNT(*) > 1
/*=====================================================================================================================*/

/*============================================ email_col =============================================================*/
SELECT DISTINCT
	isFraud,
	COUNT(*)
FROM bronze.finance_ecommerce
GROUP BY isFraud

SELECT
	COUNT(isFraud)
FROM bronze.finance_ecommerce

SELECT
	isFraud,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE isFraud IS NULL
GROUP BY isFraud

SELECT
	isFraud
FROM bronze.finance_ecommerce
WHERE isFraud != TRIM(isFraud)

SELECT DISTINCT
	isFraud,
	CASE
		WHEN isFraud = 'Yess' THEN 'Yes'
		WHEN isFraud IS NULL THEN 'N/A'
		ELSE isFraud
	END AS isFraud
FROM bronze.finance_ecommerce
/*=====================================================================================================================*/

/*============================================ email_col =============================================================*/
SELECT DISTINCT
	transactionid,
	accountname,
	isFraud,
	notes
FROM bronze.finance_ecommerce
WHERE notes =  ' -- verify
contact support'

SELECT *
FROM(SELECT
	notes,
	CASE 
	WHEN notes != TRIM(notes) OR notes IS NULL THEN '-- verify contact support'
	WHEN notes LIKE '%verify%' THEN CONCAT(REPLACE(notes,'-- verify
contact support',''),' ', '-- verify contact support')
		ELSE TRIM(notes)
	END AS notes_new
FROM bronze.finance_ecommerce)
WHERE notes LIKE '%verify%'

SELECT DISTINCT
	notes,
	COUNT(*)
FROM bronze.finance_ecommerce
GROUP BY notes
ORDER BY count DESC

SELECT DISTINCT
	notes
FROM bronze.finance_ecommerce
WHERE notes != TRIM(notes)
/*=====================================================================================================================*/

/*============================================ customersince_col =============================================================*/

SELECT
	customersince,
	CASE 
		WHEN fe.customersince ~ '^[0-9]{4}$' THEN fe.customersince || '-01' || '-01' -- this line detects only YEAR in records and declares the first day of the year
		WHEN fe.customersince = 'unknown' THEN '9999-99-99' -- this line detects those input 'unknown' in records. if its unknown, it displays as '9999-99-99'
		WHEN LENGTH(fe.customersince) >=8 AND -- this line detects with backlash dates in records
			LENGTH(fe.customersince) <=10 THEN SPLIT_PART(fe.customersince,'/',3) || '-' ||SPLIT_PART(fe.customersince,'/',2) || '-' ||SPLIT_PART(fe.customersince,'/',1) 
		WHEN customersince ~ '^[A-Za-z]{3}-[0-9]{2}$' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || to_char(to_date(fe.customersince, 'Mon-YY'),'Mon-YY')
		ELSE customersince
	END customersince_clean
FROM bronze.finance_ecommerce fe
JOIN (
	SELECT
		transactionid,
		accountid,
	MIN(date) OVER(PARTITION BY accountid ORDER BY date) AS old_date,
	MAX(date) OVER(PARTITION BY accountid ORDER BY date DESC) AS recent_date
	FROM bronze.finance_ecommerce
	) AS cust_first_txn_date
	ON fe.transactionid = cust_first_txn_date.transactionid

/*=====================================================================================================================*/

/*============================================ amount_col =============================================================*/
SELECT
	amount,
	COUNT(*)
FROM bronze.finance_ecommerce
WHERE amount SIMILAR TO '%[!@#$%^&*()_+\=\[\]{}|;:,<>?/\\]%'
GROUP BY amount
HAVING COUNT(*) > 1

SELECT
	amount
FROM bronze.finance_ecommerce
WHERE amount != TRIM(amount)

SELECT
	amount
FROM bronze.finance_ecommerce
WHERE amount IS NULL

SELECT
    amount,
   		CASE
	        WHEN amount IS NULL THEN CAST(COALESCE(amount, 0)AS DECIMAL(10,2))
	        WHEN amount LIKE '%$%' THEN COALESCE(CAST(NULLIF(REPLACE(TRIM(amount),'$',''),'')AS DECIMAL(10,2)),0)
			WHEN amount LIKE '%x' THEN COALESCE(CAST(NULLIF(REPLACE(TRIM(amount),'x',''),'')AS DECIMAL(10,2)),0)
			WHEN amount LIKE '%?%' THEN COALESCE(CAST(NULLIF(REPLACE(TRIM(amount),'?',''),'')AS DECIMAL(10,2)),0)
			WHEN amount LIKE '%,%' THEN COALESCE(CAST(NULLIF(REPLACE(TRIM(amount),',',''),'')AS DECIMAL(10,2)),0)
			WHEN amount LIKE '%-%' THEN COALESCE(CAST(NULLIF(REPLACE(TRIM(amount),'-',''),'')AS DECIMAL(10,2)),0)
			WHEN SPLIT_PART(amount,' ',1) ~ '[A-Za-z]' THEN CAST(SPLIT_PART(amount,' ',2)AS DECIMAL(10,2))
	        ELSE COALESCE(CAST(NULLIF(REGEXP_REPLACE(TRIM(amount),'[^0-9.\-]','','g'), '') AS DECIMAL(10,2)), 0)
    	END AS amount
FROM bronze.finance_ecommerce

SELECT DISTINCT amount
FROM bronze.finance_ecommerce
WHERE amount IS NOT NULL
  AND amount !~ '^\s*\$?[\d,]+(\.\d+)?\s*$'  -- not a normal number
  AND amount NOT LIKE '%$%'
  AND amount NOT LIKE '%?%'
  AND amount NOT LIKE '%,%'
  AND amount NOT LIKE '%x'
  AND amount NOT LIKE '%-%'
  AND SPLIT_PART(amount,' ',1) !~ '[A-Za-z]'
ORDER BY amount desc;

SELECT amount, 
       REGEXP_REPLACE(TRIM(amount), '[^0-9.-]', '', 'g') AS after_clean,
       LENGTH(REGEXP_REPLACE(TRIM(amount), '[^0-9.-]', '', 'g')) AS len
FROM bronze.finance_ecommerce
WHERE 
    amount IS NOT NULL
    AND amount NOT LIKE '%[0-9]%';   -- ← start here — these are the killers

SELECT DISTINCT
    amount,
	COUNT(*)
FROM bronze.finance_ecommerce
--WHERE amount ~ '[A-Za-z]'
WHERE amount ~ ' ' OR amount ~ '[!@#$%^&*()_+\=\[\]{}|;:,<>?/\\]'
GROUP BY amount
HAVING COUNT(*) >1

SELECT amount
FROM bronze.finance_ecommerce
WHERE amount = '2,582,959.57'

/*=====================================================================================================================*/

/*============================================ accountname_col =============================================================*/
SELECT
	accountname,
	SPLIT_PART(accountname,' ',1) AS firstname,
	CASE
		WHEN SPLIT_PART(accountname,' ',1) = LOWER(SPLIT_PART(accountname,' ',1)) THEN INITCAP(SPLIT_PART(accountname,' ',1))
		ELSE TRIM(accountname)
	END AS firstname
FROM bronze.finance_ecommerce
WHERE SPLIT_PART(accountname,' ',1) = LOWER(SPLIT_PART(accountname,' ',1))

SELECT
	accountname,
	CASE
	WHEN SPLIT_PART(accountname, ' ',2) = UPPER(SPLIT_PART(accountname, ' ',2)) THEN INITCAP(LOWER(SPLIT_PART(accountname, ' ',2)))
	ELSE TRIM(accountname)
END AS lastname
FROM bronze.finance_ecommerce
WHERE SPLIT_PART(accountname, ' ',2) = UPPER(SPLIT_PART(accountname, ' ',2))


SELECT
	accountname
FROM bronze.finance_ecommerce
WHERE accountname ~ '[0-9]' OR accountname ~ '[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]'
/*=====================================================================================================================*/

SELECT
	balance
FROM (
	SELECT
	CASE
		WHEN balance ~ '[A-Za-z]' THEN CAST('0' AS DECIMAL(15,2))
		WHEN balance ~ '[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]'
			THEN
				CAST(
					TRIM(
						REPLACE(
							REPLACE(
								REPLACE(balance,'?','')
							,'-','')
						,',','')
					)
				AS DECIMAL(15,2))
		ELSE CAST(TRIM(balance)AS DECIMAL(15,2))
	END AS balance
	FROM bronze.finance_ecommerce
)


SELECT 
	balance,
	CASE
		WHEN balance ~ '[A-Za-z]' THEN CAST('0' AS DECIMAL(15,2))
		ELSE CAST(TRIM(balance)AS DECIMAL(15,2))
	END AS balance
FROM bronze.finance_ecommerce
WHERE balance ~ '[A-Za-z]';

SELECT
 *
FROM bronze.finance_ecommerce AS fe
WHERE fe::text ILIKE '%15,410.00%';

