CREATE TABLE superstore
(RowID varchar,
OrderID varchar,
OrderDate varchar,
ShipDate varchar,
ShipMode varchar,
CustomerID varchar,
CustomerName varchar,
Segment varchar,
Country varchar,
City varchar,
State varchar,
PostalCode varchar,
Region varchar,
ProductID varchar,
Category varchar,
SubCategory varchar,
ProductName varchar,
Sales varchar,
Quantity varchar,
Discount varchar,
Profit varchar
);

COPY superstore 
FROM 'here was path to a csv file saved on my computer'
DELIMITER ','
CSV HEADER;

ALTER TABLE superstore
ADD COLUMN orderdate_v2 varchar,
ADD COLUMN shipdate_v2 varchar;

UPDATE superstore
SET orderdate_v2 = REPLACE(OrderDate, '/', '.');

UPDATE superstore
SET shipdate_v2 = REPLACE(ShipDate, '/', '.');

ALTER TABLE superstore
ADD COLUMN orderdate_v3 date,
ADD COLUMN shipdate_v3 date;

UPDATE superstore
SET orderdate_v3=TO_DATE(orderdate_v2,'MM/DD/YYYY');

UPDATE superstore
SET shipdate_v3=TO_DATE(shipdate_v2,'MM/DD/YYYY');

ALTER TABLE superstore 
DROP orderdate_v2,
DROP shipdate_v2,
DROP OrderDate,
DROP ShipDate;

ALTER TABLE superstore
ALTER COLUMN rowid TYPE INT USING (rowid::integer),
ALTER COLUMN sales TYPE DECIMAL USING (sales::DECIMAL),
ALTER COLUMN quantity TYPE INT USING (quantity::integer),
ALTER COLUMN discount TYPE DECIMAL USING (discount::DECIMAL),
ALTER COLUMN profit TYPE DECIMAL USING (profit::DECIMAL);

ALTER TABLE superstore 
RENAME shipdate_v3 TO shipdate;

ALTER TABLE superstore 
RENAME orderdate_v3 TO orderdate;