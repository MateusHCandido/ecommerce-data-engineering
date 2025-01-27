--Number of orders by day
SELECT
	DATE(d_tim.time_date) AS order_day,
	COUNT(d_oft.*) AS total_orders
FROM
	dimensional.orders_fact d_oft
INNER JOIN
	dimensional.dim_time d_tim
ON
	d_oft.time_key = d_tim.time_key
GROUP BY
	DATE(time_date)
ORDER BY
	order_day


--Number of reviews by product
SELECT 
    d_pro.product_id, 
    d_pro.product_category_name,
    COUNT(*) AS total_reviews
FROM 
    dimensional.fact_order_reviews d_for
INNER JOIN
    dimensional.products d_pro
ON	
    d_for.product_key = d_pro.product_key
GROUP BY
    d_pro.product_id, 
    d_pro.product_category_name
ORDER BY
    total_reviews DESC


--Number of orders by location
SELECT 
	d_geo.geolocation_state,
	d_geo.geolocation_city,
	d_geo.geolocation_lat,
	d_geo.geolocation_lng,
	d_geo.geolocation_zip_code_prefix,
	COUNT(d_oft.*) AS total_orders
FROM 
	dimensional.orders_fact d_oft
INNER JOIN
	dimensional.geolocation d_geo
ON
	d_oft.geolocation_key = d_geo.geolocation_key
GROUP BY
	geolocation_state,
	d_geo.geolocation_city,
	d_geo.geolocation_lat,
	d_geo.geolocation_lng,
	d_geo.geolocation_zip_code_prefix
ORDER BY
	geolocation_state


--Number of orders by payment type
SELECT 
	d_orp.payment_type,
	COUNT(d_oft.*) AS total_orders
FROM
	dimensional.orders_fact d_oft
INNER JOIN
	dimensional.order_payments d_orp
ON
	d_oft.order_payment_key = d_orp.order_payment_key
GROUP BY
	d_orp.payment_type
ORDER BY
	total_orders DESC;


--Number of reviews by customer
SELECT
	d_cus.customer_unique_id,
	d_cus.customer_state,
	d_cus.customer_city,
	COUNT(d_for.*) AS total_reviews
FROM
	dimensional.fact_order_reviews d_for
INNER JOIN
	dimensional.customers d_cus
ON
	d_for.customer_key = d_cus.customer_key
GROUP BY
	customer_unique_id,
	customer_state,
	customer_city
ORDER BY
	customer_state;