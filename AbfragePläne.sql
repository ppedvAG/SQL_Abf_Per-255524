dbcc freeproccache

USE Northwind

-- Pläne werden als Hashwert gespeichert ... blöd, wenn man mal groß und klein schreibt..

SELECT * FROM orders WHERE customerid = 'HANAR'

SELECT * FROM orders WHERE Customerid = 'HANAR'

SELECT * FROM Orders WHERE CustomerID = 'HANAR'


SELECT * FROM Orders WHERE OrderID = 10
-- tinyint

SELECT * FROM Orders WHERE OrderID = 300
-- smallint

SELECT * FROM Orders WHERE OrderID = 50000
--int

select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans p CROSS APPLY
	sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype = 'Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'

-- Kann man verhindern in dem man eine Prozedur verwendet