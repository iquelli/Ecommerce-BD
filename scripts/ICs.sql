--
--		File: ICs.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Creates the triggers/checks for the integrity constraints
--                   commented in schema.

----------
-- (IC-1): An `employee` must be 18 or older.
----------

ALTER TABLE employee ADD CONSTRAINT check_employee_age
CHECK (EXTRACT(YEAR FROM AGE(bdate)) >= 18);

----------
-- (IC-2): A `workplace` is necessarily an `office` or a `warehouse` but cannot be both.
----------

/* Every workplace must be specialized as an office or a warehouse
   in the same transaction. */
CREATE OR REPLACE FUNCTION workplace_not_specialized() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT address FROM warehouse WHERE address = NEW.address
            UNION
        SELECT address FROM office WHERE address = NEW.address
    )
    THEN
        RAISE EXCEPTION 'The Workplace located at %, must either be an office or a warehouse.', NEW.address;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_workplace_not_specialized ON workplace;
CREATE CONSTRAINT TRIGGER trigger_workplace_not_specialized
    AFTER INSERT ON workplace
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION workplace_not_specialized();

/* When inserting into warehouse or office, make sure it is a non specialized
   workplace. When updating the subclasses, we need to update the workplace. */
CREATE OR REPLACE FUNCTION workplace_disjunction() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT address
        FROM warehouse
            JOIN office USING (address)
        WHERE address = NEW.address
    )
    THEN
        RAISE EXCEPTION 'A Workplace cannot be an office and a warehouse at the same time.';
    END IF;

    IF OLD.address IS NOT NULL
    THEN
        UPDATE workplace SET address = NEW.address WHERE address = OLD.address;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_warehouse_cannot_be_office ON warehouse;
DROP TRIGGER IF EXISTS trigger_office_cannot_be_warehouse ON office;
CREATE CONSTRAINT TRIGGER trigger_warehouse_cannot_be_office
    AFTER INSERT OR UPDATE ON warehouse
    FOR EACH ROW EXECUTE FUNCTION workplace_disjunction();
CREATE CONSTRAINT TRIGGER trigger_office_cannot_be_warehouse
    AFTER INSERT OR UPDATE ON office
    FOR EACH ROW EXECUTE FUNCTION workplace_disjunction();

/* When an office is removed, remove the workplace. */
CREATE OR REPLACE FUNCTION remove_office_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM workplace WHERE address = OLD.address;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_office_deps ON office;
CREATE TRIGGER trigger_remove_office_deps
    BEFORE DELETE ON office
    FOR EACH ROW EXECUTE FUNCTION remove_office_deps();

/* When a warehouse is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_warehouse_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM workplace WHERE address = OLD.address;
    DELETE FROM delivery WHERE address = OLD.address;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_warehouse_deps ON warehouse;
CREATE TRIGGER trigger_remove_warehouse_deps
    BEFORE DELETE ON warehouse
    FOR EACH ROW EXECUTE FUNCTION remove_warehouse_deps();

----------
-- (IC-3): An `order` must be in `contains`.
----------

/* Each new order must have at least one product in the `contains` relation. */
CREATE OR REPLACE FUNCTION order_not_in_contains() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT order_no FROM contains WHERE order_no = NEW.order_no)
    THEN
        RAISE EXCEPTION 'The Order (%) has to be associated with at least one product.', NEW.order_no;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_order_not_in_contains ON orders;
CREATE CONSTRAINT TRIGGER trigger_order_not_in_contains
    AFTER INSERT ON orders
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION order_not_in_contains();

/* When removing/updating an entry on `contains`, the order must still
   exist in the `contains` relation at least once. */
CREATE OR REPLACE FUNCTION update_order_contains() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT order_no FROM contains WHERE order_no = OLD.order_no)
    THEN
        RAISE EXCEPTION 'The Order (%) cannot become empty.', OLD.order_no;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_order_contains ON contains;
CREATE CONSTRAINT TRIGGER trigger_update_order_contains
    AFTER DELETE OR UPDATE ON contains
    FOR EACH ROW EXECUTE FUNCTION update_order_contains();

----------
-- Maintain Data Consistency
----------

ALTER TABLE customer ADD CONSTRAINT check_customer_email
CHECK (email LIKE '_%@_%\._%');

ALTER TABLE workplace ADD CONSTRAINT check_workplace_lat
CHECK (lat >= -90 AND lat <= 90);

ALTER TABLE workplace ADD CONSTRAINT check_workplace_long
CHECK (long >= -180 AND long <= 180);

ALTER TABLE contains ADD CONSTRAINT check_contains_qty
CHECK (qty > 0);

/* When a customer is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_customer_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM pay WHERE cust_no = OLD.cust_no;
    DELETE FROM orders WHERE cust_no = OLD.cust_no;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_customer_deps ON contains;
CREATE TRIGGER trigger_remove_customer_deps
    BEFORE DELETE ON customer
    FOR EACH ROW EXECUTE FUNCTION remove_customer_deps();

/* When an order is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_order_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM pay WHERE order_no = OLD.order_no;
    DELETE FROM contains WHERE order_no = OLD.order_no;
    DELETE FROM process WHERE order_no = OLD.order_no;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_order_deps ON contains;
CREATE TRIGGER trigger_remove_order_deps
    BEFORE DELETE ON orders
    FOR EACH ROW EXECUTE FUNCTION remove_order_deps();

/* When a product is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_product_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM contains WHERE SKU = OLD.SKU;
    DELETE FROM supplier WHERE SKU = OLD.SKU;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_product_deps ON contains;
CREATE TRIGGER trigger_remove_product_deps
    BEFORE DELETE ON product
    FOR EACH ROW EXECUTE FUNCTION remove_product_deps();

/* When a supplier is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_supplier_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM delivery WHERE TIN = OLD.TIN;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_supplier_deps ON contains;
CREATE TRIGGER trigger_remove_supplier_deps
    BEFORE DELETE ON supplier
    FOR EACH ROW EXECUTE FUNCTION remove_supplier_deps();

/* When a workplace is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_workplace_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM office WHERE address = OLD.address;
    DELETE FROM warehouse WHERE address = OLD.address;
    DELETE FROM works WHERE address = OLD.address;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_workplace_deps ON contains;
CREATE TRIGGER trigger_remove_workplace_deps
    BEFORE DELETE ON workplace
    FOR EACH ROW EXECUTE FUNCTION remove_workplace_deps();

/* When a department is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_department_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM works WHERE name = OLD.name;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_department_deps ON contains;
CREATE TRIGGER trigger_remove_department_deps
    BEFORE DELETE ON department
    FOR EACH ROW EXECUTE FUNCTION remove_department_deps();

/* When an employee is removed, remove everything that depends on it. */
CREATE OR REPLACE FUNCTION remove_employee_deps() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM process WHERE ssn = OLD.ssn;
    DELETE FROM works WHERE ssn = OLD.ssn;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_remove_employee_deps ON contains;
CREATE TRIGGER trigger_remove_employee_deps
    BEFORE DELETE ON employee
    FOR EACH ROW EXECUTE FUNCTION remove_employee_deps();
