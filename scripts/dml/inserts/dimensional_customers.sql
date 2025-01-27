WITH filtered_customers AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY customer_unique_id ORDER BY customer_id) AS row_num
	FROM 
		relational.customers
	WHERE NOT (
		customer_id IS NULL OR
		customer_unique_id IS NULL OR
		customer_zip_code_prefix IS NULL OR
		customer_city IS NULL OR
		customer_state IS NULL
	)
),
r_cus AS (
	SELECT * 
	FROM 
		filtered_customers 
	WHERE 
		row_num = 1
)
INSERT INTO dimensional.customers(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
SELECT 
	r_cus.customer_id,
	r_cus.customer_unique_id,
	r_cus.customer_zip_code_prefix,
	r_cus.customer_city,
	r_cus.customer_state
FROM 
	r_cus
WHERE NOT EXISTS(
	SELECT 1
	FROM 
		dimensional.customers d_cus
	WHERE 
		d_cus.customer_id = r_cus.customer_id AND
		d_cus.customer_unique_id = r_cus.customer_unique_id AND
		d_cus.customer_zip_code_prefix = r_cus.customer_zip_code_prefix AND
		d_cus.customer_city = r_cus.customer_city AND
		d_cus.customer_state = r_cus.customer_state
);



