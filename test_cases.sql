TRUNCATE customers;

INSERT INTO customers(customerid, age, downloadsid) VALUES (1, 26, 1); -- valid
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 1); -- invalid
INSERT INTO customers(customerid, age, downloadsid) VALUES (2, 20, 2); -- valid

UPDATE customers SET age = 36 WHERE customerid = 1; -- valid
UPDATE customers SET age = 20 WHERE customerid = 1; -- invalid
UPDATE customers SET downloadsid = 1 WHERE customerid = 2; -- invalid

-- The next 2 query has to execute together
UPDATE customers SET age = 30 WHERE customerid = 2; -- valid
UPDATE customers SET downloadsid = 1 WHERE customerid = 2; -- valid