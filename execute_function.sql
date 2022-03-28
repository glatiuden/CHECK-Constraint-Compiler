Select add_constraint(
'r21',
'
SELECT c.customerid
FROM customers c NATURAL JOIN downloads d
WHERE d.name = ''Domainer'' AND c.age < 21
',
'EXISTS',
'AFTER',
'INSERT OR UPDATE',
'DEFERRABLE',
'INITIALLY DEFERRED',
'customers',
'An underaged customer cannot download Domainer'
);
