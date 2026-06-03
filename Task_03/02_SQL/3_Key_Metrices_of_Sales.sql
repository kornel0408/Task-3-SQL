-- -- *****************************************************************
-- 							TASK 3- SQL
-- *****************************************************************

-- What we find here?

-- 1.total customers
-- 2.Total Orders
-- 3.Total Sales
-- 4.Average Sales
-- 5.Total Quantity

SELECT * FROM order_items;
    
--  total_orders
	SELECT COUNT(order_id) as total_orders
    FROM orders;

-- Total Customers
	SELECT COUNT(DISTINCT user_id) as total_customers
    FROM orders;
    
    
-- Total Sales
	SELECT SUM(total_amount) as total_sales
    FROM orders
    WHERE order_status = "completed";

-- Average Sales
	SELECT avg(total_amount) as avg_sales
    FROM orders;
    
-- Total Quantity of products are sold
	SELECT SUM(quantity) as total_quantity
    FROM order_items o1
    JOIN orders o2
		on o1.order_id = o2.order_id
	WHERE order_status = "completed";


    
    
    

