WITH order_items_non_filtereds AS (
    SELECT 
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        ROW_NUMBER() OVER (PARTITION BY order_id, product_id, seller_id, shipping_limit_date, price, freight_value) AS row_num
    FROM 
        relational.order_items
),order_items AS (
	SELECT * FROM order_items_non_filtereds WHERE row_num = 1
),
d_ft AS (
    SELECT 
        r_ord.order_id,
        r_ori.order_item_id,
        d_orp.payment_sequential,
        d_cus.customer_key,
        d_geo.geolocation_key,
        d_tim.time_key,
        d_orp.order_payment_key,
        d_pro.product_key,
        r_ord.order_status,
        r_ord.order_approved_at,
        r_ori.price,
        r_ori.freight_value,
        ROW_NUMBER() OVER (
            PARTITION BY 
                r_ori.order_id, 
                r_ori.product_id, 
                r_ori.seller_id, 
                r_ori.shipping_limit_date, 
                r_ori.price, 
                r_ori.freight_value
        ) AS row_num
    FROM
        relational.orders r_ord
    INNER JOIN
        order_items r_ori
    ON
        r_ori.order_id = r_ord.order_id
    INNER JOIN
        dimensional.customers d_cus
    ON    
        r_ord.customer_id = d_cus.customer_id
    INNER JOIN
        dimensional.geolocation d_geo
    ON
        d_cus.customer_zip_code_prefix = d_geo.geolocation_zip_code_prefix
    INNER JOIN
        dimensional.dim_time d_tim
    ON
        r_ord.order_approved_at::DATE = d_tim.time_date
    INNER JOIN
        dimensional.order_payments d_orp
    ON
        r_ord.order_id = d_orp.order_id
    INNER JOIN
        dimensional.products d_pro
    ON
        r_ori.product_id = d_pro.product_id
)

INSERT INTO dimensional.orders_fact (
	order_id,
    order_item_id,
    payment_sequential,
    customer_key,
    geolocation_key,
    time_key,
    order_payment_key,
    product_key,
    order_status,
    order_approved_at,
    product_value,
    freight_value
)
SELECT 
	d_ft.order_id,
	d_ft.order_item_id,
	d_ft.payment_sequential,
	d_ft.customer_key,
	d_ft.geolocation_key,
	d_ft.time_key,
	d_ft.order_payment_key,
	d_ft.product_key,
	d_ft.order_status,
	d_ft.order_approved_at,
	d_ft.price,
	d_ft.freight_value
FROM d_ft
WHERE NOT EXISTS(
	SELECT 1
	FROM dimensional.orders_fact d_of
	WHERE
		d_ft.order_id = d_of.order_id
		AND d_ft.order_item_id = d_of.order_item_id
		AND d_ft.payment_sequential= d_of.payment_sequential
		AND d_ft.customer_key = d_of.customer_key
		AND d_ft.geolocation_key = d_of.geolocation_key
		AND d_ft.time_key = d_of.time_key
		AND d_ft.order_payment_key = d_of.order_payment_key
		AND d_ft.product_key = d_of.product_key
		AND d_ft.order_status = d_of.order_status
		AND d_ft.order_approved_at = d_of.order_approved_at
		AND d_ft.price = d_of.product_value
		AND d_ft.freight_value = d_of.freight_value
);