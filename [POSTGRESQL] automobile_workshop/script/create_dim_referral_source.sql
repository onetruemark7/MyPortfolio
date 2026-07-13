-- create dim referral source
CREATE OR REPLACE VIEW gold.dim_referralsource AS (
	WITH dim_referralsource AS (
	SELECT DISTINCT
		referral_source
	FROM silver.automobile
	)
	
	SELECT
		'RS' || (10+ROW_NUMBER() OVER(ORDER BY referral_source))::TEXT AS referral_source_id,
		referral_source
	FROM dim_referralsource
);