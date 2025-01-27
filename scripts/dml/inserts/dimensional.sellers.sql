WITH r_sel AS (
	SELECT *
	FROM
		relational.sellers
	WHERE NOT(
		seller_id IS NULL OR
		seller_zip_code_prefix IS NULL OR
		seller_city IS NULL OR
		seller_stae IS NULL
	)
)
INSERT INTO dimensional.sellers(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
SELECT 
	r_sel.seller_id,
	r_sel.seller_zip_code_prefix,
	r_sel.seller_city,
	r_sel.seller_state
FROM 
	r_sel
WHERE NOT EXISTS(
	SELECT 1
	FROM 
		dimensional.sellers d_sel
	WHERE
		d_sel.seller_id = r_sel.seller_id AND
		d_sel.seller_zip_code_prefix = r_sel.seller_zip_code_prefix AND
		d_sel.seller_city = r_sel.seller_city AND
		d_sel.seller_state = r_sel.seller_state
);
