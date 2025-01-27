WITH filtered_product AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY product_id) AS row_num
	FROM
		relational.products
	WHERE NOT (
        product_id IS NULL OR
        product_category_name IS NULL OR
        product_description_lenght IS NULL OR
        product_photos_qty IS NULL OR
        product_weight_g IS NULL OR
        product_lenght_cm IS NULL OR
        product_height_cm IS NULL OR
        product_width_cm IS NULL
	)
),
r_pro AS (
	SELECT * 
	FROM 
		filtered_product
	WHERE row_num = 1
)
INSERT INTO dimensional.products(
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_lenght_cm,
	product_height_cm,
	product_width_cm
)
SELECT 
	r_pro.product_id,
	r_pro.product_category_name,
	r_pro.product_name_lenght,
	r_pro.product_description_lenght,
	r_pro.product_photos_qty,
	r_pro.product_weight_g,
	r_pro.product_lenght_cm,
	r_pro.product_height_cm,
	r_pro.product_width_cm
FROM
	r_pro
WHERE NOT EXISTS(
	SELECT 1
	FROM
		dimensional.products d_pro
	WHERE
		d_pro.product_id = r_pro.product_id AND
		d_pro.product_category_name = r_pro.product_category_name AND
		d_pro.product_name_lenght = r_pro.product_name_lenght AND
		d_pro.product_description_lenght = r_pro.product_description_lenght AND
		d_pro.product_photos_qty = r_pro.product_photos_qty AND
		d_pro.product_weight_g = r_pro.product_weight_g AND
		d_pro.product_lenght_cm = r_pro.product_lenght_cm AND
		d_pro.product_height_cm = r_pro.product_height_cm AND
		d_pro.product_width_cm = r_pro.product_width_cm
);