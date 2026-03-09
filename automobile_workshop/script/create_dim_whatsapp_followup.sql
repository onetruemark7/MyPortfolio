-- create dim whatsapp_followup
CREATE OR REPLACE VIEW gold.dim_whatsappfollowup AS (
	WITH dim_whatsappfollowup AS (
	SELECT DISTINCT
		whatsapp_followup
	FROM silver.automobile
	)
	
	SELECT
		'WF' || (10+ROW_NUMBER() OVER(ORDER BY whatsapp_followup))::TEXT AS whatsapp_followup_id,
		whatsapp_followup
	FROM dim_whatsappfollowup
);