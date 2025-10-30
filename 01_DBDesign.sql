/*
	Normalerweise:
	1. Jede Zelle sollte einen Wert haben
	2. Jeder Datensatz sollte einen Primärschlüssel haben
	3. Keine Beziehungen zwischen nicht-Schlüssel Spalten

	Redundanzen verringern (Daten nicht doppelt speichern)

*/

/*
	Seite:
	8192B (8kB) Größe
	8060B für tatsächliche Daten
	132B für Management Daten
	8 Seiten = 1 Block

	Seiten werden immer 1:1 gelesen

	Max. 700 DS Seite
	Datensätze müssen komplett auf eine Seite passen
	Leerer Raum darf existieren, sollte aber minimiert werden
*/

-- dbcc: Database COnsole Commands
-- showcontig: Zeigt Seiteninformationen über ein Datenbankobjekt -> Seitendichte messen
dbcc showcontig('Orders')

-- Messungen
SET STATISTICS time, IO OFF -- Anzahl der Seiten,
			-- Dauer in MS von CPU und Gesamtausführungszeit

SELECT * FROM Orders

-- Ausführungsplan: Routenplan für meine Abfrage

CREATE DATABASE Demo8

USE Demo8

CREATE TABLE M001_Test1
(
	id int identity,
	test char(4100)
)

INSERT INTO M001_Test1
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test1') -- Seiten: 20000
-- Seitendichte von 50.79%


CREATE TABLE M001_Test2
(
	id int identity,
	test varchar(4100)
)

INSERT INTO M001_Test2
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test2') -- Seiten: 52
-- Id = 4 Byte
-- "XYZ" = 3 Byte + 2 Bytes = 5 Byte
-- plus interner Overhead pro Zeile (Row Header, Slot Array etc. ~ 7-10 Byte
-- 16-20 ~ pro Zeile raus

-- Beispielrechnung
-- 52 Seiten * 8192 Bytes = 425 984 Bytes gesamt
-- 95% Seitendichte => 0.95 x 425 984 Bytes
-- Pro Zeile etwa 20 Bytes * 20000 => 400 000 Bytes

-- Ab wann ist ein Füllgrad gut?
-- ab 70% ist OK
-- ab 80% ist gut
-- ab 90% ist Sehr gut

CREATE TABLE M001_TestDecimal
(
	id int identity,
	zahl decimal (2,1)
)

-- Schnellere Variante
BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 20000
BEGIN
		INSERT INTO M001_TestDecimal VALUES(2.2)
		SET @i += 1
END
COMMIT

USE Northwind

-- Tabelle: Orders
-- Alle Datensätze der Tabelle Orders aus dem Jahr 1997 (OrderDate)
-- Wichtig!: 3 Abfragen die auf dasselbe Ergebnis kommen

-- 1. logische Lesevorgänge: 22, CPU-Zeit: 0ms, verstrichene Zeit: 77ms
SELECT * FROM Orders
WHERE OrderDate LIKE '%1997%'

-- 2. logische Lesevorgänge: 22, CPU-Zeit: 0ms, verstrichene Zeit: 93ms
SELECT * FROM Orders -- 'YYYYMMDD'
WHERE OrderDate BETWEEN '01.01.1997' AND '31.12.1997 23:59:59.997'

-- 3. logische Lesevorgänge: 22, CPU-Zeit: 0ms, verstrichene Zeit: 68ms
SELECT * FROM Orders
WHERE YEAR(OrderDate) = 1997

SELECT @@VERSION