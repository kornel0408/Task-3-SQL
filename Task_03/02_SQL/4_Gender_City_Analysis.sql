-- -- *****************************************************************
-- 							TASK 3- SQL
-- ********************************************************************

-- What we find here?

-- 1.total customers by gender
-- 2.Total sales by gender
-- 3.Average sales by gender
-- 4.top 5 cities by total sales
-- 5.Which cities have high order volume but low average order value?
-- 6.Total orders by city
-- 7.Top 5 Highest Spending Customers
-- 8.Who are repeat customers and how much revenue do they contribute?
-- 9.Which cities have high cancellation rates and what % of total orders?

-- total customers by gender
	SELECT gender, count(user_id) as total_count
    FROM users
    GROUP BY gender
    ORDER BY total_count DESC;
    
-- . Total sales by gender
	SELECT gender, sum(total_amount) AS total_sales
    FROM users u
	JOIN orders o
		ON u.user_id = o.user_id
	WHERE order_status = "completed"
	GROUP BY gender
    ORDER BY total_sales
    DESC;

-- . Average sales by gender
	SELECT gender, avg(total_amount) AS Avg_sales
    FROM users u
	JOIN orders o
		ON u.user_id = o.user_id
	WHERE order_status = "completed"
	GROUP BY gender
    ORDER BY avg_sales
    DESC;
    
-- .top 5 cities by total sales
	SELECT u.city, sum(total_amount)
    as total_sales
    FROM users u
    JOIN succssed_orders s
		ON u.user_id = s.user_id
	GROUP BY city
    ORDER BY total_sales DESC
    limit 5;

-- .Which cities have high order volume but low average order value?
	SELECT city, COUNT(quantity) as total_quantity, AVG(item_total) avg_order_value
    FROM users u
    JOIN order_items oi
    ON u.user_id = oi.user_id
    JOIN succssed_orders s
    on s.order_id = oi.order_id
    GROUP BY city
    ORDER BY total_quantity DESC, avg_order_value
    LIMIT 10;
    
-- Cities by total orders
	SELECT city, COUNT(order_id) as total_orders
    FROM users u
    JOIN succssed_orders s
		on u.user_id = s.user_id
	GROUP BY city
    ORDER BY total_orders
    DESC
    LIMIT 10;
    
-- Who are repeat customers and how much revenue do they contribute?
WITH repeated_customers AS (
	SELECT u.user_id,name, COUNT(o.order_id) as total_orders,
    sum(oi.item_total) as total_amount,
    SUM(sum(oi.item_total)) OVER() as overall_total
    FROM users u
    JOIN succssed_orders s
		ON u.user_id = s.user_id
	JOIN order_items oi 
		ON oi.order_id = s.order_id
	GROUP BY user_id, `name`
    )
    SELECT `name`, total_orders, total_amount, round((total_amount / overall_total) * 100, 2)
    as 'contribution(%)'
    FROM repeated_Customers
    ORDER BY total_orders
    DESC;

-- Top 5 Highest Spending Customers
	SELECT name, sum(total_amount) as total_amount
    FROM users u
	JOIN orders o
		ON u.user_id = o.user_id
	WHERE order_status = "completed"
	GROUP BY name
    ORDER BY total_amount DESC
    limit 5;
    
-- Which cities have high cancellation rates and what % of total orders?
WITH cancel_rate AS (
	SELECT u.city, COUNT(order_id) as total_cancelled_orders,
    count(COUNT(order_id)) OVER() as total_orders
    FROM orders o
    JOIN users u
		on o.user_id = u.user_id
	WHERE order_status = "cancelled"
    GROUP BY `city`
    ) 
	
    SELECT `city`, total_cancelled_orders, 
    round((total_cancelled_orders / total_orders * 100),2)
    AS cancellation_rate
    FROM cancel_rate
    ORDER BY cancellation_rate
    DESC;
