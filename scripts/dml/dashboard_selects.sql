--Total order by date and payment type
SELECT
	DATE(d_tim.time_date) AS "order day",
	d_tim.time_month AS "month",
	d_tim.time_day AS "day",
	d_tim.time_year AS "year",
	REPLACE(d_orp.payment_type, '_', ' ') AS "payment type",
	COUNT(d_oft.*) AS "total orders"
FROM
	dimensional.orders_fact d_oft
INNER JOIN
	dimensional.dim_time d_tim
ON
	d_oft.time_key = d_tim.time_key
INNER JOIN	
	dimensional.order_payments d_orp
ON
	d_oft.order_payment_key = d_orp.order_payment_key
GROUP BY
	"payment type",
	"order day",
	"month",
	"day",
	"year"
ORDER BY
	"order day";

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


--Number of reviews by product
SELECT 
	d_rev.review_id AS "review id",
	d_pro.product_id AS "product id",
	REPLACE(d_pro.product_category_name, '_', ' ') AS "product category name",
	d_cus.customer_state AS "customer state",
	d_cus.customer_city AS "customer city",
	COUNT(*) AS "total reviews"
	
FROM
	dimensional.fact_order_reviews d_rev
INNER JOIN
	dimensional.customers d_cus
ON
	d_rev.customer_key = d_cus.customer_key
INNER JOIN
	dimensional.products d_pro
ON
	d_rev.product_key = d_pro.product_key
GROUP BY
	review_id,
	product_id,
	"product category name",
	customer_state,
	customer_city
ORDER BY
	"total reviews" DESC ;


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