-- Kompression

-- Daten verkleinern
-- => Weniger Daten werden geladen, beim dekomprimieren wird CPU Leistung verwendet

-- Zwei verschieden Typen
-- Row Compression = 10-30%
-- Page Compression = 40-60%

USE Northwind;
SELECT  Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate, Orders.Freight, Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.Address, Customers.City, 
        Customers.Region, Customers.PostalCode, Customers.Country, Customers.Phone, Orders.OrderID, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, [Order Details].UnitPrice, 
        [Order Details].Quantity, [Order Details].Discount, Products.ProductID, Products.ProductName, Products.UnitsInStock
INTO Demo8.dbo.M004_Kompression
FROM    [Order Details] INNER JOIN
        Products ON Products.ProductID = [Order Details].ProductID INNER JOIN
        Orders ON [Order Details].OrderID = Orders.OrderID INNER JOIN
        Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
        Customers ON Orders.CustomerID = Customers.CustomerID

USE Demo8

INSERT INTO M004_Kompression
SELECT * FROM M004_Kompression
GO 8

SELECT COUNT(*) FROM M004_Kompression

SET STATISTICS TIME, IO ON

-- Rechtsklick auf die Tabelle => Speicher => Komprimierung verwalten

-- Ohne Kompression: logische Lesevorgänge: 28288, CPU-Zeit: 1547ms, verstrichene Zeit = 9284ms
SELECT * FROM M004_Kompression

USE [Demo8]
ALTER TABLE [dbo].[M004_Kompression] REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = ROW)

-- Row Kompression: logische Lesevorgänge: 15840, CPU-Zeit: 3235ms, verstrichene Zeit = 11601ms
SELECT * FROM M004_Kompression

USE [Demo8]
ALTER TABLE [dbo].[M004_Kompression] REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = PAGE)

-- Page Kompression: logische Lesevorgänge: 7584, CPU-Zeit: 3359ms, verstrichene Zeit = 10036ms
SELECT * FROM M004_Kompression
