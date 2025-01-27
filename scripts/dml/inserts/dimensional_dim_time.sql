WITH unique_dates AS(
	SELECT DISTINCT DATE(order_approved_at) AS time_date
	FROM relational.orders
	WHERE order_approved_at IS NOT NULL
)
INSERT INTO dimensional.dim_time (
	time_date,
	time_day,
	time_month,
	time_year,
	week_day
)
SELECT 
	ud.time_date,
	EXTRACT(DAY FROM ud.time_date) AS time_day,
	EXTRACT(MONTH FROM ud.time_date) AS time_month,
	EXTRACT(YEAR FROM ud.time_date) AS time_year,
	EXTRACT(DOW FROM ud.time_date) AS week_day -- 0 = Sunday, 6 = Saturday
FROM unique_dates ud
WHERE NOT EXISTS(
	SELECT 1
	FROM dimensional.dim_time dt
	WHERE dt.time_date = ud.time_date
);