WITH filtering AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY review_id) AS row_num
	FROM
		relational.order_reviews
	WHERE
		review_id IS NOT NULL AND
		order_id IS NOT NULL AND
		review_score IS NOT NULL AND
		review_comment_title IS NOT NULL AND
		review_comment_message IS NOT NULL AND
		review_creation_date IS NOT NULL AND
		review_answer_timestamp IS NOT NULL
),d_rev AS (
	SELECT 
		r_rev.review_id,
		r_rev.order_id,
		f_ord.customer_key,
		f_ord.product_key,
		d_tim.time_Key,
		d_pro.product_category_name,
		r_rev.review_score
	FROM
		filtering r_rev
	INNER JOIN
		dimensional.orders_fact f_ord
	ON
		r_rev.order_id = f_ord.order_id
	INNER JOIN
		dimensional.dim_time d_tim
	ON
		r_rev.review_creation_date::DATE = d_tim.time_date
	INNER JOIN
		dimensional.products d_pro
	ON 
		f_ord.product_key = d_pro.product_key
	WHERE
		row_num = 1
)		
INSERT INTO dimensional.fact_order_reviews(
	review_id,
	order_id,
	customer_key,
	product_key,
	time_key,
	product_category_name,
	review_score
)
SELECT 
	d_rev.review_id,
	d_rev.order_id,
	d_rev.customer_key,
	d_rev.product_key,
	d_rev.time_key,
	d_rev.product_category_name,
	d_rev.review_score
FROM
	d_rev
WHERE NOT EXISTS(
	SELECT 1
	FROM 
		dimensional.fact_order_reviews d_for
	WHERE
		d_for.review_id = d_rev.review_id AND	
		d_for.order_id = d_rev.order_id AND
		d_for.customer_key = d_rev.customer_key AND
		d_for.product_key = d_rev.product_key AND
		d_for.time_key = d_rev.time_key AND
		d_for.product_category_name = d_rev.product_category_name AND	
		d_for.review_score = d_rev.review_score
);

 