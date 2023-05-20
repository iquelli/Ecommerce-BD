--
--		File: queries.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Presents the corresponding SQL expression for each
--                   relational algebra query.

-- 1: List the names of all the customers who placed orders containing products priced over €50 in the year 2023.
SELECT DISTINCT customer.name
FROM customer
    NATURAL JOIN order
    NATURAL JOIN contains
    INNER JOIN product ON contains.sku = product.sku
WHERE date >= '2023/01/01'
    AND date <= '2023/12/31'
    AND price > 50;

-- 2: List the names of all the employees who work in warehouses and not in offices and processed orders in January 2023.
(SELECT DISTINCT employee.name
FROM employee
    NATURAL JOIN process
    NATURAL JOIN order
    NATURAL JOIN works
    NATURAL JOIN warehouse
WHERE date >= '2023/01/01'
    AND date <= '2023/01/31'
)
EXCEPT
(SELECT employee.name
FROM employee
    NATURAL JOIN works
    NATURAL JOIN office
);

-- 3: Indicate the name of the best selling product.
SELECT DISTINCT name
FROM product
    NATURAL JOIN contains
    NATURAL JOIN sale
GROUP BY sku
HAVING SUM(qty) >= ALL (
    SELECT SUM(qty) FROM contains
    GROUP BY sku
);

-- 4: Indicate the total amount each sale made.
SELECT order_no, SUM(product.price) AS total_val
FROM product
    NATURAL JOIN contains
    NATURAL JOIN sale
GROUP BY order_no;
