--
--		File: schema.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: DDL that creates the database schema.

DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS pay CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS process CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS workplace CASCADE;
DROP TABLE IF EXISTS works CASCADE;
DROP TABLE IF EXISTS office CASCADE;
DROP TABLE IF EXISTS warehouse CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS contains CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS delivery CASCADE;

----------------------------------------
-- Table Creation
----------------------------------------
-- NOTE: The integrity constraints are presented
-- as comments in the corresponding tables
-- and some of them are presented in ICs.sql.

CREATE TABLE customer (
    cust_no INT,
    name VARCHAR(80) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255),
    CONSTRAINT pk_customer PRIMARY KEY(cust_no),
    CHECK (email LIKE '_%@_%\._%')
);
CREATE TABLE orders (
    order_no INT,
    cust_no INT NOT NULL,
    date DATE NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY(order_no),
    CONSTRAINT fk_orders_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
    -- order_no must exist in contains
);
CREATE TABLE pay (
    order_no INT,
    cust_no INT NOT NULL,
    CONSTRAINT pk_pay PRIMARY KEY(order_no),
    CONSTRAINT fk_pay_orders FOREIGN KEY(order_no)
        REFERENCES orders(order_no),
    CONSTRAINT fk_pay_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
);
CREATE TABLE employee (
    ssn VARCHAR(20),
    tin VARCHAR(20) NOT NULL UNIQUE,
    bdate DATE,
    name VARCHAR NOT NULL,
    CONSTRAINT pk_employee PRIMARY KEY(ssn),
    CHECK (EXTRACT(YEAR FROM AGE(bdate)) >= 18)
    -- age must be >= 18
);
CREATE TABLE process (
    ssn VARCHAR(20),
    order_no INT,
    CONSTRAINT pk_process PRIMARY KEY(ssn, order_no),
    CONSTRAINT fk_process_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_process_orders FOREIGN KEY(order_no)
        REFERENCES orders(order_no)
);
CREATE TABLE department (
    name VARCHAR,
    CONSTRAINT pk_department PRIMARY KEY(name)
);
CREATE TABLE workplace (
    address VARCHAR,
    lat NUMERIC(8,6) NOT NULL,
    long NUMERIC(9,6) NOT NULL,
    UNIQUE(lat, long),
    CONSTRAINT pk_workplace PRIMARY KEY(address),
    CHECK (lat >= -90 AND lat <= 90),
    CHECK (long >= -180 AND long <= 180)
    -- address must be in warehouse or office but not both
);
CREATE TABLE office (
    address VARCHAR(255),
    CONSTRAINT pk_office PRIMARY KEY(address),
    CONSTRAINT fk_office_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
);
CREATE TABLE warehouse (
    address VARCHAR(255),
    CONSTRAINT pk_warehouse PRIMARY KEY(address),
    CONSTRAINT fk_warehouse_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
);
CREATE TABLE works (
    ssn VARCHAR(20),
    name VARCHAR(200),
    address VARCHAR(255),
    CONSTRAINT pk_works PRIMARY KEY(ssn, name, address),
    CONSTRAINT fk_works_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_works_department FOREIGN KEY(name)
        REFERENCES department(name),
    CONSTRAINT fk_works_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
);
CREATE TABLE product (
    sku VARCHAR(25),
    name VARCHAR(200) NOT NULL,
    description VARCHAR,
    price NUMERIC(10,2) NOT NULL,
    ean NUMERIC(13) UNIQUE,
    CONSTRAINT pk_product PRIMARY KEY(sku),
    CHECK (price >= 0)
);
CREATE TABLE contains (
    order_no INT,
    sku VARCHAR(25),
    qty INT NOT NULL,
    CONSTRAINT pk_contains PRIMARY KEY(order_no, sku),
    CONSTRAINT fk_contains_orders FOREIGN KEY(order_no)
        REFERENCES orders(order_no),
    CONSTRAINT fk_contains_product FOREIGN KEY(sku)
        REFERENCES product(sku),
    CHECK (qty > 0)
);
CREATE TABLE supplier (
    tin VARCHAR(20),
    name VARCHAR(200),
    address VARCHAR(255),
    sku VARCHAR(25),
    date DATE,
    CONSTRAINT pk_supplier PRIMARY KEY(tin),
    CONSTRAINT fk_supplier_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE delivery (
    address VARCHAR(255),
    tin VARCHAR(20),
    CONSTRAINT pk_delivery PRIMARY KEY(address, tin),
    CONSTRAINT fk_delivery_warehouse FOREIGN KEY(address)
        REFERENCES warehouse(address),
    CONSTRAINT fk_delivery_supplier FOREIGN KEY(tin)
        REFERENCES supplier(tin)
);
