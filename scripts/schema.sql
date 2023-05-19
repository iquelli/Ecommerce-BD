--
--		File: schema.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: DDL that creates the database schema corresponding to the
--                   relational model developed.

DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS order CASCADE;
DROP TABLE IF EXISTS sale CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS ean_product CASCADE;
DROP TABLE IF EXISTS contains CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS workplace CASCADE;
DROP TABLE IF EXISTS warehouse CASCADE;
DROP TABLE IF EXISTS delivery CASCADE;
DROP TABLE IF EXISTS office CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS works CASCADE;
DROP TABLE IF EXISTS process CASCADE;

----------------------------------------
-- Table Creation
----------------------------------------

CREATE TABLE customer (
    cust_no,
    name,
    email UNIQUE,
    phone,
    address,
    CONSTRAINT pk_customer PRIMARY KEY(cust_no)
);
CREATE TABLE order (
    order_no,
    date,
    cust_no NOT NULL,
    CONSTRAINT pk_order PRIMARY KEY(order_no),
    CONSTRAINT fk_order_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
);
CREATE TABLE sale (
    order_no,
    cust_no,
    CONSTRAINT pk_sale PRIMARY KEY(order_no),
    CONSTRAINT fk_sale_order FOREIGN KEY(order_no)
        REFERENCES order(order_no),
    CONSTRAINT fk_sale_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
);
CREATE TABLE product (
    sku,
    name,
    description,
    price,
    CONSTRAINT pk_product PRIMARY KEY(sku)
);
CREATE TABLE ean_product (
    sku,
    ean,
    CONSTRAINT pk_ean_product PRIMARY KEY(sku),
    CONSTRAINT fk_ean_product_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE contains (
    order_no,
    sku,
    qty,
    CONSTRAINT pk_contains PRIMARY KEY(order_no, sku),
    CONSTRAINT fk_contains_order FOREIGN KEY(order_no)
        REFERENCES order(order_no),
    CONSTRAINT fk_contains_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE supplier (
    tin,
    sku NOT NULL,
    address,
    name,
    supply_contract_date,
    CONSTRAINT pk_supplier PRIMARY KEY(tin),
    CONSTRAINT fk_supplier_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE department (
    name,
    CONSTRAINT pk_department PRIMARY KEY(name),
);
CREATE TABLE workplace (
    address,
    lat,
    long,
    UNIQUE(lat, long)
    CONSTRAINT pk_workplace PRIMARY KEY(address),
);
CREATE TABLE warehouse (
    address,
    CONSTRAINT pk_warehouse PRIMARY KEY(address),
    CONSTRAINT fk_warehouse_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
);
CREATE TABLE delivery (
    sku,
    tin,
    address,
    CONSTRAINT pk_delivery PRIMARY KEY(sku, tin),
    CONSTRAINT fk_delivery_product FOREIGN KEY(sku)
        REFERENCES product(sku),
    CONSTRAINT fk_delivery_supplier FOREIGN KEY(tin)
        REFERENCES supplier(tin)
);
CREATE TABLE office (
    address,
    CONSTRAINT pk_office PRIMARY KEY(address),
    CONSTRAINT fk_office_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
);
CREATE TABLE employee (
    ssn,
    tin UNIQUE,
    bdate,
    name,
    CONSTRAINT pk_employee PRIMARY KEY(ssn)
);
CREATE TABLE works (
    ssn,
    address,
    name NOT NULL,
    CONSTRAINT pk_works PRIMARY KEY(ssn, address),
    CONSTRAINT fk_works_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_works_workplace FOREIGN KEY(address)
        REFERENCES workplace(address),
    CONSTRAINT fk_works_department FOREIGN KEY(name)
        REFERENCES department(name)
);
CREATE TABLE process (
    ssn,
    order_no,
    CONSTRAINT pk_process PRIMARY KEY(ssn, order_no),
    CONSTRAINT fk_process_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_process_order FOREIGN KEY(order_no)
        REFERENCES order(order_no)
);
