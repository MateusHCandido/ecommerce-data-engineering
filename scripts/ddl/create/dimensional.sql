CREATE SCHEMA IF NOT EXISTS dimensional;

-- TABELAS DIMENSIONAIS

--DIMENSION TIME
CREATE TABLE IF NOT EXISTS dimensional.dim_time(
    time_key SERIAL PRIMARY KEY,
    time_date DATE NOT NULL,
    time_day CHAR(2) NOT NULL,
    time_month CHAR(2) NOT NULL,
    time_year CHAR(4) NOT NULL,
    week_day INT NOT NULL
);

--DIMENSION GEOLOCATION
CREATE TABLE IF NOT EXISTS dimensional.geolocation(
	geolocation_key SERIAL PRIMARY KEY,
	geolocation_zip_code_prefix VARCHAR(10) NOT NULL,
	geolocation_lat DOUBLE PRECISION NOT NULL,
	geolocation_lng DOUBLE PRECISION NOT NULL,
	geolocation_city VARCHAR(50) NOT NULL,
	geolocation_state VARCHAR(2) NOT NULL
);

--DIMENSION CUSTOMERS
CREATE TABLE IF NOT EXISTS dimensional.customers (
    customer_key SERIAL PRIMARY KEY,
    customer_id CHAR(32) NOT NULL,
    customer_unique_id CHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(10) NOT NULL,
    customer_city VARCHAR(50) NOT NULL,
    customer_state CHAR(2) NOT NULL
);

--DIMENSION PRODUCTS
CREATE TABLE IF NOT EXISTS dimensional.products (
	product_key SERIAL PRIMARY KEY,
    product_id CHAR(32) NOT NULL,
    product_category_name VARCHAR(100) NOT NULL,
    product_name_lenght INT NOT NULL,
    product_description_lenght INT NOT NULL,
    product_photos_qty INT NOT NULL,
    product_weight_g INT NOT NULL,
    product_lenght_cm INT NOT NULL,
    product_height_cm INT NOT NULL,
    product_width_cm INT NOT NULL
);

--DIMENSION ORDER_PAYMENTS
CREATE TABLE IF NOT EXISTS dimensional.order_payments (
	order_payment_key SERIAL PRIMARY KEY,
    order_id CHAR(32),
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(11) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value NUMERIC(10,2) NOT NULL
);


-- FACT TABLE
CREATE TABLE IF NOT EXISTS dimensional.orders_fact(
	order_fact_id SERIAL PRIMARY KEY,
	order_id CHAR(32) NOT NULL,
	order_item_id BIGINT NOT NULL,
    payment_sequential INT NOT NULL,
	customer_key BIGINT NOT NULL,
	geolocation_key BIGINT NOT NULL,
	time_key BIGINT NOT NULL,
	order_payment_key BIGINT NOT NULL,
	product_key BIGINT NOT NULL,
    order_status VARCHAR(15) NOT NULL,
	order_approved_at TIMESTAMP,
	product_value DECIMAL(10,2) NOT NULL,
	freight_value DECIMAl(10,2) NOT NULL,
    FOREIGN KEY (customer_key) REFERENCES dimensional.customers(customer_key),
    FOREIGN KEY (geolocation_key) REFERENCES dimensional.geolocation(geolocation_key),
    FOREIGN KEY (time_key) REFERENCES dimensional.dim_time(time_key),
	FOREIGN KEY (order_payment_key) REFERENCES dimensional.order_payments(order_payment_key),
	FOREIGN KEY (product_key) REFERENCES dimensional.products(product_key)
);

CREATE TABLE IF NOT EXISTS dimensional.fact_order_reviews(
	order_review_key SERIAL PRIMARY KEY,
	review_id CHAR(32) NOT NULL,
	order_id CHAR(32) NOT NULL,
	customer_key BIGINT NOT NULL,
	product_key BIGINT NOT NULL,
	time_key BIGINT NOT NULL,
	product_category_name VARCHAR(100) NOT NULL,
	review_score INT NOT NULL,
	FOREIGN KEY (customer_key) REFERENCES dimensional.customers (customer_key),
	FOREIGN KEY (product_key) REFERENCES dimensional.products (product_key),
	FOREIGN KEY (time_key) REFERENCES dimensional.dim_time (time_key)
);