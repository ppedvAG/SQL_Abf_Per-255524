/*
	b)	Wir haben j�hrlich wiederkehrende Projekte, bei denen mehrere SQL Skripte 
	abgearbeitet werden m�ssen. In jedem Skript muss dabei z.B. der Datenbankname angepasst werden 
	(USE [Datenbank_diesesJahr]). Gibt es in einem Projekt eine M�glichkeit zentrale Variablen 
	wie den Datenbanknamen nur einmalig zu setzen?
*/

-- => T-SQL unterst�tzt keine globalen Variablen f�r das gesamte Projekt im klassischen Sinne
--   (wie man es kennt aus Programmiersprachen)

-- Option 1: SQLCM-Modus mit Variable

:setvar DBName "Projekt_2025"

USE [$(DBName)];
GO

-- Wichtig!
-- SQLCMD Modus aktivieren => Men�: Abfrage => SQLCMD-Modus

-- Startskript schreiben, das alle anderen Skripte aufruft
:setvar DBName "Projekt_2025"

:r .\01_Skript1.sql
:r .\02_Skript2.sql
:r .\03_Skritp3.sql

-- => Jedes Jahr nur den Variablenwert �ndern im Skript

-- Option 2: PowerShell mit sqlcmd -v m�glich => ist gut f�r j�hrliche Batchl�ufe 