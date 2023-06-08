--
--		File: analytics.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Uses the view developed for question 4 to write two SQL
--                   queries that lets us analyze information from the tables.

-- (1): Analyze the total sales quantity and values of each product in 2022,  globally, by city, by
--      month, by day of the month, and by day of the week.
SELECT SKU, city, month, day_of_month, day_of_week,  SUM(qty) AS qty, SUM(total_price) AS total_price
FROM product_sales
WHERE MAKE_DATE(year, month, day_of_month)
    BETWEEN '2022-01-01' AND '2023-12-31'
GROUP BY GROUPING SETS(SKU, (SKU, city), (SKU, city, month, day_of_month, day_of_week))
ORDER BY SKU NULLS FIRST, day_of_month NULLS FIRST, month NULLS FIRST, city NULLS FIRST;

-- (2): Analyze the average daily sales value for all products in 2022, globally, by month and day of the
--      week.
SELECT month, day_of_week, AVG(daily_price) AS average_daily_sales
FROM
(SELECT month, day_of_week, day_of_month, SUM(total_price) AS daily_price
FROM  product_sales
WHERE MAKE_DATE(year, month, day_of_month)
    BETWEEN '2022-01-01' AND '2023-12-31'
GROUP BY (day_of_month, month, day_of_week)) as daily_product_sales
GROUP BY GROUPING SETS((day_of_week, day_of_month, month), ())
ORDER BY month NULLS FIRST, day_of_week NULLS FIRST;
