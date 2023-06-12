SELECT order_no, SUM(qty * price)
FROM contains
    JOIN product USING (SKU)
WHERE name LIKE 'A%'
GROUP BY order_no;
