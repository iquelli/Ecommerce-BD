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
DROP TABLE IF EXISTS package CASCADE;
DROP TABLE IF EXISTS sale CASCADE;
DROP TABLE IF EXISTS pay CASCADE;
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
    name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone NUMERIC(15),
    address VARCHAR(255),
    CONSTRAINT pk_customer PRIMARY KEY(cust_no)
);
CREATE TABLE package (
    package_no INT,
    date DATE NOT NULL,
    cust_no INT NOT NULL,
    CONSTRAINT pk_package PRIMARY KEY(package_no),
    CONSTRAINT fk_package_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
    -- (IC-6): any package_no in package must exist in contains
);
CREATE TABLE sale (
    package_no INT,
    CONSTRAINT pk_sale PRIMARY KEY(package_no),
    CONSTRAINT fk_sale_package FOREIGN KEY(package_no)
        REFERENCES package(package_no)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE pay (
    package_no INT,
    cust_no INT NOT NULL,
    CONSTRAINT pk_pay PRIMARY KEY(package_no),
    CONSTRAINT fk_pay_sale FOREIGN KEY(package_no)
        REFERENCES sale(package_no),
    CONSTRAINT fk_pay_customer FOREIGN KEY(cust_no)
        REFERENCES customer(cust_no)
    -- (IC-1): cust_no must exist in the package identified by package_no
);
CREATE TABLE product (
    sku VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC(18,2) NOT NULL,
    ean VARCHAR(13),
    CONSTRAINT pk_product PRIMARY KEY(sku)
    -- (IC-8): any sku in product must exist in supplier
);
CREATE TABLE contains (
    package_no INT,
    sku VARCHAR(255),
    qty INT NOT NULL,
    CONSTRAINT pk_contains PRIMARY KEY(package_no, sku),
    CONSTRAINT fk_contains_package FOREIGN KEY(package_no)
        REFERENCES package(package_no),
    CONSTRAINT fk_contains_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE supplier (
    tin VARCHAR(20),
    name VARCHAR(255),
    address VARCHAR(255),
    sku VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    CONSTRAINT pk_supplier PRIMARY KEY(tin),
    CONSTRAINT fk_supplier_product FOREIGN KEY(sku)
        REFERENCES product(sku)
);
CREATE TABLE department (
    name VARCHAR(255),
    CONSTRAINT pk_department PRIMARY KEY(name)
);
CREATE TABLE workplace (
    address VARCHAR(255),
    lat NUMERIC(8,6) NOT NULL,
    long NUMERIC(9,6) NOT NULL,
    UNIQUE(lat, long),
    CONSTRAINT pk_workplace PRIMARY KEY(address)
);
CREATE TABLE warehouse (
    address VARCHAR(255),
    CONSTRAINT pk_warehouse PRIMARY KEY(address),
    CONSTRAINT fk_warehouse_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
        ON DELETE CASCADE ON UPDATE CASCADE
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
CREATE TABLE office (
    address VARCHAR(255),
    CONSTRAINT pk_office PRIMARY KEY(address),
    CONSTRAINT fk_office_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE employee (
    ssn VARCHAR(20),
    tin VARCHAR(20) NOT NULL UNIQUE,
    birth_date DATE,
    name VARCHAR(255),
    CONSTRAINT pk_employee PRIMARY KEY(ssn)
    -- (IC-11): any ssn in employee must exist in works
);
CREATE TABLE works (
    ssn VARCHAR(20),
    name VARCHAR(255),
    address VARCHAR(255),
    CONSTRAINT pk_works PRIMARY KEY(ssn, name, address),
    CONSTRAINT fk_works_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_works_department FOREIGN KEY(name)
        REFERENCES department(name),
    CONSTRAINT fk_works_workplace FOREIGN KEY(address)
        REFERENCES workplace(address)
);
CREATE TABLE process (
    ssn VARCHAR(20),
    package_no INT,
    CONSTRAINT pk_process PRIMARY KEY(ssn, package_no),
    CONSTRAINT fk_process_employee FOREIGN KEY(ssn)
        REFERENCES employee(ssn),
    CONSTRAINT fk_process_package FOREIGN KEY(package_no)
        REFERENCES package(package_no)
);
