CREATE SCHEMA IF NOT EXISTS relational;

-- CREATION OF TABLES OF RELATIONAL SCHEMA

-- TABLE GEOLOCATION
CREATE TABLE IF NOT EXISTS relational.geolocation(
	geolocation_zip_code_prefix VARCHAR(10) NOT NULL,
	geolocation_lat DOUBLE PRECISION NOT NULL,
	geolocation_lng DOUBLE PRECISION NOT NULL,
	geolocation_city VARCHAR(50) NOT NULL,
	geolocation_state VARCHAR(2) NOT NULL
);


-- TABLE CUSTOMERS
CREATE TABLE IF NOT EXISTS relational.customers(
	customer_id CHAR(32) PRIMARY KEY,
	customer_unique_id CHAR(32) NOT NULL,
	customer_zip_code_prefix VARCHAR(10) NOT NULL,
	customer_city VARCHAR(50) NOT NULL,
	customer_state CHAR(2) NOT NULL
);

-- TABLE SELLERS
CREATE TABLE IF NOT EXISTS relational.sellers(
	seller_id CHAR(32) PRIMARY KEY,
	seller_zip_code_prefix VARCHAR(10) NOT NULL,
	seller_city VARCHAR(50) NOT NULL,
	seller_state CHAR(2) NOT NULL
);

-- TABLE PRODUCTS
CREATE TABLE IF NOT EXISTS relational.products (
	product_id CHAR(32) PRIMARY KEY,
	product_category_name VARCHAR(100),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_lenght_cm INT,
	product_height_cm INT,
	product_width_cm INT
);


-- TABLE ORDERS
CREATE TABLE IF NOT EXISTS relational.orders (
    order_id CHAR(32) PRIMARY KEY,
    customer_id CHAR(32),
    order_status VARCHAR(15),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES relational.customers (customer_id)
);


-- TABLE ORDER_PAYMENTS
CREATE TABLE IF NOT EXISTS relational.order_payments (
    order_id CHAR(32),
    payment_sequential SERIAL,
    payment_type VARCHAR(11),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    FOREIGN KEY (order_id) REFERENCES relational.orders(order_id)
);


-- TABLE ORDER_ITEMS
CREATE TABLE IF NOT EXISTS relational.order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id BIGINT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date TIMESTAMP ,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    FOREIGN KEY (order_id) REFERENCES relational.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES relational.products(product_id),
    FOREIGN KEY (seller_id) REFERENCES relational.sellers(seller_id)
);

-- TABLE ORDER_REVIEWS
CREATE TABLE IF NOT EXISTS relational.order_reviews(
	review_id CHAR(32) ,
	order_id CHAR(32) NOT NULL,
	review_score INT,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date DATE,
	review_answer_timestamp TIMESTAMP,
	FOREIGN KEY (order_id) REFERENCES relational.orders(order_id)
);

CREATE TABLE IF NOT EXISTS relational.product_category_name_translation(
	product_category_name VARCHAR(100),
	product_Category_name_english VARCHAR(100)
);