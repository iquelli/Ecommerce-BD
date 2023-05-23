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
-- NOTE: The integrity constraints not captured by SQL
-- are presented as comments in the corresponding tables.

CREATE TABLE customer (
    cust_no INT,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255),
    name VARCHAR(255),
    street VARCHAR(255),
    building_no INT,
    postal_code VARCHAR(8)
    city VARCHAR(255)
    country VARCHAR(255)
    CONSTRAINT pk_customer PRIMARY KEY(cust_no)
);
CREATE TABLE order (
    -- (IC-2): Any order_no in order must exist in contains.
    order_no INT,
    date DATE NOT NULL,
    cust_no INT NOT NULL,
    CONSTRAINT pk_order PRIMARY KEY(order_no),
    CONSTRAINT fk_order_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
);
CREATE TABLE sale (
    -- (IC-1): Customers can only pay for the sale of an order they have placed themselves.
    order_no INT,
    cust_no INT,
    CONSTRAINT pk_sale PRIMARY KEY(order_no),
    CONSTRAINT fk_sale_order FOREIGN KEY(order_no)
        REFERENCES order(order_no),
    CONSTRAINT fk_sale_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
);
CREATE TABLE product (
    -- (IC-3): Any sku in product must exist in supplier.
    sku VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price MONEY NOT NULL,
    ean VARCHAR(255),
    CONSTRAINT pk_product PRIMARY KEY(sku)
);
CREATE TABLE contains (
    order_no INT,
    sku VARCHAR(255),
    qty INT NOT NULL,
    CONSTRAINT pk_contains PRIMARY KEY(order_no, sku),
    CONSTRAINT fk_contains_order FOREIGN KEY(order_no)
        REFERENCES order(order_no),
    CONSTRAINT fk_contains_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE supplier (
    tin VARCHAR(255),
    sku VARCHAR(255) NOT NULL,
    street VARCHAR(255),
    building_no INT,
    postal_code VARCHAR(8),
    city VARCHAR(255),
    country VARCHAR(255),
    name VARCHAR(255),
    supply_contract_date DATE,
    CONSTRAINT pk_supplier PRIMARY KEY(tin),
    CONSTRAINT fk_supplier_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE department (
    name VARCHAR(255),
    CONSTRAINT pk_department PRIMARY KEY(name),
);
CREATE TABLE workplace (
    street VARCHAR(255),
    building_no INT,
    postal_code VARCHAR(8),
    city VARCHAR(255),
    country VARCHAR(255),
    lat DECIMAL(9,6) NOT NULL,
    long DECIMAL(9,6) NOT NULL,
    UNIQUE(lat, long),
    CONSTRAINT pk_workplace PRIMARY KEY(street, building_no, postal_code, city, country)
);
CREATE TABLE warehouse (
    street VARCHAR(255),
    building_no INT,
    postal_code VARCHAR(8),
    city VARCHAR(255),
    country VARCHAR(255),
    CONSTRAINT pk_warehouse PRIMARY KEY(street, building_no, postal_code, city, country),
    CONSTRAINT fk_warehouse_workplace FOREIGN KEY(street, building_no, postal_code, city, country)
        REFERENCES workplace(street, building_no, postal_code, city, country)
);
CREATE TABLE delivery (
    sku VARCHAR(255),
    tin VARCHAR(255),
    address VARCHAR(255) NOT NULL,
    CONSTRAINT pk_delivery PRIMARY KEY(sku, tin),
    CONSTRAINT fk_delivery_product FOREIGN KEY(sku)
        REFERENCES product(sku),
    CONSTRAINT fk_delivery_supplier FOREIGN KEY(tin)
        REFERENCES supplier(tin)
);
CREATE TABLE office (
    street VARCHAR(255),
    building_no INT,
    postal_code VARCHAR(8),
    city VARCHAR(255),
    country VARCHAR(255),
    CONSTRAINT pk_office PRIMARY KEY(street, building_no, postal_code, city, country),
    CONSTRAINT fk_office_workplace FOREIGN KEY(street, building_no, postal_code, city, country)
        REFERENCES workplace(street, building_no, postal_code, city, country)
);
CREATE TABLE employee (
    -- (IC-4): Any ssn in employee must exist in works.
    ssn VARCHAR(255),
    tin VARCHAR(255) NOT NULL UNIQUE,
    b_date DATE NOT NULL,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_employee PRIMARY KEY(ssn)
);
CREATE TABLE works (
    ssn VARCHAR(255),
    street VARCHAR(255),
    building_no INT,
    postal_code VARCHAR(8),
    city VARCHAR(255),
    country VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_works PRIMARY KEY(ssn, address),
    CONSTRAINT fk_works_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_works_workplace FOREIGN KEY(street, building_no, postal_code, city, country)
        REFERENCES workplace(street, building_no, postal_code, city, country),
    CONSTRAINT fk_works_department FOREIGN KEY(name)
        REFERENCES department(name)
);
CREATE TABLE process (
    ssn VARCHAR(255),
    order_no INT,
    CONSTRAINT pk_process PRIMARY KEY(ssn, order_no),
    CONSTRAINT fk_process_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_process_order FOREIGN KEY(order_no)
        REFERENCES order(order_no)
);
