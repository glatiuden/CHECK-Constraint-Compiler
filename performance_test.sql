-- Check constraint (set-up 1)
CREATE TABLE table1 (
	a int primary key,
    b int,
    c int CHECK (c < 500)
);

-- Custom Trigger (set-up 2)
CREATE TABLE table2 (
    a int primary key,
    b int,
    c int
);

Select add_constraint(
    'set-up_2_custom_constraint',
    '
    SELECT *
    FROM table2
    WHERE table2.c >= 500
    ',
    'EXISTS',
    'AFTER',
    'INSERT OR UPDATE',
    'DEFERRABLE',
    'INITIALLY DEFERRED',
    'table2',
    'c is greater or equal to 500'
);

-- Custom Trigger with 2 join (set-up 3) (table3 and table4 have fixed size of 5000 rows)
CREATE TABLE table3 (
    a int primary key,
    b int,
    c int
);

CREATE TABLE table4 (
    a int primary key,
    b int,
    c int
);

CREATE TABLE table5 (
    a int primary key,
    b int,
    c int
);

Select add_constraint(
    'set-up_3_custom_constraint',
    '
    SELECT *
    FROM table3, table4, table5
    WHERE table5.c >= 500 
        and table3.b = table4.b 
        and table3.a = table4.a
        and table4.a = table5.a
    ',
    'EXISTS',
    'AFTER',
    'INSERT OR UPDATE',
    'DEFERRABLE',
    'INITIALLY DEFERRED',
    'table5',
    'table5 c is greater or equal to 500 while table3 b is equal to table4 b'
);

-- Custom Trigger with aggregate function (set-up 4)
CREATE TABLE table6 (
    a int primary key,
    b int,
    c int
);

Select add_constraint(
    'set-up_4_custom_constraint',
    '
    SELECT COUNT(*)
    FROM table6
    GROUP BY table6.b
    HAVING AVG(table6.c) > 500
    ',
    'EXISTS',
    'AFTER',
    'INSERT OR UPDATE',
    'DEFERRABLE',
    'INITIALLY DEFERRED',
    'table6',
    'Group with same value b have c average higher than 500'
);


--Result (Timing in ms)
--10 rows 
--Check constraint (set-up 1) 1.169
--Custom Trigger (set-up 2) 1.470
--Custom Trigger with 2 join (set-up 3) 2.789
--Custom Trigger with aggregate function (set-up 4) 5.923 ms

--100 rows 
--Check constraint (set-up 1) 1.524
--Custom Trigger (set-up 2) 3.998
--Custom Trigger with 2 join (set-up 3) 4.688
--Custom Trigger with aggregate function (set-up 4) 10.918 ms

--500 rows 
--Check constraint (set-up 1) 3.756
--Custom Trigger (set-up 2) 37.989
--Custom Trigger with 2 join (set-up 3) 47.284 
--Custom Trigger with aggregate function (set-up 4) 193.807

--1000 rows 
--Check constraint (set-up 1) 6.958
--Custom Trigger (set-up 2) 127.073
--Custom Trigger with 2 join (set-up 3) 147.544
--Custom Trigger with aggregate function (set-up 4) 631.578

--10000 rows 
--Check constraint (set-up 1) 69.368
--Custom Trigger (set-up 2) 11023.933 (00:11.024)
--Custom Trigger with join (set-up 3) 11748.408 (00:11.748)
--Custom Trigger with aggregate function (set-up 4) 34940.309 (00:34.940)

--100000 rows
--Check constraint (set-up 1) 428.637 
--Custom Trigger (set-up 2) 1033922.569 (17:13.923)
--Custom Trigger with 2 join (set-up 3) 3369260.928 ms (56:09.261)
--Custom Trigger with aggregate function (set-up 4) 3376072.076 (56:16.072)



