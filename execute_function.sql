-- VALID: Trivial Example - any customer aged below 21 downloading 'Domainer' will trigger the function
-- EXPECTED RESULT: true
Select add_constraint(
    'r21',
    '
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = ''Domainer'' AND c.age < 21
    ',
    'EXISTS',
    'INSERT OR UPDATE',
    'DEFERRABLE INITIALLY DEFERRED',
    'customers, downloads',
    'An underaged customer cannot download Domainer'
);


-- INVALID: invalid SQL query as condition
-- EXPECTED RESULT: Invalid condition entered, make sure it is a valid SQL query!
Select add_constraint(
    'r21',
    '
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = ''Domainer'' AND c.age < ABC
    ',
    'EXISTS',
    'INSERT OR UPDATE',
    'DEFERRABLE INITIALLY DEFERRED',
    'customers, downloads',
    'An underaged customer cannot download Domainer'
);

-- INVALID: EXIST sytax, only [EXISTS / NOT EXISTS] (case insensitive)
-- EXPECTED RESULT: "HAS" is not a valid argument, either input "EXISTS" or "NOT EXISTS" (case insensitive)
Select add_constraint(
    'r21',
    '
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = ''Domainer'' AND c.age < 21
    ',
    'HAS',
    'INSERT OR UPDATE',
    'DEFERRABLE INITIALLY DEFERRED',
    'customers, downloads',
    'An underaged customer cannot download Domainer'
);

-- INVALID: DEFER syntax, only [DEFERRABLE | NOT DEFERRABLE] [INITIALLY IMMEDIATE | INITIALLY DEFERRED] (case insensitive)
-- EXPECTED RESULT: syntax error at or near "DEFERRABLE"
Select add_constraint(
    'r21',
    '
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = ''Domainer'' AND c.age < 21
    ',
    'EXISTS',
    'INSERT OR UPDATE',
    'DEFERRABLE INITIALLY DEFERRABLE',
    'customers, downloads',
    'An underaged customer cannot download Domainer'
);

-- INVALID: No table entered by user
-- EXPECTED RESULT: No table input detected, please input at least one existing table for the trigger to be applied to!
Select add_constraint(
    'r21',
    '
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = ''Domainer'' AND c.age < 21
    ',
    'EXISTS',
    'INSERT OR UPDATE',
    'DEFERRABLE INITIALLY DEFERRED',
    '',
    'An underaged customer cannot download Domainer'
);

-- INVALID: Table entered by user does not exists
-- EXPECTED RESULT: Table name "downloadsssss" does not exists!
Select add_constraint(
    'r21',
    '
    SELECT c.customerid
    FROM customers c NATURAL JOIN downloads d
    WHERE d.name = ''Domainer'' AND c.age < 21
    ',
    'EXISTS',
    'INSERT OR UPDATE',
    'DEFERRABLE INITIALLY DEFERRED',
    'customers, downloadsssss',
    'An underaged customer cannot download Domainer'
);