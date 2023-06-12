--
--		File: analytics.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Uses the view developed for question 4 to write two OLAP
--                   queries that lets us analyze information from the tables.

-- (1): Analyze the total sales quantity and values of each product in 2022, globally, by city, by month,
--      day of month and day of week.
WITH dpc AS (
    SELECT EXTRACT(YEAR FROM dates) AS year,
        EXTRACT(MONTH FROM dates) AS month,
        EXTRACT(DAY FROM dates) AS day_of_month,
        EXTRACT(DOW FROM dates) AS day_of_week, sku, city
    FROM GENERATE_SERIES('2022-01-01'::DATE, '2022-12-31'::DATE, '1 day') AS dates
        CROSS JOIN (SELECT DISTINCT sku FROM product_sales) AS skus,
            (SELECT DISTINCT city FROM product_sales) AS cities
)
SELECT dpc.SKU, dpc.city, dpc.month, dpc.day_of_month, dpc.day_of_week,
    SUM(COALESCE(qty, 0)) AS t_qty, SUM(COALESCE(total_price, 0)) AS t_value
FROM product_sales
    RIGHT JOIN dpc USING (year, month, day_of_month, sku, city)
GROUP BY GROUPING SETS (dpc.SKU, (dpc.SKU, dpc.city, dpc.month),
    (dpc.SKU, dpc.city, dpc.day_of_month), (dpc.SKU, dpc.city, dpc.day_of_week))
ORDER BY SKU, city, month, day_of_month, day_of_week;

-- (2): Analyze the average daily sales value for all products in 2022, globally, by month and day of the
--      week.
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
    RIGHT JOIN dates USING (month, day_of_month)
GROUP BY GROUPING SETS ((), dates.month, dates.day_of_week)
ORDER BY month, day_of_week;
