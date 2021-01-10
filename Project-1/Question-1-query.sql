-- Initial QUERY:

SELECT YEAR( "o"."orderdate" ), MONTH( "o"."orderDate" ), "p"."productLine", SUM( "od"."quantityOrdered" ) "quantity_ordered" 
FROM "orderdetails" AS "od" 
JOIN "products" AS "p" 
ON "p"."productCode" = "od"."productCode" 
JOIN "orders" AS "o" 
ON "o"."orderNumber" = "od"."orderNumber" 
GROUP BY "p"."productline", YEAR( "o"."orderdate" ), MONTH( "o"."orderdate" ) 
ORDER BY YEAR( "o"."orderdate" ), MONTH( "o"."orderdate" ), SUM( "od"."quantityordered" ), "p"."productline"

-- SALES_VIEW:

SELECT "od"."productCode", YEAR( "o"."orderdate" ) "year", MONTH( "o"."orderDate" ) "month", 
"p"."productLine", SUM( "od"."quantityOrdered" ) "quantity_ordered" 
FROM "orderdetails" AS "od" 
JOIN "products" AS "p" ON "p"."productCode" = "od"."productCode" 
JOIN "orders" AS "o" ON "o"."orderNumber" = "od"."orderNumber" 
GROUP BY "p"."productline", YEAR( "o"."orderdate" ), MONTH( "o"."orderdate" ) 
ORDER BY YEAR( "o"."orderdate" ), MONTH( "o"."orderdate" ), SUM( "od"."quantityordered" ), "p"."productline"

-- ROC QUERY:

SELECT "A"."year", "A"."month", "A"."quantity_ordered", "A"."productLine", 
"B"."year", "B"."month", "B"."quantity_ordered", "B"."productline", 
( ( "A"."quantity_ordered" / "B"."quantity_ordered" ) - 1 ) * 100 "ROC_year_prior" 
FROM "sales_view" "A", "sales_view" "B" 
WHERE "A"."month" = "B"."month" 
AND "B"."year" = "A"."year" - 1 
AND "A"."productLine" = "B"."productLine"
