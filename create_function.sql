-- DROP FUNCTION IF EXISTS public.add_constraint(text, text, text, text, text, text, text, text, text);
-- DROP FUNCTION IF EXISTS validate_query(text);
-- DROP FUNCTION IF EXISTS validate_table_name(text);
-- DROP FUNCTION IF EXISTS validate_exists_arg(text);

CREATE OR REPLACE FUNCTION validate_table_name(tbl_name text)
	RETURNS BOOLEAN
	LANGUAGE PLPGSQL
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
$$;

CREATE OR REPLACE FUNCTION validate_query(query text)
	RETURNS BOOLEAN
	LANGUAGE plpgsql
AS $$
BEGIN
	EXECUTE query;
    RETURN TRUE;
	EXCEPTION WHEN others THEN 
        RETURN FALSE;
END
$$;

CREATE OR REPLACE FUNCTION validate_exists_arg(exists_arg text)
	RETURNS BOOLEAN
	LANGUAGE plpgsql
AS $$
BEGIN
	IF exists_arg ILIKE 'EXISTS' OR exists_arg ILIKE 'NOT EXISTS' THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END
$$;

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
	LANGUAGE PLPGSQL
AS $BODY$
DECLARE
	table_name_list constant text[] := regexp_split_to_array(NULLIF(tbl_name, ''), E'[,]{1}[\\s]?');
BEGIN
	ASSERT validate_exists_arg(exists_arg), FORMAT('"%s" is not a valid argument, either input "EXISTS" or "NOT EXISTS" (case insensitive)', exists_arg);
	ASSERT validate_query(trg_cond), 'Invalid condition entered, make sure it is a valid SQL query!';
	ASSERT (CARDINALITY(table_name_list) > 0), 'No table input detected, please input at least one existing table for the trigger to be applied to!';
	FOR counter IN ARRAY_LOWER(table_name_list, 1)..ARRAY_UPPER(table_name_list, 1) LOOP
		ASSERT validate_table_name(table_name_list[counter]), FORMAT('Table name "%s" does not exists!', table_name_list[counter]);
	END LOOP;

	EXECUTE FORMAT(
	'
		CREATE OR REPLACE FUNCTION t_%s()
		RETURNS TRIGGER 
		AS $$
		BEGIN
			IF %s (%s) THEN 
				RAISE EXCEPTION ''%s'';
			END IF;
			RETURN NULL;
		END;
		$$ 
		LANGUAGE plpgsql;
	',
	trg_name,
	exists_arg,
	trg_cond,
	error_msg
	);
		
		
	FOR counter IN ARRAY_LOWER(table_name_list, 1)..ARRAY_UPPER(table_name_list, 1) LOOP
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
			trg_name, table_name_list[counter], table_name_list[counter], 
			trg_name, table_name_list[counter],
			when_arg, event_arg,
			table_name_list[counter],
			defer_arg, timing_arg,
			trg_name
		);
	END LOOP;
	RETURN TRUE;
END
$BODY$;