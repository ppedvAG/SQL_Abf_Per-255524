-- MAXDOP
-- Maximum Degree of Parallelism / Maximaler Grad an Parallelität
-- Steuerung der Anzahl Prozessorkerne pro Abfrage 
-- Parallelisierung passiert von Alleine

-- Kostenschwellengrad der Parallelität: Gibt die Kosten an die eine Abfrage haben muss, um parallelisiert zu werden
-- Maximaler Grad an Parallelität: Gibt die maximale Anzahl Prozessorkerne an, die eine Abfrage verwenden darf

-- Verwendung: Prioritäten bei den Abfragen einzustellen

SET STATISTICS TIME, IO ON

-- Diese Abfrage wird parallelisiert durch die Zwei Schwarzen Pfeile in dem gelben Kreis
-- zu sehen im Abfrageplan
SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
-- CPU-Zeit: 981ms, verstrichene Zeit = 1507ms

SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 1)
-- CPU-Zeit: 703ms, verstrichene Zeit = 1916ms

SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 2)
-- CPU-Zeit: 718ms, verstrichene Zeit = 1356ms


SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 4)
-- CPU-Zeit: 1093ms, verstrichene Zeit = 1336ms