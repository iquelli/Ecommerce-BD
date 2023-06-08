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
    JOIN product USING (SKU)
GROUP BY cust_no
HAVING SUM(qty * price) >= ALL(
    SELECT SUM(qty * price)
    FROM pay
        NATURAL JOIN contains
        NATURAL JOIN product
    GROUP BY cust_no
);

-- (2): What are the names of all the employees that processed packages everyday of 2022 in which
--      there was an order?
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
SELECT months.month AS month_2022, COUNT(orders.order_no) AS unpaid_orders_no
FROM pay
    RIGHT JOIN orders USING (order_no)
    RIGHT JOIN GENERATE_SERIES(1, 12) AS months(month) ON (pay.order_no IS NULL
        AND EXTRACT(YEAR FROM orders.date) = 2022
        AND EXTRACT(MONTH FROM orders.date) = months.month)
GROUP BY month_2022
ORDER BY month_2022;
