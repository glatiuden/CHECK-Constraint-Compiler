TRUNCATE customer;

INSERT INTO customer(customerid, age, downloadsid) VALUES (1, 26, 1); -- valid
INSERT INTO customer(customerid, age, downloadsid) VALUES (2, 20, 1); -- invalid
INSERT INTO customer(customerid, age, downloadsid) VALUES (2, 20, 2); -- valid

UPDATE customer SET age = 36 WHERE customerid = 1; -- valid
UPDATE customer SET age = 20 WHERE customerid = 1; -- invalid
UPDATE customer SET downloadsid = 1 WHERE customerid = 2; -- invalid

-- The next 2 query has to execute together
UPDATE customer SET age = 30 WHERE customerid = 2; -- valid
UPDATE customer SET downloadsid = 1 WHERE customerid = 2; -- valid