-- -- *****************************************************************
-- 							TASK 3- SQL
-- ********************************************************************
-- What we find here?

-- 1.Total Products sold
-- 2.Total sale by brand
-- 3.Total Sale by category
-- 4.Average sales by category
-- 5.TOP 5 products by total quantity
-- 6.Top revenue-generating products in each city
-- 7.Do higher-rated products generate more sales?
-- 8.Worst products by ratings
-- 9 What % of total sales comes from top products?
-- 10.Least purchased product

-- 1.Total Products sold
	SELECT SUM(quantity)  as total_products
    FROM order_items oi
    JOIN succssed_orders s
		ON oi.order_id = s.order_id;
        
-- 2.Total sale by brand
	SELECT brand, SUM(item_total) as total
    FROM order_items oi
    JOIN products p
		ON p.product_id = oi.product_id
    JOIN succssed_orders s
		ON oi.order_id = s.order_id
	GROUP BY brand 
    ORDER BY total DESC;

-- 3.Total Sale by category
	SELECT category, SUM(item_total) as total
    FROM order_items oi
    JOIN products p
		ON p.product_id = oi.product_id
    JOIN succssed_orders s
		ON oi.order_id = s.order_id
	GROUP BY category
    ORDER BY total DESC;

-- 4.Average sales by category
	SELECT category, ROUND(AVG(item_total), 2) as average
    FROM order_items oi
    JOIN products p
		ON p.product_id = oi.product_id
    JOIN succssed_orders s
		ON oi.order_id = s.order_id
	GROUP BY category
    ORDER BY average DESC;

-- 5.TOP 5 products by total quantity
	SELECT product_name, COUNT(quantity) as total_quantity
    FROM order_items oi
    JOIN products p
		ON p.product_id = oi.product_id
    JOIN succssed_orders s
		ON oi.order_id = s.order_id
	GROUP BY product_name
    ORDER BY total_quantity DESC
    limit 5;

-- 6.Top revenue-generating products in each city
WITH CTE as(
	SELECT  
    city, product_name, COUNT(quantity) as total_quantity,
    DENSE_RANK() OVER(PARTITION BY city ORDER BY SUM(quantity) DESC) AS rnk
    FROM order_items oi
    JOIN products p
		ON p.product_id = oi.product_id
    JOIN succssed_orders s
		ON oi.order_id = s.order_id
	JOIN users u
		on u.user_id = oi.user_id
	GROUP BY city, product_name
    ORDER BY total_quantity DESC)
    
    SELECT city, product_name as 'most selling product'
    FROM CTE
    WHERE rnk = 1;

-- 7.Do higher-rated products generate more sales?
	SELECT p.product_name, sum(quantity) as total_quantity, SUM(item_total) as total, R.rating,
    CASE 
		WHEN r.rating > 4 THEN "High"
        WHEN r.rating >=3 THEN "medium"
        WHEN r.rating < 3 THEN "low"
	END as rating_Category
    FROM products p
    JOIN order_items oi
		on p.product_id = oi.product_id
	JOIN reviews r
		on oi.user_id = r.user_id
	GROUP BY p.product_name, R.rating
	ORDER BY TOTAL DESC, R.rating DESC;
    
-- 8 Which low-rated products still have high sales?
	WITH cte as(
	SELECT p.product_name, sum(quantity) as total_quantity, SUM(item_total) as total, R.rating,
    CASE 
		WHEN r.rating > 4 THEN "High"
        WHEN r.rating >=3 THEN "medium"
        WHEN r.rating < 3 THEN "low"
	END as rating_Category
    FROM products p
    JOIN order_items oi
		on p.product_id = oi.product_id
	JOIN reviews r
		on oi.user_id = r.user_id
	GROUP BY p.product_name, R.rating
	ORDER BY TOTAL DESC, R.rating DESC)

	SELECT product_name, total , rating
    FROM cte 
    WHERE rating_category = "low"
    and total > (SELECT AVG(total) FROM cte);
    

-- 9.What % of total sales comes from top products?
 WITH cte as(
	SELECT p.product_name, SUM(item_total) total,
    SUM(sum(item_total)) over() as overall_total
	FROM order_items oi
    JOIN products p
		ON p.product_id = oi.product_id
	JOIN orders o
		ON o.order_id = oi.order_id
	WHERE order_status = "completed"
	GROUP BY product_name
)
select product_name, total, round(total / overall_total * 100, 2) 
as 'contribution%'
FROM cte 
ORDER BY `contribution%`
DESC LIMIT 10;


-- 11.Least purchased product
SELECT p.product_name, COUNT(event_type) total_purchases
    FROM events e
    JOIN products p
		ON e.product_id = p.product_id
	WHERE e.event_type = 'purchase'
	GROUP By p.product_name
    ORDER BY total_purchases ;

	