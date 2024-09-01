USE pizza_Sales;

-- The total number of orders placed

SELECT COUNT(order_id) as total_orders
FROM orders;

-- Total revenue generated from pizza sales.

SELECT ROUND(SUM(od.quantity * p.price),2) AS total_revenue
FROM order_details AS od 
JOIN pizzas AS p ON od.pizza_id = p.pizza_id;


-- The highest priced pizza

SELECT P.pizza_id, P.pizza_type_id, SUM(P.price) AS total_revenue
FROM pizzas AS P
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;


-- Most common pizza size orderd

SELECT 
    p.size, COUNT(od.quantity) AS most_common_pizza
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC;

-- Top 5 most orderd pizza types along with their quantities.

SELECT 
    pt.name AS Pizza_Name, COUNT(od.quantity) AS Quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- The total quantity of each pizza category ordered.


SELECT 
    pt.category, SUM(od.quantity) AS Total_Quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC;


-- Distribution of orders by hour of the day


SELECT 
    HOUR(time) O_clock, COUNT(order_id)
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;


-- The average number of pizzas ordered per day

SELECT 
    ROUND(AVG(Quantity), 0) AS Avg_number_of_Orders
FROM
    (SELECT 
        O.date, SUM(OD.quantity) AS Quantity
    FROM
        orders AS O
    JOIN order_details AS OD ON O.order_id = OD.order_id
    GROUP BY 1) AS Order_Quantity;


-- Top 3 most ordered pizza types based on revenue.

SELECT 
    PT.name,
    COUNT(OD.order_id) AS Ordered,
    SUM(OD.quantity * P.price) AS Revenue
FROM
    pizza_types AS PT
        JOIN
    pizzas AS P ON PT.pizza_type_id = P.pizza_type_id
        JOIN
    order_details AS OD ON P.pizza_id = OD.pizza_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 3;


-- % contribution of each pizza type to total revenue


SELECT 
    PT.category,
    ROUND(SUM(OD.quantity * P.price) / (SELECT 
                    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
                FROM
                    order_details AS od
                        JOIN
                    pizzas AS p ON od.pizza_id = p.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types AS PT
        JOIN
    pizzas AS P ON PT.pizza_type_id = P.pizza_type_id
        JOIN
    order_details AS OD ON P.pizza_id = OD.pizza_id
GROUP BY 1
ORDER BY 2 DESC;


-- The cumulative revenue generated over time

SELECT date, 
       SUM(Sales_per_Day) OVER (ORDER BY date) AS cum_revenue 
FROM (
    SELECT O.date, 
           SUM(OD.quantity * P.price) AS Sales_per_Day
    FROM orders AS O
    JOIN order_details AS OD ON O.order_id = OD.order_id
    JOIN Pizzas AS P ON OD.pizza_id = P.pizza_id
    GROUP BY O.date
) AS Revenue
ORDER BY date;


-- Top 3 most ordered pizza types based on revenue for each pizza category

SELECT category, name, revenue
FROM (
      SELECT name, category, revenue, 
          RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rankk
      FROM (
             SELECT PT.name, 
                    PT.category, SUM(OD.quantity * P.price) AS Revenue
			 FROM pizza_types AS PT
             JOIN pizzas AS P ON PT.pizza_type_id = P.pizza_type_id
			 JOIN order_details AS OD ON P.pizza_id = OD.pizza_id
			 GROUP BY PT.name, PT.category
           ) AS Top_rankers ) AS Fav_Pizzas
			 WHERE rankk <= 3;

-- Thank YOU 😊































