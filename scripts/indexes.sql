--
--		File: indexes.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Presents the instructions for creating SQL indexes
--                   to improve query times for each of the cases below,
--                   explaining which operations would be optimized and how.

/* 6.1

*/

DROP INDEX IF EXISTS index_product_price;
DROP INDEX IF EXISTS index_orders_date;

CREATE INDEX index_product_price ON product USING BTREE(price);
CREATE INDEX index_orders_date ON orders USING HASH(date);

EXPLAIN ANALYZE
SELECT order_no
FROM orders
    JOIN contains USING (order_no)
    JOIN product USING (sku)
WHERE price > 50 AND
    EXTRACT(YEAR FROM date) = 2023;

/* 6.2

*/

DROP INDEX IF EXISTS index_product_name;

CREATE INDEX index_product_name ON product USING BTREE(name);

EXPLAIN ANALYZE
SELECT order_no, SUM(qty * price)
FROM contains
    JOIN product USING (sku)
WHERE name LIKE 'A%'
GROUP BY order_no;
