use pizza_sales;

-- KPIs
-- (1) Total Revenue
SELECT 
 round(SUM(o.quantity * p.price), 2) as total_revenue
FROM pizza_sales.order_details AS o
 JOIN pizza_sales.pizzas AS p  ON o.pizza_id = p.pizza_id
 group by null;
 
-- 2) Average Order Value total order value/order count

SELECT 
 round(SUM(o.quantity * p.price)/ COUNT(DISTINCT o.order_id),2) AS Average_Order_Value
FROM order_details AS o
 JOIN pizzas AS p ON o.pizza_id = p.pizza_id
 group by null;
 
-- 3) Total pizzas sold

 SELECT
  SUM(order_details.quantity) AS Total_Pizzas_Sold
FROM
  order_details
  group by null;
  
-- 4) Total Orders

SELECT
  COUNT(DISTINCT order_details.order_id) AS Total_Orders
FROM
  order_details
  group by null;
  
-- 5) Average Pizzas Per Order quantity sold/order IDs

SELECT
  ROUND(SUM(order_details.quantity)/COUNT(DISTINCT order_details.order_id),2) AS Average_Pizzas_Per_Order
FROM
  order_details
  group by null;

-- Sales Analysis Questions

-- 1) Daily Trends for Total Orders

SELECT 
    DAYNAME(date) AS WeekDay,
    COUNT(DISTINCT order_id) AS TotalOrders
FROM 
    orders
GROUP BY 
    WeekDay
ORDER BY 
    TotalOrders DESC;
    
-- 2) Hourly TrendS for Total Orders

SELECT 
    hour(time) AS hours,
    COUNT(DISTINCT order_id) AS TotalOrders
FROM 
    orders
GROUP BY 
    1
ORDER BY 
    TotalOrders DESC;


-- 3) Percentage of Sales by Pizza Category

-- (a: calculate total revenue per category % sales calculated as (a:/total revenue) * 100)

SELECT 
    category,
    ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    category;
    
-- 4) Percentage of Sales by Pizza Size

SELECT 
    size
    ,ROUND(SUM(quantity * price), 2) AS revenue
    ,ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    size 
order by percentage_of_sales desc ;

-- 5) Total Pizzas Sold by Pizza Category

select category ,sum(quantity) AS Total_Sold
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category;

-- 6) Top 5 Best Sellers by Total Pizzas Sold

SELECT name,SUM(quantity) AS total_quantity_sold
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity_sold DESC
limit 5;

-- 7) Bottom 5 Best Sellers by Total Pizzas Sold

SELECT name,SUM(quantity) AS total_quantity_sold
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity_sold ASC
limit 5;
