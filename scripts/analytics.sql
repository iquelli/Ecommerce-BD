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
    BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY GROUPING SETS(SKU, (SKU, city, month), (SKU, city, day_of_month), (SKU, city, day_of_week))
ORDER BY SKU NULLS FIRST, city NULLS FIRST, day_of_week NULLS FIRST, day_of_month NULLS FIRST, month NULLS FIRST;

-- (2): Analyze the average daily sales value for all products in 2022, globally, by month and day of the
--      week.
WITH dates AS (
SELECT
  CAST(TO_CHAR(dates, 'DD') AS INT) AS day_of_month,
  CAST(TO_CHAR(dates, 'MM') AS INT) AS month,
  CAST(TO_CHAR(dates, 'YYYY') AS INT) AS year,
  TO_CHAR(dates, 'Day') AS day_of_week
FROM GENERATE_SERIES('2022-01-01'::DATE, '2022-12-31'::DATE, '1 day') AS dates)
SELECT month, day_of_week, AVG(daily_price) AS average_daily_sales
FROM
(SELECT dates.month, dates.day_of_week, dates.day_of_month, SUM(COALESCE(total_price, 0)) AS daily_price
FROM product_sales RIGHT JOIN dates
ON (dates.day_of_month=product_sales.day_of_month AND dates.month=product_sales.month AND dates.year=product_sales.year)
GROUP BY (dates.day_of_month, dates.month, dates.day_of_week)) AS daily_sales
GROUP BY GROUPING SETS(month, day_of_week, ())
ORDER BY day_of_week NULLS FIRST, month NULLS FIRST, day_of_week NULLS FIRST;
