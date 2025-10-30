USE Demo8
/*
	
	Dateigruppen:
	Datenbank aufteilen auf mehrere Dateien, und verschiedene Datentr‰ger in weiterer Folge
	[Primary]: Hauptgruppe, existiert immer, enth‰lt standardm‰ﬂig alle Dateien

	Das Hauptfile hat die Endung .mdf
	Weitere Dateien haben die Endung .ndf
	Log Files haben die Endung .ldf
*/

/*
	Rechtsklick auf die Datenbank => Eigenschaften
	Dateigruppen
		- Hinzuf¸gen, Name vergeben
	Datei
		- Hinzuf¸gen, Name vergeben, Dateigruppe vergeben, Automatische Grˆﬂe setzen etc....
*/

CREATE TABLE M002_FG2
(
	id int identity,
	test char(4100)
)

INSERT INTO M002_FG2
VALUES ('XYZ')
GO 20000


-- Wie verschiebe ich eine Tabelle auf eine andere Dateigruppe?
-- Neu erstellen, daten verschieben, alte Tabelle lˆschen

CREATE TABLE M002_FG2_2
(
	id int,
	test char(4100)
) ON [Secondary]


INSERT INTO M002_FG2_2
SELECT * FROM M002_FG2

-- Identity hinzuf¸gen per Entwerfen
-- Extras => Optionen => Designer => Speichern von ƒnderungen verhindern, die die Neuerstellung
--							         der Tabelle erfordern => Haken raus

-- Salamitaktik
-- Groﬂe Tabellen in kleinere Tabellen aufteilen
-- Bonus: mit Partitionierten Sicht auf die unterliegenden Zugreifen

CREATE TABLE M002_Umsatz
(
	datum date,
	umsatz float
)

BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 100000
BEGIN
		INSERT INTO M002_Umsatz VALUES
		(DATEADD(DAY, FLOOR(RAND()*1095),'01.01.2021'), RAND() * 1000)
		SET @i += 1
END
COMMIT

SELECT * FROM M002_Umsatz

SELECT * FROM M002_Umsatz
WHERE YEAR(datum) = 2021 -- Alle 100.000 Zeilen mussten durchsucht werden

-------------------------------------

CREATE TABLE M002_Umsatz2021
(
	datum date,
	umsatz float
) -- ON [Third]

INSERT INTO M002_Umsatz2021
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2021

-------------------------------------

CREATE TABLE M002_Umsatz2022
(
	datum date,
	umsatz float
) -- ON [Primary]

INSERT INTO M002_Umsatz2022
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2022

-------------------------------------

CREATE TABLE M002_Umsatz2023
(
	datum date,
	umsatz float
) -- ON [Secondary]

INSERT INTO M002_Umsatz2023
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2023

-------------------------------------

CREATE VIEW UmsatzGesamt
AS
SELECT * FROM M002_Umsatz2021
UNION ALL
SELECT * FROM M002_Umsatz2022
UNION ALL
SELECT * FROM M002_Umsatz2023

SELECT * FROM UmsatzGesamt
WHERE datum BETWEEN '01.01.2021' AND '31.12.2021'