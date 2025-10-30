/*
	b)	Wir haben jährlich wiederkehrende Projekte, bei denen mehrere SQL Skripte 
	abgearbeitet werden müssen. In jedem Skript muss dabei z.B. der Datenbankname angepasst werden 
	(USE [Datenbank_diesesJahr]). Gibt es in einem Projekt eine Möglichkeit zentrale Variablen 
	wie den Datenbanknamen nur einmalig zu setzen?
*/

-- => T-SQL unterstützt keine globalen Variablen für das gesamte Projekt im klassischen Sinne
--   (wie man es kennt aus Programmiersprachen)

-- Option 1: SQLCM-Modus mit Variable

:setvar DBName "Projekt_2025"

USE [$(DBName)];
GO

-- Wichtig!
-- SQLCMD Modus aktivieren => Menü: Abfrage => SQLCMD-Modus

-- Startskript schreiben, das alle anderen Skripte aufruft
:setvar DBName "Projekt_2025"

:r .\01_Skript1.sql
:r .\02_Skript2.sql
:r .\03_Skritp3.sql

-- => Jedes Jahr nur den Variablenwert ändern im Skript

-- Option 2: PowerShell mit sqlcmd -v möglich => ist gut für jährliche Batchläufe 