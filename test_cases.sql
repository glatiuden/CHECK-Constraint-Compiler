-- Run these one by one
TRUNCATE customers;

-- The customers' table should be empty
SELECT * FROM customers;

-- VALID: new customer age 26 downloading 'Domainer'
INSERT INTO customers(customerid, age, downloadsid) VALUES (1, 26, 1);
SELECT * FROM customers;

-- INVALID: new customer aged 20 downloading 'Domainer'
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 1);
SELECT * FROM customers;

-- VALID: new customer aged 20 downloading 'Terminator'
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 2);
SELECT * FROM customers;

-- INVALID: renaming 'Terminator' to 'Domainer' where a customer under age 21 has downloaded
UPDATE downloads SET name = 'Domainer' WHERE downloadsid = 2;
SELECT * FROM downloads;

-- VALID: set customer that downloaded 'Domainer' before age to 36
UPDATE customers SET age = 36 WHERE customerid = 1;
SELECT * FROM customers;

-- INVALID: set customer that downloaded 'Domainer' before age to 20
UPDATE customers SET age = 20 WHERE customerid = 1;
SELECT * FROM customers;

-- INVALID: update underage customer to download 'Domainer'
UPDATE customers SET downloadsid = 1 WHERE customerid = 2; -- invalid
SELECT * FROM customers;

-- VALID: set underage customer to 30 and download 'Domainer'
-- The next 2 query has to execute together
UPDATE customers SET age = 30 WHERE customerid = 2; -- valid
UPDATE customers SET downloadsid = 1 WHERE customerid = 2; -- valid
SELECT * FROM customers;

-- VALID: drop the trigger and attempt to insert the underage customer to download 'Domainer'
DELETE FROM customers WHERE customerid = 2;
DROP FUNCTION IF EXISTS t_r21() CASCADE;
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 1);
SELECT * FROM customers;
