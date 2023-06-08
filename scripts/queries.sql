--
--		File: queries.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Presents the corresponding SQL expression for each
--                   question proposed in section 2.

-- (1): What is the number and name of the client(s) with the biggest value of paid orders?
SELECT cust_no, customer.name
FROM customer
    NATURAL JOIN pay
    NATURAL JOIN contains
    JOIN product ON (contains.SKU = product.SKU)
GROUP BY cust_no
HAVING SUM(qty * price) >= ALL(
    SELECT SUM(qty * price)
    FROM pay
        NATURAL JOIN contains
        NATURAL JOIN product
    GROUP BY cust_no
);

-- (2): What are the names of all the employees that processed packages everyday of 2022 in which there was an order?
SELECT DISTINCT name
FROM employee
WHERE NOT EXISTS (
    SELECT date
    FROM orders
    WHERE EXTRACT(YEAR FROM date) = 2022
    EXCEPT
    SELECT date
    FROM orders
        NATURAL JOIN process
    WHERE process.ssn = employee.ssn
);

-- (3): How many orders were placed but not paid for in each month of 2022?
SELECT EXTRACT(MONTH FROM date) AS month_2022, COUNT(*) AS processed_unpaid_orders
FROM orders
    LEFT JOIN pay ON (orders.order_no = pay.order_no)
WHERE EXTRACT(YEAR FROM date) = 2022
    AND pay.order_no IS NULL
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY month_2022 ASC;
