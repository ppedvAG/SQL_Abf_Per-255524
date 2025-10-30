/*
	
	Partitionierung:
	Aufteilung in "mehrere" Tabellen
	Einzelne Tabelle bleibt bestehen, aber intern werden die Daten partitioniert
	

	Anforderungen:
	Partitionsfunktion: Stellt die Bereiche dar (0-100, 101-200, 201-Ende)
	Partitionsschema: Weist die einzelnen Partitionen auf Dateigruppe zu
*/

-- Schritt 1: Dateigruppe erstellen

-- 3 Dateigruppen: Team_Eins, Team_Zwei, Team_Drei

ALTER DATABASE Demo8 ADD FILEGROUP Teams_Eins
ALTER DATABASE Demo8 ADD FILEGROUP Teams_Zwei
ALTER DATABASE Demo8 ADD FILEGROUP Teams_Drei

-- 3 Dateien für jede Dateigruppe
ALTER DATABASE Demo8
ADD FILE
(
	NAME = N'TEins_Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\TEins_Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP Teams_Eins

-------------------------------------------------------------------

ALTER DATABASE Demo8
ADD FILE
(
	NAME = N'TZwei_Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\TZwei_Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP Teams_Zwei

-------------------------------------------------------------------

ALTER DATABASE Demo8
ADD FILE
(
	NAME = N'TDrei_Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\TDrei_Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP Teams_Drei

-- Partitionsfunktion & Partitionsschema
-- 0-100-200-Ende

-- Partitionsfunktion
CREATE PARTITION FUNCTION pf_Zahl(int) AS
RANGE LEFT FOR VALUES (100, 200)

-- Paritionsschema
CREATE PARTITION SCHEME sch_ID as
PARTITION pf_Zahl TO (Teams_Eins, Teams_Zwei, Teams_Drei)

-----------------------------------------------------------

-- Hier das Schema auf die Tabelle gelegt werden
CREATE TABLE M003_Test
(
	id int identity,
	zahl float
) ON sch_ID(id)

BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 1000
BEGIN 
	INSERT INTO M003_Test VALUES (RAND() * 1000)
	SET @i += 1
END
COMMIT

-- Nichts besonderes zu sehen
SELECT * FROM M003_Test

SET STATISTICS TIME, IO ON

-- Hier wird nur die unterste Partition durchsucht (100DS)
SELECT * FROM M003_Test
WHERE id < 50

-- Hier wird bis zur zweiten Partition durchsucht (200DS)
SELECT * FROM M003_Test
WHERE id < 150

SELECT * FROM M003_Test
WHERE id > 500


-- Übersicht über Partition verschaffen
SELECT OBJECT_NAME(OBJECT_ID), * FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')

SELECT $partition.pf_Zahl(50)
SELECT $partition.pf_Zahl(150)
SELECT $partition.pf_Zahl(250)

SELECT * FROM sys.filegroups
SELECT * FROM sys.allocation_units

-- Pro Datensatz die Partition + Filegroup anhängen
SELECT * FROM M003_Test as t
JOIN
(
	SELECT name, ips.partition_number
	FROM sys.filegroups as fg

	JOIN sys.allocation_units as au
	on fg.data_space_id = au.data_space_id

	JOIN sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED') as ips
	ON ips.hobt_id = au.container_id

	WHERE OBJECT_NAME(ips.object_id) = 'M003_Test'
) x
ON $partition.pf_Zahl(t.id) = x.partition_number