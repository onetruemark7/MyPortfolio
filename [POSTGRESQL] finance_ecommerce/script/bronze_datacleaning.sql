
	SELECT
		TRIM(fe.transactionid) AS transactionid,
		date,
		TRIM(fe.accountid) AS accountid,

		CASE
			WHEN SPLIT_PART(accountname,' ',1) = LOWER(SPLIT_PART(accountname,' ',1)) THEN INITCAP(SPLIT_PART(accountname,' ',1))
			ELSE TRIM(SPLIT_PART(accountname,' ',1))
		END AS firstname,

		CASE
			WHEN SPLIT_PART(accountname, ' ',2) = UPPER(SPLIT_PART(accountname, ' ',2)) THEN INITCAP(LOWER(SPLIT_PART(accountname, ' ',2)))
			ELSE TRIM(SPLIT_PART(accountname, ' ',2))
		END AS lastname,
		
		CASE
			WHEN fe.transactiontype = 'CREDIT' THEN 'Credit'
			WHEN fe.transactiontype = 'debit' THEN 'Debit'
			WHEN fe.transactiontype IS NULL THEN 'N/A'
			ELSE fe.transactiontype
		END AS transactiontype,

		CASE
	        WHEN amount IS NULL THEN '0'
	        WHEN amount LIKE '%$%' THEN REPLACE(TRIM(amount),'$','')
			WHEN amount LIKE '%x' THEN REPLACE(TRIM(amount),'x','')
			WHEN amount LIKE '%?%' THEN REPLACE(TRIM(amount),'?','')
			WHEN SPLIT_PART(amount,' ',1) ~ '[A-Za-z]' THEN SPLIT_PART(amount,' ',2)
	        ELSE CAST(TRIM(amount)AS VARCHAR(50))
    	END AS amount,
	
		CASE
			WHEN fe.currency = 'inr' OR fe.currency = 'INRr' THEN 'INR'
			WHEN fe.currency = 'usd' OR fe.currency = 'usd ' THEN 'USD'
			WHEN fe.currency = 'gbp' THEN 'GBP'
			WHEN fe.currency = 'aed' THEN 'AED'
			WHEN fe.currency IS NULL THEN 'N/A'
			ELSE TRIM(fe.currency)
		END AS currency,
	
		COALESCE(fe.exchangerate,0) AS exchangerate,
		
		REPLACE(REPLACE(fe.balance,'?',''),'-','') AS balance,
	
		COALESCE(fe.merchant,'N/A') AS merchant,
	
		CASE
			WHEN fe.merchantphone IS NULL THEN '0'
			ELSE TRIM(REPLACE(fe.merchantphone,'-',''))
		END AS merchantphone,
	
		COALESCE(fe.merchantemail,'N/A') AS merchantemail,
	
		COALESCE(fe.Category,'N/A') AS Category,
	
		COALESCE(fe.subcategory,'N/A') AS subcategory,
	
		COALESCE(fe.country,'N/A') AS country,
	
		COALESCE(fe.city,'N/A') AS city,
	
		CASE
			WHEN fe.postalcode IS NULL OR fe.postalcode = 'N/A' THEN '0'
			ELSE fe.postalcode
		END AS postalcode,
	
		COALESCE(fe.cardnumber,'0') AS cardnumber,
	
		COALESCE(fe.email, 'N/A') AS email,
	
		CASE
			WHEN fe.phone IS NULL THEN '0'
			ELSE REPLACE(TRIM(fe.phone),'-','')
		END AS phone,
	
		CASE
			WHEN fe.isFraud = 'Yess' THEN 'Yes'
			WHEN fe.isFraud IS NULL THEN 'N/A'
			ELSE fe.isFraud
		END AS isFraud,
	
		CASE 
		    WHEN fe.notes IS NULL THEN '-- verify contact support'
		    WHEN fe.notes != TRIM(fe.notes) THEN '-- verify contact support'
		    WHEN fe.notes LIKE '%-- verify' || chr(10) || 'contact support%' 
		        THEN TRIM(REPLACE(fe.notes, '-- verify' || chr(10) || 'contact support', '')) 
		             || ' -- verify contact support'
		    ELSE TRIM(fe.notes)
		END AS notes,
		
		CASE 
			WHEN fe.customersince ~ '^[0-9]{4}$' THEN fe.customersince || '-01' || '-01' -- this line detects only YEAR in records and declares the first day of the year
			WHEN fe.customersince = 'unknown' THEN '9999-12-31' -- this line detects those input 'unknown' in records. if its unknown, it displays as '9999-12-31'
			WHEN LENGTH(fe.customersince) >=8 AND -- this line detects with backlash dates in records
				LENGTH(fe.customersince) <=10 THEN SPLIT_PART(fe.customersince,'/',3) || '-' ||SPLIT_PART(fe.customersince,'/',2) || '-' ||SPLIT_PART(fe.customersince,'/',1) 
			WHEN fe.customersince ~ '^[A-Za-z]{3}-[0-9]{2}$' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || to_char(to_date(fe.customersince, 'Mon-YY'),'Mon-YY')
			ELSE fe.customersince
		END AS customersince
		
	FROM bronze.finance_ecommerce AS fe
	JOIN (
		SELECT
			transactionid,
			accountid,
		MIN(date) OVER(PARTITION BY accountid ) AS old_date,
		MAX(date) OVER(PARTITION BY accountid ) AS recent_date
		FROM bronze.finance_ecommerce
		) AS cust_first_txn_date
		ON fe.transactionid = cust_first_txn_date.transactionid
	WHERE fe.transactionid IN (
	    SELECT transactionid
	    FROM bronze.finance_ecommerce
	    GROUP BY transactionid
	    HAVING COUNT(*) = 1
	)
	ORDER BY transactionid

