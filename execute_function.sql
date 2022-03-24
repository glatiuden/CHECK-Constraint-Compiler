Select func_test(
'r21',
'
SELECT c.customerid
FROM customer c NATURAL JOIN downloads d
WHERE d.name = ''Domainer'' AND c.age < 21
',
'customer',
'An underaged customer cannot download Domainer'
);
