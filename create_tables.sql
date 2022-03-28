DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS downloads CASCADE;

CREATE TABLE downloads (
	downloadsid int primary key,
    name varchar
);

CREATE TABLE customers (
	customerid int primary key,
	age int,
    downloadsid int,
	FOREIGN KEY (downloadsid) REFERENCES downloads(downloadsid)
);

INSERT INTO downloads(downloadsid, name) VALUES (1, 'Domainer');
INSERT INTO downloads(downloadsid, name) VALUES (2, 'Terminator');