DROP INDEX IF EXISTS product_price_index;
DROP INDEX IF EXISTS order_date_index;

CREATE INDEX product_price_index
    ON product USING BTREE(price);
CREATE INDEX order_date_index
    ON orders USING HASH(EXTRACT(YEAR FROM date));
