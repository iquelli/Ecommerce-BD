--
--		File: queries.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Presents the corresponding SQL expression for each
--                   question proposed in section 2.

-- (1): List the name(s) of the client(s) with the biggest value of paid orders.

SELECT customer.name
FROM customer
NATURAL JOIN pay
GROUP BY customer.cust_no
HAVING COUNT(pay.cust_no) = (
    SELECT COUNT(pay.cust_no) AS order_count
    FROM pay
    GROUP BY pay.cust_no
    ORDER BY order_count DESC
    LIMIT 1
);

-- (2): List the names of all the employees that processed packages everyday of 2022 in which there was a delivery.
SELECT employee.name
FROM employee;
-- ??????????????????????????

-- (3): List the amount of packages that were processed but not paid in each month of 2022.
SELECT EXTRACT(MONTH FROM orders.date) AS month, COUNT(*) AS "unpaid orders"
FROM orders
LEFT JOIN pay ON orders.order_no = pay.order_no
WHERE EXTRACT(YEAR FROM orders.date) = 2022 AND pay.order_no IS NULL
GROUP BY EXTRACT(MONTH FROM orders.date)
ORDER BY month ASC;