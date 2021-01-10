SELECT COUNT(jobtitle), jobtitle
FROM employees
GROUP BY jobtitle;

SELECT SUM(DISTINCT(customerNumber))
FROM customers;

SELECT shippeddate, comments
FROM orders
WHERE comments IS NOT NULL;

SELECT DISTINCT productline
FROM products;

SELECT SUM(od.quantityordered*od.priceeach) AS order_total, o.orderDate

-- YEARLY SALES
SELECT SUM(od.quantityordered*od.priceeach) AS order_total, o.orderDate
FROM orderdetails AS od
JOIN products AS p
ON p.productCode = od.productCode
JOIN orders as o
ON o.orderNumber = od.orderNumber
WHERE o.orderDate > '2020-01-01'
AND o.orderDate < '2020-12-31'
;

-- HIGHEST SOLD CATEGORY BY YEAR
SELECT SUM(od.quantityOrdered) AS Quantity_Ordered, p.productLine, o.orderDate
FROM orderdetails AS od
JOIN products AS p
ON p.productCode = od.productCode
JOIN orders as o
ON o.orderNumber = od.orderNumber
WHERE o.orderDate > '2020-01-01'
AND o.orderDate < '2020-12-31'
GROUP BY p.productLine
ORDER BY Quantity_Ordered
;

-- TOP 5 MOST PROFITABLE PRODUCTS
SELECT p.productLine, p.productname, od.productcode, od.priceeach, p.buyprice, SUM(od.priceeach-p.buyprice) AS total_margin
FROM orderdetails as od
JOIN products as p
ON p.productCode = od.productCode
GROUP BY od.productcode
ORDER BY total_margin DESC
LIMIT 5;

-- COUNT OF CUSTOMERS BY COUNTRY
SELECT COUNT(DISTINCT(customernumber)) AS count, country
FROM customers
GROUP BY country
ORDER BY count DESC
;


-- TOTAL SALES BY COUNTRY
SELECT COUNT(DISTINCT(c.customernumber)) AS count, c.country, SUM(od.quantityordered*od.priceeach) AS order_total
FROM customers as c
JOIN orders as o
ON o.customerNumber = c.customerNumber
JOIN orderdetails as od
ON od.orderNumber = o.orderNumber
JOIN products as p
ON p.productCode = od.productCode
GROUP BY country
ORDER BY count DESC
;

-- JOIN ALL TABLES ON KEYS
SELECT c.customerNumber, e.employeeNumber, of.officeCode,
pay.customerNumber, o.orderNumber, od.orderNumber,
p.productCode, pl.productline
FROM customers AS c
JOIN employees AS e
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN offices AS of
ON of.officeCode = e.officeCode
JOIN payments AS pay
on pay.customerNumber = c.customerNumber
JOIN orders AS o
ON o.customerNumber = c.customerNumber
JOIN orderdetails AS od
ON od.orderNumber = o.orderNumber
JOIN products AS p
ON p.productCode = od.productCode
JOIN productlines AS pl
ON pl.productLine = p.productLine
LIMIT 5
;

-- UNSHIPPED ORDERS WITHIN PAST n DAYS with COMMENTS
SELECT o.status, o.orderdate, o.comments
FROM customers AS c
JOIN orders AS o
ON o.customerNumber = c.customerNumber
WHERE o.status <> 'Shipped' 
AND o.orderDate >= DATE_ADD(CURDATE(), INTERVAL '-1000' DAY)
ORDER BY o.orderdate
;

-- TOP 5 CUSTOMERS BY SALES WITHIN n DAYS
SELECT c.customerName, c.contactFirstName, c.contactLastname,
c.phone, SUM(od.priceEach*od.quantityOrdered) AS total_ordered
FROM customers AS c
JOIN orders AS o
ON o.customerNumber = c.customerNumber 
JOIN orderdetails AS od
ON od.orderNumber = o.orderNumber
WHERE o.orderDate >= DATE_ADD(CURDATE(), INTERVAL '-100' DAY)
GROUP BY c.customerName
ORDER BY total_ordered DESC
LIMIT 5
;

