-- *****************************************************************
-- 							TASK 3- SQL
-- *****************************************************************

-- CREATING DATABASE
CREATE DATABASE elevevate_labs;
USE elevevate_labs;

-- CREATING TABLES   

CREATE TABLE events (
    event_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_timestamp DATETIME NOT NULL,

    FOREIGN KEY (user_id)
    REFERENCES users(user_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE order_items (
    order_item_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL 
    CHECK (quantity > 0),
    item_price DECIMAL(10,2) NOT NULL CHECK (item_price >= 0),
    item_total DECIMAL(10,2) NOT NULL CHECK (item_total >= 0),

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id),

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
);


CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5)
);

CREATE TABLE reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    rating DECIMAL(2,1) NOT NULL CHECK (rating BETWEEN 0 AND 5),
    review_text TEXT,
    review_date DATE NOT NULL,

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id),

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
);

CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    gender VARCHAR(10),
    city VARCHAR(100),
    signup_date DATE NOT NULL
);




