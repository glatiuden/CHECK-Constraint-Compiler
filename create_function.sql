-- DROP FUNCTION IF EXISTS add_constraint(text, text, text, text);
-- DROP FUNCTION IF EXISTS validate_query(text);
-- DROP FUNCTION IF EXISTS validate_table_name(text);

CREATE OR REPLACE FUNCTION validate_table_name(tbl_name text)
RETURNS BOOLEAN
AS $$
BEGIN 
    IF EXISTS (SELECT * 
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_NAME ILIKE tbl_name) THEN
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

CREATE OR REPLACE FUNCTION validate_exists_arg(exists_arg text)
RETURNS BOOLEAN
AS $$
BEGIN
	IF exists_arg ILIKE 'EXISTS' OR exists_arg ILIKE 'NOT EXISTS' THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_constraint(
	trg_name text, 
	trg_cond text, 
	exists_arg text,
	when_arg text,
	event_arg text,
	defer_arg text,
	timing_arg text,
	tbl_name text, 
	error_msg text) 
RETURNS BOOLEAN 
AS $BODY$
BEGIN
	ASSERT validate_table_name(tbl_name), FORMAT('Table name "%s" does not exists!', tbl_name);
    ASSERT validate_query(trg_cond), 'Invalid condition entered, make sure it is a valid SQL query!';
	ASSERT validate_exists_arg(exists_arg), FORMAT('"%s" is not a valid argument, either input "EXISTS" or "NOT EXISTS" (case insensitive)', exists_arg);

	EXECUTE FORMAT(
	'
		CREATE OR REPLACE FUNCTION t_%s()
		RETURNS TRIGGER 
        AS $$
		BEGIN
		   	IF EXISTS (%s) THEN 
		   		RAISE EXCEPTION ''%s'';
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
	
	
	EXECUTE FORMAT(
	'
        DROP TRIGGER IF EXISTS t_%s_%s ON %s;

		CREATE CONSTRAINT TRIGGER t_%s_%s
		%s %s
		ON %s
		%s %s
		FOR EACH ROW
		EXECUTE PROCEDURE t_%s()
	',
		trg_name, tbl_name, tbl_name, 
		trg_name, tbl_name,
		when_arg, event_arg,
		tbl_name,
		defer_arg, timing_arg,
		trg_name
	);

	RETURN TRUE;
END
$BODY$ 
LANGUAGE PLPGSQL;