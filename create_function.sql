-- DROP FUNCTION IF EXISTS func_test(text, text, text, text);

CREATE OR REPLACE FUNCTION func_test(trg_name text, trg_cond text, tbl_name text, error_msg text) 
RETURNS VOID 
AS $BODY$
BEGIN
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

END
$BODY$ 
LANGUAGE PLPGSQL;