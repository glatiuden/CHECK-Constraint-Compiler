-- Run these one by one
TRUNCATE customers;

-- VALID: new customer age 26 downloading 'Domainer'
INSERT INTO customers(customerid, age, downloadsid) VALUES (1, 26, 1);

-- INVALID: new customer aged 20 downloading 'Domainer'
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 1);

-- VALID: new customer aged 20 downloading 'Terminator'
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 2);

-- INVALID: renaming 'Terminator' to 'Domainer' where a customer under age 21 has downloaded
UPDATE downloads SET name = 'Domainer' WHERE downloadsid = 2;

-- VALID: set customer that downlaoded 'Domainer' before age to 36
UPDATE customers SET age = 36 WHERE customerid = 1;

-- INVALID: set customer that downloaded 'Domainer' before age to 20
UPDATE customers SET age = 20 WHERE customerid = 1;

-- INVALID: update underage customer to download 'Domainer'
UPDATE customers SET downloadsid = 1 WHERE customerid = 2; -- invalid

-- VALID: set underage customer to 30 and download 'Domainer'
-- The next 2 query has to execute together
UPDATE customers SET age = 30 WHERE customerid = 2; -- valid
UPDATE customers SET downloadsid = 1 WHERE customerid = 2; -- valid