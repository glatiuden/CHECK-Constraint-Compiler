-- DROP FUNCTION IF EXISTS public.add_constraint(text, text, text, text);
-- DROP FUNCTION IF EXISTS public.validate_query(text);
-- DROP FUNCTION IF EXISTS public.validate_table_name(text);

CREATE OR REPLACE FUNCTION validate_table_name(tbl_name text)
RETURNS BOOLEAN
AS $$
BEGIN 
    IF EXISTS (SELECT * 
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_NAME = tbl_name) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION validate_query(query text)
RETURNS BOOLEAN
AS $$
BEGIN
	EXECUTE query;
    RETURN TRUE;
	EXCEPTION WHEN others THEN 
        RETURN FALSE;
END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_constraint(trg_name text, trg_cond text, tbl_name text, error_msg text) 
RETURNS BOOLEAN 
AS $BODY$
BEGIN
	ASSERT validate_table_name(tbl_name), 'Table name does not exists!';
    ASSERT validate_query(trg_cond), 'Invalid condition entered, make sure it is a valid SQL query!';

	EXECUTE format(
	'
		CREATE OR REPLACE FUNCTION t_%s()
		RETURNS TRIGGER 
        AS $$
		BEGIN
		   IF 
				EXISTS (%s)
				THEN RAISE EXCEPTION ''%s'';
			END IF;
            RETURN NULL;
		END;
		$$ 
        LANGUAGE plpgsql;
	',
	trg_name,
	trg_cond,
    error_msg
	);
	
	
	EXECUTE format(
	'
        DROP TRIGGER IF EXISTS t_%s_%s ON %s;

		CREATE CONSTRAINT TRIGGER t_%s_%s
		AFTER INSERT OR UPDATE
		ON %s
		DEFERRABLE INITIALLY DEFERRED
		FOR EACH ROW
		EXECUTE PROCEDURE t_%s()
	',
		trg_name,
		tbl_name,
		tbl_name,
		trg_name,
		tbl_name,
		tbl_name,
		trg_name
	);

	RETURN TRUE;
END
$BODY$ 
LANGUAGE PLPGSQL;