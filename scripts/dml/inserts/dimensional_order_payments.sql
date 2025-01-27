WITH filtered_order_payments AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY 
                   order_id, 
                   payment_sequential, 
                   payment_type, 
                   payment_installments, 
                   payment_value
               ORDER BY order_id
           ) AS row_num
    FROM relational.order_payments
    WHERE NOT (
        order_id IS NULL OR
        payment_sequential IS NULL OR
        payment_type IS NULL OR
        payment_installments IS NULL OR
        payment_value IS NULL
    )
),
r_orp AS (
	SELECT 
		order_id, 
	   	payment_sequential, 
	    payment_type, 
	    payment_installments, 
	    payment_value
	FROM 
		filtered_order_payments 
	WHERE 
		row_num = 1
)
INSERT INTO dimensional.order_payments(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
SELECT 
	r_orp.order_id,
	r_orp.payment_sequential,
	r_orp.payment_type,
	r_orp.payment_installments,
	r_orp.payment_value
FROM
	r_orp
WHERE NOT EXISTS(
	SELECT 1
	FROM
		dimensional.order_payments d_orp
	WHERE
		d_orp.order_id = r_orp.order_id AND
		d_orp.payment_sequential = r_orp.payment_sequential AND
		d_orp.payment_type = r_orp.payment_type AND
		d_orp.payment_installments = r_orp.payment_installments AND
		d_orp.payment_value = r_orp.payment_value
);