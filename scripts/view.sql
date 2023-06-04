--
--		File: view.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Creates a view that summarizes the most important
--                   information about product sales by combining information
--                   from different tables of the database schema.

-- The view has the following schema:
-- product_sales(sku, order_no, qty, total_price, year, month, day_of_month, day_of_week, city)

-- `sku`, `order_no`: correspond to the primary key of the contains table, but only orders that have been paid for should be included.
-- `qty`: corresponds to the table attribute contains.
-- `total_price`: product of qty and price.
-- `year`, `month`, `day_of_month`, `day_of_week`: attributes derived from the attribute date.
-- `city`: attribute derived from customer address.
-- NOTE: We use the EXTRACT() function to get days, months, etc, from dates and the SUBSTRING()
--       function with a POSIX pattern to extract the city after the zip code from the customer's address.

DROP VIEW IF EXISTS product_sales;

CREATE VIEW product_sales AS
SELECT
    product.sku,
    orders.order_no,
    contains.qty,
    contains.qty * product.price AS total_price,
    year,
    month,
    day_of_month,
    day_of_week,
    city
FROM
    contains
    JOIN pay ON (contains.order_no = pay.order_no)
    JOIN orders ON (contains.order_no = orders.order_no)
    JOIN product ON (contains.sku = product.sku)
    JOIN customer ON (pay.cust_no = customer.cust_no),
CAST(EXTRACT(YEAR FROM date) AS INT) AS year,
CAST(EXTRACT(MONTH FROM date) AS INT) AS month,
CAST(EXTRACT(DAY FROM date) AS INT) AS day_of_month,
TO_CHAR(date, 'Day') AS day_of_week,
CAST(SUBSTRING(address FROM '%-___, #"%#",%' FOR '#') AS VARCHAR) AS city;
