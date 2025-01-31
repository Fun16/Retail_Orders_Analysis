-- SALES AND REVENUE ANALYSIS
-- Total Revenue Generated
SELECT SUM(sale_price * quantity) AS total_revenue
FROM orders;

-- Monthly Sales Trend
SELECT FORMAT(order_date, 'yyyy-MM') AS month, 
       SUM(sale_price * quantity) AS revenue
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY FORMAT(order_date, 'yyyy-MM');

-- Top 5 Best-Selling Products by Revenue
SELECT TOP 5 product_id, 
       SUM(sale_price * quantity) AS total_revenue
FROM orders
GROUP BY product_id
ORDER BY total_revenue DESC;

-- Top 5 Best-Selling Products by Quantity Sold
SELECT TOP 5 product_id, 
       SUM(quantity) AS total_quantity_sold
FROM orders
GROUP BY product_id
ORDER BY total_quantity_sold DESC;

-- Revenue by Customer Segment
SELECT segment, 
       SUM(sale_price * quantity) AS total_revenue
FROM orders
GROUP BY segment
ORDER BY total_revenue DESC;

--Top 5 highest selling products by region
with cte as (
select region,product_id,sum(sale_price) as sales
from orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as ps
from cte) A
where ps<=5

-- Month-by-month comparison of sales for 2022 vs 2023.
SELECT
    MONTH(order_date) AS month,
    SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price * quantity ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN YEAR(order_date) = 2023 THEN sale_price * quantity ELSE 0 END) AS sales_2023
FROM
    orders
WHERE
    YEAR(order_date) IN (2022, 2023)
GROUP BY
    MONTH(order_date)
ORDER BY
    month;

-- Subcategories by  percentage profit growth from 2022 to 2023

WITH cte AS (
    SELECT 
        sub_category,
        YEAR(order_date) AS order_year,
        SUM(sale_price * quantity) AS sales
    FROM 
        orders
    GROUP BY 
        sub_category, YEAR(order_date)
),
cte2 AS (
    SELECT 
        sub_category,
        SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
    FROM 
        cte
    GROUP BY 
        sub_category
)
SELECT 
    sub_category,
    sales_2022,
    sales_2023,
    ((sales_2023 - sales_2022) * 100) / sales_2022 AS percentage_growth
FROM 
    cte2
ORDER BY 
    percentage_growth DESC;








