/*
	c)	Gibt es eine geeignetere Entwicklungsumgebung als SSMS in der z.B. auch 
	Breakpoints in SQL-Skripten gesetzt werden können und z.B. String-Variablen 
	überwacht werden können. Teilweise werden bei uns komplette SQL-Befehl zunächst aus 
	einzelnen Strings zusammengesetzt und dann mit einem Execute-Befehl ausgeführt.
*/

/*
			TOOL		|		Breakpoints			|	Variablen-Watch		|	Bemerkung
	--------------------------------------------------------------------------------------------
			SSMS		|			X				|			X			|   Debugger wurde entfernt

	Visual Studio 
	SQL Server Data
	Tools (SSDT)		|			JA				|			JA			|  Beste Microsoft-Lösung

	dbForge Studio      |			JA				|			JA			| Beste Drittanbieter-Lösung

	Azure Data Studio   |			X				|			X			|	Modern, aber kein Debugging

*/

-- Fazit: => SQL Server selbst kein Debugging mehr seit 2017, durch Performance einbüße rausgenommen worden
-- Alternativen gibts dennoch, ein paar sind Kostenpflichtig, andere wiederrum nicht