/*
	c)	Gibt es eine geeignetere Entwicklungsumgebung als SSMS in der z.B. auch 
	Breakpoints in SQL-Skripten gesetzt werden k�nnen und z.B. String-Variablen 
	�berwacht werden k�nnen. Teilweise werden bei uns komplette SQL-Befehl zun�chst aus 
	einzelnen Strings zusammengesetzt und dann mit einem Execute-Befehl ausgef�hrt.
*/

/*
			TOOL		|		Breakpoints			|	Variablen-Watch		|	Bemerkung
	--------------------------------------------------------------------------------------------
			SSMS		|			X				|			X			|   Debugger wurde entfernt

	Visual Studio 
	SQL Server Data
	Tools (SSDT)		|			JA				|			JA			|  Beste Microsoft-L�sung

	dbForge Studio      |			JA				|			JA			| Beste Drittanbieter-L�sung

	Azure Data Studio   |			X				|			X			|	Modern, aber kein Debugging

*/

-- Fazit: => SQL Server selbst kein Debugging mehr seit 2017, durch Performance einb��e rausgenommen worden
-- Alternativen gibts dennoch, ein paar sind Kostenpflichtig, andere wiederrum nicht