DROP INDEX IF EXISTS product_name_index;

CREATE INDEX product_name_index
    ON product USING BTREE(name);