-- ORDER AND INVENTORY INFORMATION FOR ORDERS REQUIRED IN n DAYS
SELECT c.customerName, o.requiredDate, o.status,
od.ordernumber, p.productcode, SUM(od.quantityordered), p.quantityInStock
FROM customers AS c
JOIN orders AS o
ON o.customerNumber = c.customerNumber
JOIN orderdetails AS od
ON od.orderNumber = o.orderNumber
JOIN products AS p
ON p.productCode = od.productCode
-- WHERE o.requiredDate >= DATE_ADD(CURDATE(), INTERVAL '-50' DAY)
WHERE o.requiredDate >= DATE_ADD(CURDATE(), INTERVAL '+5' DAY)
GROUP BY p.productcode
ORDER BY o.status, p.productcode
;


SELECT p.productLine, p.productName, c.country, SUM(od.quantityOrdered) AS QuantityOrdered, MONTH(o.shippedDate), YEAR(o.shippedDate)
FROM products as p
JOIN orderdetails as od
ON p.productCode = od.productCode
JOIN orders as o
ON o.orderNumber = od.orderNumber
JOIN customers as c
ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY QuantityOrdered, YEAR(o.shippedDate)
;

-- PAYMENTS AND SALES TOTAL - DID NOT DO WHAT I THOUGHT
SELECT c.customername, o.ordernumber, 
SUM(pay.amount) AS payment, SUM(od.quantityordered*od.priceeach) AS sales,
SUM(pay.amount) - SUM(od.quantityordered*od.priceeach) AS balance
FROM customers as c
LEFT JOIN orders AS o 
ON o.customernumber = c.customerNumber
LEFT JOIN payments as pay
ON pay.customernumber = c.customernumber
LEFT JOIN orderdetails as od
ON od.ordernumber = o.ordernumber
GROUP BY c.customernumber
ORDER BY sales
;

-- FOR EACH ORDER WE HAVE MULTIPLE PRODUCTS ORDERED
SELECT c.customername, o.ordernumber, od.productcode, od.quantityordered,
pay.amount
FROM customers as c
JOIN orders AS o 
ON o.customernumber = c.customerNumber
LEFT JOIN payments as pay
ON pay.customernumber = c.customernumber
LEFT JOIN orderdetails as od
ON od.ordernumber = o.ordernumber
LIMIT 20;

SELECT c.customername, o.ordernumber, o.orderdate, o.shippeddate,
pay.amount, pay.paymentdate, SUM(od.quantityordered*od.priceeach) AS sales
FROM customers as c
LEFT JOIN orders AS o 
ON o.customernumber = c.customerNumber
LEFT JOIN payments as pay
ON pay.customernumber = c.customernumber
LEFT JOIN orderdetails as od
ON od.ordernumber = o.ordernumber
WHERE o.shippeddate = pay.paymentdate
order by pay.paymentdate
LIMIT 100
;

CREATE VIEW sales_shipped AS
SELECT c.customernumber, c.customerName, 
SUM(od.priceEach*od.quantityOrdered) AS total_ordered,
o.shippeddate
FROM customers AS c
JOIN orders AS o
ON o.customerNumber = c.customerNumber 
JOIN orderdetails AS od
ON od.orderNumber = o.orderNumber
GROUP BY c.customerName, o.shippeddate
ORDER BY o.shippeddate
;

Select *
FROM sales_shipped AS ss
LEFT JOIN payments as pay
ON ss.customernumber = pay.customernumber
WHERE ss.shippeddate = pay.paymentdate
LIMIT 10
;

SELECT customernumber, paymentdate, SUM(amount)
FROM payments
GROUP BY customerNumber, paymentdate
ORDER BY paymentdate
;



