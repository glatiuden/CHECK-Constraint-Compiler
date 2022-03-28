DROP FUNCTION IF EXISTS t_r21() CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS downloads CASCADE;
DROP FUNCTION IF EXISTS public.add_constraint(text, text, text, text, text, text, text, text, text);
DROP FUNCTION IF EXISTS validate_query(text);
DROP FUNCTION IF EXISTS validate_table_name(text);
DROP FUNCTION IF EXISTS validate_exists_arg(text);