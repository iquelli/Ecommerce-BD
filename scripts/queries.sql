--
--		File: queries.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Presents the corresponding SQL expression for each
--                   relational algebra query.

-- (1): List the names of all the customers who ordered packages containing products priced over €50 in the year 2023.
SELECT DISTINCT customer.name
FROM customer
    NATURAL JOIN package
    NATURAL JOIN contains
    INNER JOIN product USING (sku)
WHERE EXTRACT(YEAR FROM package.date)=2023
    AND price > 50;

-- (2): List the names of all the employees who work in warehouses and not in offices and processed packages in January 2023.
SELECT employee.name
FROM employee
    NATURAL JOIN process
    NATURAL JOIN package
    INNER JOIN works USING (ssn)
    NATURAL JOIN warehouse
WHERE EXTRACT(YEAR FROM package.date)=2023
    AND EXTRACT(MONTH FROM package.date)=1
EXCEPT
SELECT employee.name
FROM employee
    INNER JOIN works USING (ssn)
    NATURAL JOIN office;

-- (3): Indicate the name of the best selling product.
SELECT DISTINCT name
FROM contains
    NATURAL JOIN sale
    NATURAL JOIN product
GROUP BY sku, name
HAVING SUM(qty) >= ALL (
    SELECT SUM(qty)
    FROM contains
        NATURAL JOIN sale
    GROUP BY sku
);

-- (4): Indicate the total amount each sale made.
SELECT package_no, SUM(price * qty) AS total_val
FROM product
    NATURAL JOIN contains
    NATURAL JOIN sale
GROUP BY package_no;
