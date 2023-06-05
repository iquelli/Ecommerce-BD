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
    cust_no INT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255),
    CHECK (email LIKE '_%@_%\._%')
);

CREATE TABLE orders (
    order_no INT PRIMARY KEY,
    cust_no INT NOT NULL REFERENCES customer,
    date DATE NOT NULL
    -- order_no must exist in contains
);

CREATE TABLE pay (
    order_no INT PRIMARY KEY REFERENCES orders,
    cust_no INT NOT NULL REFERENCES customer
);

CREATE TABLE employee (
    ssn VARCHAR(20) PRIMARY KEY,
    tin VARCHAR(20) NOT NULL UNIQUE,
    bdate DATE,
    name VARCHAR NOT NULL,
    CHECK (EXTRACT(YEAR FROM AGE(bdate)) >= 18)
    -- age must be >= 18
);

CREATE TABLE process (
    ssn VARCHAR(20) REFERENCES employee,
    order_no INT REFERENCES orders,
    PRIMARY KEY (ssn, order_no)
);

CREATE TABLE department (
    name VARCHAR PRIMARY KEY
);

CREATE TABLE workplace (
    address VARCHAR PRIMARY KEY,
    lat NUMERIC(8, 6) NOT NULL,
    long NUMERIC(9, 6) NOT NULL,
    UNIQUE(lat, long),
    CHECK (lat >= -90 AND lat <= 90),
    CHECK (long >= -180 AND long <= 180)
    -- address must be in warehouse or office but not both
);

CREATE TABLE office (
    address VARCHAR(255) PRIMARY KEY REFERENCES workplace
);

CREATE TABLE warehouse (
    address VARCHAR(255) PRIMARY KEY REFERENCES workplace
);

CREATE TABLE works (
    ssn VARCHAR(20) REFERENCES employee,
    name VARCHAR(200) REFERENCES department,
    address VARCHAR(255) REFERENCES workplace,
    PRIMARY KEY (ssn, name, address)
);

CREATE TABLE product (
    sku VARCHAR(25) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description VARCHAR,
    price NUMERIC(10, 2) NOT NULL,
    ean NUMERIC(13) UNIQUE
);

CREATE TABLE contains (
    order_no INT REFERENCES orders,
    sku VARCHAR(25) REFERENCES product,
    qty INT NOT NULL,
    PRIMARY KEY (order_no, sku),
    CHECK (qty > 0)
);

CREATE TABLE supplier (
    tin VARCHAR(20) PRIMARY KEY,
    name VARCHAR(200),
    address VARCHAR(255),
    sku VARCHAR(25) REFERENCES product,
    date DATE
);

CREATE TABLE delivery (
    address VARCHAR(255) REFERENCES warehouse,
    tin VARCHAR(20) REFERENCES supplier,
    PRIMARY KEY (address, tin)
);
