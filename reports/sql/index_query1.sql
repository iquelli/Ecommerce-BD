SELECT order_no
FROM orders
    JOIN contains USING (order_no)
    JOIN product USING (SKU)
WHERE price > 50 AND
    EXTRACT(YEAR FROM date) = 2023;
