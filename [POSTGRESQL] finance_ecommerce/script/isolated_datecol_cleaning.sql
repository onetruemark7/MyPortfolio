
	SELECT
		customersince,
		CASE 
			WHEN fe.customersince ~ '^[0-9]{4}$' THEN fe.customersince || '-01' || '-01' -- this line detects only YEAR in records and declares the first day of the year
			WHEN fe.customersince = 'unknown' OR fe.customersince IS NULL THEN '9999-12-31' -- this line detects those input 'unknown' in records. if its unknown, it displays as '9999-12-31'
			WHEN LENGTH(fe.customersince) >=8 AND LENGTH(fe.customersince) <=10  -- this line detects with backlash dates in records
					THEN
						CASE
							WHEN CAST(SPLIT_PART(fe.customersince,'/',1)AS INT) > 12 AND CAST(SPLIT_PART(fe.customersince,'/',2)AS INT) <= 12
								THEN SPLIT_PART(fe.customersince,'/',3) || '-' ||SPLIT_PART(fe.customersince,'/',2) || '-' ||SPLIT_PART(fe.customersince,'/',1)
								
							WHEN CAST(SPLIT_PART(fe.customersince,'/',1)AS INT) < 12 AND CAST(SPLIT_PART(fe.customersince,'/',2)AS INT) >= 12
								THEN SPLIT_PART(fe.customersince,'/',3) || '-' ||SPLIT_PART(fe.customersince,'/',1) || '-' ||SPLIT_PART(fe.customersince,'/',2)
	
							WHEN CAST(SPLIT_PART(fe.customersince,'/',1)AS INT) <= 12 AND CAST(SPLIT_PART(fe.customersince,'/',2)AS INT) <= 12
								THEN SPLIT_PART(fe.customersince,'/',3) || '-' ||SPLIT_PART(fe.customersince,'/',2) || '-' ||SPLIT_PART(fe.customersince,'/',1)
	
							WHEN CAST(SPLIT_PART(fe.customersince,'/',1)AS INT) <= 12 AND CAST(SPLIT_PART(fe.customersince,'/',2)AS INT) > 12
								THEN SPLIT_PART(fe.customersince,'/',3) || '-' ||SPLIT_PART(fe.customersince,'/',1) || '-' ||SPLIT_PART(fe.customersince,'/',2)
							ELSE fe.customersince
						END
			WHEN fe.customersince ~ '^[A-Za-z]{3}-[0-9]{2}$' 
				THEN
					CASE -- every date that has string records like, Jan, Feb Mar, Apr, etc are hardcoded to numeric 
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Jan' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '1' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Feb' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '2' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Mar' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '3' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Apr' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '4' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'May' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '5' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Jun' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '6' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Jul' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '7' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Aug' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '8' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Sep' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '9' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Oct' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '10' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Nov' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '11' || '-' || SPLIT_PART(fe.customersince,'-',2)
						WHEN INITCAP(LOWER(SPLIT_PART(fe.customersince,'-',1))) = 'Dec' THEN to_char(cust_first_txn_date.old_date, 'YYYY') || '-' || '12' || '-' || SPLIT_PART(fe.customersince,'-',2)
						ELSE fe.customersince
					END
			ELSE fe.customersince
		END AS customersince_clean
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
