-- Query Validator
CREATE OR REPLACE FUNCTION query_validator(name VARCHAR)
    RETURNS BOOLEAN
    LANGUAGE plpgsql 
AS
$$
BEGIN 
    IF EXISTS (SELECT * 
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_NAME = name) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END
$$;

-- Query Executor
CREATE OR REPLACE FUNCTION query_executor(name VARCHAR)
    RETURNS BOOLEAN
    LANGUAGE plpgsql 
AS
$$
BEGIN
	EXECUTE name;
    RETURN TRUE;
EXCEPTION
    WHEN others THEN 
        RETURN FALSE;
END
$$;

--Constraint Converter
CREATE OR REPLACE FUNCTION constraint_converter(my_constraint VARCHAR, constraint_table VARCHAR, my_error_message VARCHAR, my_constraint_name VARCHAR)
    RETURNS VARCHAR
    LANGUAGE plpgsql 
AS
$$
DECLARE
    result VARCHAR;
BEGIN
	ASSERT query_validator(constraint_table), 'Invalid Table';
    ASSERT query_executor(my_constraint), 'Invalid Constraint';
    result = FORMAT('
        CREATE OR REPLACE FUNCTION %s()
        RETURNS TRIGGER
        LANGUAGE plpgsql 
        AS ''
        BEGIN
        IF EXISTS (%s) THEN
        RAISE EXCEPTION ''''%s'''';
        ELSE RETURN NEW;
        END IF;
        END;'';
        CREATE CONSTRAINT TRIGGER tr_%s
        AFTER UPDATE
        ON %s
        DEFERRABLE INITIALLY DEFERRED
        FOR EACH ROW 
        EXECUTE PROCEDURE %s();'
        , my_constraint_name, my_constraint, my_error_message, my_constraint_name, constraint_table, my_constraint_name);
	RETURN result;
END;
$$




