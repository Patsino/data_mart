CREATE TABLE factsupplierpurchases (
    purchaseid SERIAL PRIMARY KEY,
    supplierid INT, totalpurchaseamount DECIMAL,
    purchasedate DATE, numberofproducts INT,
    FOREIGN KEY (supplierid) REFERENCES dimsupplier(supplierid)
);

INSERT INTO factsupplierpurchases (supplierid, totalpurchaseamount, purchasedate, numberofproducts)
SELECT p.supplierid, 
    SUM(od.unitprice * od.qty) AS totalpurchaseamount, 
    CURRENT_DATE AS purchasedate, 
    COUNT(DISTINCT od.productid) AS numberofproducts
FROM staging_order_details od
JOIN staging_products p ON od.productid = p.productid
GROUP BY p.supplierid;

SELECT s.companyname,
    SUM(fsp.totalpurchaseamount) AS totalspend,
    EXTRACT(YEAR FROM fsp.purchasedate) AS year,
    EXTRACT(MONTH FROM fsp.purchasedate) AS month
FROM factsupplierpurchases fsp
JOIN dimsupplier s ON fsp.supplierid = s.supplierid
GROUP BY s.companyname, year, month
ORDER BY totalspend DESC;

SELECT s.companyname,
p.productname, AVG(od.unitprice) AS averageunitprice,
    SUM(od.qty) AS totalquantitypurchased,
    SUM(od.unitprice * od.qty) AS totalspend
FROM staging_order_details od
JOIN staging_products p ON od.productid = p.productid
JOIN dimsupplier s ON p.supplierid = s.supplierid
GROUP BY s.companyname, p.productname
ORDER BY s.companyname, totalspend DESC;

SELECT s.companyname, p.productname, SUM(od.unitprice * od.qty) AS totalspend
FROM staging_order_details od
JOIN staging_products p ON od.productid = p.productid
JOIN dimsupplier s ON p.supplierid = s.supplierid
GROUP BY s.companyname, p.productname
ORDER BY s.companyname, totalspend DESC
LIMIT 5;

CREATE TABLE factproductsales (
factsalesid SERIAL PRIMARY KEY,
dateid INT,
productid INT,
quantitysold INT,
totalsales DECIMAL(10,2),
FOREIGN KEY (dateid) REFERENCES dimdate(dateid),
FOREIGN KEY (productid) REFERENCES dimproduct(productid)
);

INSERT INTO factproductsales (dateid, productid, quantitysold, totalsales)
SELECT (SELECT dateid FROM dimdate WHERE date = s.orderdate) AS dateid,
    p.productid, sod.qty, 
    (sod.qty * sod.unitprice) AS totalsales
FROM staging_order_details sod
JOIN staging_orders s ON sod.orderid = s.orderid
JOIN staging_products p ON sod.productid = p.productid;

SELECT p.productname,
    SUM(fps.quantitysold) AS totalquantitysold,
    SUM(fps.totalsales) AS totalrevenue
FROM factproductsales fps
JOIN dimproduct p ON fps.productid = p.productid
GROUP BY p.productname
ORDER BY totalrevenue DESC
LIMIT 5;

SELECT c.categoryname, 
EXTRACT(YEAR FROM d.date) AS year,
EXTRACT(MONTH FROM d.date) AS month,
SUM(fps.quantitysold) AS totalquantitysold,
SUM(fps.totalsales) AS totalrevenue
FROM factproductsales fps
JOIN dimproduct p ON fps.productid = p.productid
JOIN dimcategory c ON p.categoryid = c.categoryid
JOIN dimdate d ON fps.dateid = d.dateid
GROUP BY c.categoryname, year, month, d.date
ORDER BY year, month, totalrevenue DESC;

SELECT p.productname, p.unitsinstock, p.unitprice,
    (p.unitsinstock * p.unitprice) AS inventoryvalue
FROM dimproduct p
ORDER BY inventoryvalue DESC;	
	
SELECT s.companyname,
    COUNT(DISTINCT fps.factsalesid) AS numberofsalestransactions,
    SUM(fps.quantitysold) AS totalproductssold,
    SUM(fps.totalsales) AS totalrevenuegenerated
FROM factproductsales fps
JOIN dimproduct p ON fps.productid = p.productid
JOIN dimsupplier s ON p.supplierid = s.supplierid
GROUP BY s.companyname
ORDER BY totalrevenuegenerated DESC

	
SELECT d.month, d.year, c.categoryname, SUM(fs.totalamount) AS totalsales
FROM factsales fs
JOIN dimdate d ON fs.dateid = d.dateid
JOIN dimcategory c ON fs.categoryid = c.categoryid
GROUP BY d.month, d.year, c.categoryname
ORDER BY d.year, d.month, totalsales DESC;	
	

SELECT d.quarter, d.year, p.productname, SUM(fs.quantitysold) AS totalquantitysold
FROM factsales fs
JOIN dimdate d ON fs.dateid = d.dateid
JOIN dimproduct p ON fs.productid = p.productid
GROUP BY d.quarter, d.year, p.productname
ORDER BY d.year, d.quarter, totalquantitysold DESC
LIMIT 5;
				
SELECT cu.companyname, SUM(fs.totalamount) AS totalspent, COUNT(DISTINCT fs.salesid) AS transactionscount
FROM factsales fs
JOIN dimcustomer cu ON fs.customerid = cu.customerid
GROUP BY cu.companyname
ORDER BY totalspent DESC;
				
SELECT e.firstname, e.lastname, COUNT(fs.salesid) AS numberofsales, SUM(fs.totalamount) AS totalsales
FROM factsales fs
JOIN dimemployee e ON fs.employeeid = e.employeeid
GROUP BY e.firstname, e.lastname
ORDER BY totalsales DESC;	
					
WITH monthlysales AS (
SELECT d.year, d.month, SUM(fs.totalamount) AS totalsales
    FROM factsales fs
    JOIN dimdate d ON fs.dateid = d.dateid
    GROUP BY d.year, d.month
),
monthlygrowth AS (
    SELECT year, month, totalsales,
    LAG(totalsales) OVER (ORDER BY year, month) AS previousmonthsales,
    (totalsales - LAG(totalsales) OVER (ORDER BY year, month)) / LAG(totalsales) OVER (ORDER BY year, month) AS growthrate
    FROM monthlysales
)
SELECT * FROM monthlygrowth;
