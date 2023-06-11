--
--		File: analytics.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Uses the view developed for question 4 to write two OLAP
--                   queries that lets us analyze information from the tables.

-- (1): Analyze the total sales quantity and values of each product in 2022,  globally, by city, by month,
-- day of the month and day of the week.
WITH all_comb AS (
  SELECT 
    CAST(TO_CHAR(dates, 'DD') AS INT) AS day_of_month,
    CAST(TO_CHAR(dates, 'MM') AS INT) AS month,
    CAST(TO_CHAR(dates, 'YYYY') AS INT) AS year,
    TO_CHAR(dates, 'Day') AS day_of_week,
    sku.sku, 
    city.city
  FROM GENERATE_SERIES('2022-01-01'::DATE, '2022-12-31'::DATE, '1 day') AS dates
  CROSS JOIN (SELECT DISTINCT sku FROM product_sales) AS sku,
  (SELECT DISTINCT city FROM product_sales) as city
)
SELECT
  all_comb.SKU,
  all_comb.city,
  all_comb.month,
  all_comb.day_of_month,
  all_comb.day_of_week,
  SUM(COALESCE(qty, 0)) AS qty,
  SUM(COALESCE(total_price, 0)) AS total_price
FROM
  product_sales
  RIGHT JOIN
    all_comb ON (
      all_comb.day_of_month = product_sales.day_of_month
      AND all_comb.month = product_sales.month
      AND all_comb.year = product_sales.year
      AND all_comb.sku = product_sales.sku
      AND all_comb.city = product_sales.city
    )
GROUP BY
  GROUPING SETS (
    all_comb.SKU,
    (all_comb.SKU, all_comb.city, all_comb.month),
    (all_comb.SKU, all_comb.city, all_comb.day_of_month),
    (all_comb.SKU, all_comb.city, all_comb.day_of_week)
  )
ORDER BY
  all_comb.SKU NULLS FIRST,
  all_comb.city NULLS FIRST,
  all_comb.day_of_week NULLS FIRST,
  all_comb.day_of_month NULLS FIRST,
  all_comb.month NULLS FIRST;

-- (2): Analyze the average daily sales value for all products in 2022, globally, by month and day of the
--      week.
WITH dates as(
SELECT 
  CAST(TO_CHAR(dates, 'DD') AS INT) AS day_of_month,
  CAST(TO_CHAR(dates, 'MM') AS INT) AS month,
  CAST(TO_CHAR(dates, 'YYYY') AS INT) AS year,
  TO_CHAR(dates, 'Day') AS day_of_week
FROM GENERATE_SERIES('2022-01-01'::DATE, '2022-12-31'::DATE, '1 day') AS dates)
SELECT month, day_of_week, AVG(daily_price) AS average_daily_sales
FROM
(SELECT 
  dates.month, 
  dates.day_of_week, 
  dates.day_of_month, 
  SUM(COALESCE(total_price, 0)) AS daily_price
  FROM 
    product_sales 
    RIGHT JOIN 
    dates ON(
      dates.day_of_month=product_sales.day_of_month 
      AND dates.month=product_sales.month 
      AND dates.year=product_sales.year
    )
  GROUP BY 
    (dates.day_of_month, dates.month, dates.day_of_week)) AS daily_sales 
GROUP BY 
  GROUPING SETS(
    month, 
    day_of_week, 
    ()
  )
ORDER BY 
  day_of_week NULLS FIRST,
  month NULLS FIRST, 
  day_of_week NULLS FIRST;
