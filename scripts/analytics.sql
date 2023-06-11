--
--		File: analytics.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Uses the view developed for question 4 to write two OLAP
--                   queries that lets us analyze information from the tables.

-- (1): Analyze the total sales quantity and values of each product in 2022, globally, by city, by
--      month, day of month and day of week.
SELECT SKU, city, month, day_of_month, day_of_week, SUM(qty) AS t_qty, SUM(total_price) AS t_value
FROM product_sales
WHERE year = 2022
GROUP BY GROUPING SETS (SKU, (SKU, city, month), (SKU, city, day_of_month), (SKU, city, day_of_week))
ORDER BY SKU, city, month, day_of_month, day_of_week;

-- (2): Analyze the average daily sales value for all products in 2022, globally, by month and day of week.
WITH daily_sales AS (
    SELECT month, day_of_month, day_of_week, SUM(total_price) AS daily_values
    FROM product_sales
    WHERE year = 2022
    GROUP BY (month, day_of_month, day_of_week)
), dates AS (
    SELECT EXTRACT(MONTH FROM dates) AS month,
        EXTRACT(DAY FROM dates) AS day_of_month,
        EXTRACT(DOW FROM dates) AS day_of_week
    FROM GENERATE_SERIES('2022-01-01'::DATE, '2022-12-31'::DATE, '1 day') AS dates
)
SELECT dates.month, dates.day_of_week, AVG(COALESCE(daily_values, 0)) AS average_sales_2022
FROM daily_sales
    RIGHT JOIN dates ON (dates.month = daily_sales.month
        AND dates.day_of_month = daily_sales.day_of_month)
GROUP BY GROUPING SETS ((), dates.month, dates.day_of_week)
ORDER BY month, day_of_week;
