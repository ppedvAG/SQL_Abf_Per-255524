/*
	Erstelle mir eine Partitionsfunktion "pf_Datum"
	- Partitionsschema: sch_Datum

	LEFT -->
	|--------------------------------|--------------------------------|
	2021						   2022								2023
*/


-- Partitionieren nach Datum: 2021-2022-2023

-- Tabelle anlegen M003_Umsatz
-- Spalten datum, umsatz
-- Schema auf Tabelle legen!

CREATE TABLE M003_Umsatz
(
	datum date,
	umsatz float
) ON sch_Datum(datum)

-- Tabelle Inhalt befuellen
BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 100000
BEGIN
		INSERT INTO M003_Umsatz VALUES
		(DATEADD(DAY, FLOOR(RAND() *1095), '01.01.2021'), RAND() * 1000)
		SET @i += 1
END 
COMMIT

-- Kontrolle der Partitionen