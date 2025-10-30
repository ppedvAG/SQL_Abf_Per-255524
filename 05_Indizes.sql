-- Index

/*
	Table Scan: Durchsucht die gesamte Tabelle (langsam)
	Index Scan: Durchsucht bestimmte Inhalte der Tabelle (besser)
	Index Seek: Gehe in einen Index gezielt rein zu den Daten hin (am besten)

	Gruppierten Index / Clustered Index
	- Standardmäßig auf den Primärschlüssel erstellt
	- Normaler Index, welcher sich immer selbst sortiert
	- Bei INSERT/UPDATE werden die Daten herumgeschoben
	- Kann nur einmal pro Tabelle existieren

	Wann brauch ich einen Gruppierten Index:
	- Sehr gut bei Abfragen nach Bereichen und rel. Großen Ergebnismengen: <, >, between, like


	Nicht-gruppierte Index / Non-Clustered Index
	- Beliebig viele können erstellt werden
	- Zwei Komponenten: Schlüsselspalte, inkludierten Spalten
	- Anhand der Komponenten entscheidet die Datenbnak ob der Index verwendet werden soll

	Wann brauch ich den Nicht-gruppierten Index
	- Sehr gut bei Abfragen auf rel. eindeutige Werte bzw geringen Ergebnismengen
*/

SELECT * INTO M005_Index
FROM M004_Kompression

SET STATISTICS TIME, io ON

SELECT * FROM M005_Index

-- Table Scan:
-- Kosten: 21.82, logische Lesevorgänge: 28319, CPU-Zeit = 313ms, verstrichene Zeit = 1037ms
SELECT * FROM M005_Index
WHERE OrderID >= 11000

-- Neuen Index: NCIX_OrderID
-- Kosten 2.18,  logische Lesevorgänge: 2899, CPU-Zeit = 141ms, verstrichene Zeit = 1314ms
SELECT * FROM M005_Index
WHERE OrderID >= 11000

-- Index anschauen
SELECT OBJECT_NAME(OBJECT_ID), index_level, page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')
WHERE OBJECT_NAME(OBJECT_ID) = 'M005_Index'

-- index_level = 2 => Root Page
-- index_level = 1 => Zwischenebene
-- index_level = 0 => Blatt-Ebene (Leaf Level)

/*
	0 => Unterste Ebene => Datenseiten oder Zeiger bei Nonclustered Index
	1 => Verzweigung => Schlüsselwerte + Page-IDs auf untere Ebene
	2 => Root Ebene = Einstiegspunkt in den Indexbaum
*/


-- Auf bestimmte (häufige) Abfragen Indizes aufbauen
-- Table Scan:
-- Kosten: 21.42, logische Lesevorgänge: 28319, CPU-Zeit = 207ms, verstrichene Zeit = 137ms
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'

-- NCIX_ProductName
-- Kosten: 0.02, logische Lesevorgänge: 26, CPU-Zeit = 0ms, verstrichene Zeit = 145ms
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'

-- Hier fehlt die ContactName Spalte
-- Hier wird auch NCIX_ProductName durchgegangen
--Kosten: 0.02, logische Lesevorgänge: 26, CPU-Zeit = 0ms, verstrichene Zeit = 56ms
SELECT CompanyName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'

-- Hier gibts zusätzlich die Freight Spalte
-- Alle Inkludierten Spalten werden geholt + ein Lookup auf die fehlenden Daten die im Index nicht enthalten sind
-- Kosten: 4.94, logische Lesevorgänge: 1562, CPU-Zeit = 16ms, verstrichene Zeit = 82ms
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice, Freight
FROM M005_Index
WHERE ProductName = 'Chocolade'


-- Was würde passieren wenn ich kein WHERE habe
-- Index Scan
-- Kosten: 7.17, logische Lesevorgänge: 8859, CPU-Zeit = 625ms, verstrichene Zeit = 3917 ms
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index

-- Trotzdem Index Scan
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE UnitPrice > 20

-----------------------------------------------------------------------
-- Indizierte Sicht
-- View mit Index
-- Benötigt SCHEMABINDING
-- WITH SCHEMABINDING: Solange die View existiert, kann die Tabellenstruktur nicht verändert werden
ALTER TABLE M005_Index ADD id int identity
GO

CREATE VIEW Adressen WITH SCHEMABINDING
AS
SELECT id, CompanyName, Address, City, Region, PostalCode, Country 
FROM dbo.M005_Index

-- Clustered Index Scan
SELECT * FROM Adressen

-- Clustered Index Scan
-- Abfrage auf die Tabelle verwendet hier den Index der View
SELECT id, CompanyName, Address, City, Region, PostalCode, Country 
FROM dbo.M005_Index

-- Clustered Index Insert
INSERT INTO M005_Index 
VALUES (GETDATE(), GETDATE(), GETDATE(), 20.25, 'PPEDV', 'ppedv AG', 'Personalabteilung', 'Mr', 
'Marktler Straße 15B', 'Burghausen', 'Bayern', '84489', 'Germany', '1231247127', 125023, 10, 'Libowicz',
'Philipp', 'Trainer', 10.15, 32, 2, 4, 'Schulung', 230)

-- Clustered Index Delete
DELETE FROM M005_Index
WHERE id = 551681

