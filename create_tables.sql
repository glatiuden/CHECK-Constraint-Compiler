DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS downloads CASCADE;

CREATE TABLE downloads (
	downloadsid int primary key,
    name varchar
);

CREATE TABLE customer (
	customerid int primary key,
	age int,
    downloadsid int,
	FOREIGN KEY (downloadsid) REFERENCES downloads(downloadsid)
);

INSERT INTO downloads(downloadsid, name) VALUES (1, 'Domainer');
INSERT INTO downloads(downloadsid, name) VALUES (2, 'Terminator');