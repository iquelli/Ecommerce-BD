--
--		File: ICs.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Creates the triggers for the integrity constraints
--                   commented in schema.

----------
-- (IC-1): An `employee` must be 18 or older.
----------
ALTER TABLE employee ADD CONSTRAINT check_employee_age
CHECK (EXTRACT(YEAR FROM AGE(bdate)) >= 18);

----------
-- (IC-2): A `workplace` is necessarily an `office` or `warehouse` but cannot be both.
----------
CREATE OR REPLACE FUNCTION workplace_is_not_valid()
RETURNS TRIGGER AS $$
BEGIN
    IF (
        EXISTS (SELECT 1 FROM office WHERE address = NEW.address) AND
        EXISTS (SELECT 1 FROM warehouse WHERE address = NEW.address)
        ) OR (
        NOT EXISTS (SELECT 1 FROM office WHERE address = NEW.address) AND
        NOT EXISTS (SELECT 1 FROM warehouse WHERE address = NEW.address)
        ) THEN
            RAISE EXCEPTION 'Workplace located at %, is not valid.', NEW.address;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER worplace_is_not_valid_trigger AFTER INSERT OR UPDATE ON workplace
FOR EACH ROW EXECUTE FUNCTION workplace_is_not_valid();

----------
-- (IC-3): An `order` must be in `contains`.
----------
CREATE OR REPLACE FUNCTION order_not_in_contains() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.order_no NOT IN (SELECT order_no FROM orders) THEN
        RAISE EXCEPTION 'Order % does not exist and can''t be associated with any products.', NEW.order_no;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER order_not_in_contains_trigger
AFTER INSERT OR UPDATE ON contains
FOR EACH ROW EXECUTE FUNCTION order_not_in_contains();
