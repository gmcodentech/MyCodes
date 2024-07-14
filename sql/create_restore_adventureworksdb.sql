RESTORE FILELISTONLY
FROM DISK = 'C:\Software\DB\SQLSERVER\AdventureWorksDW2017.bak'

RESTORE DATABASE AdventureWorksDW2017
FROM DISK = 'C:\Software\DB\SQLSERVER\AdventureWorksDW2017.bak'
WITH MOVE 'AdventureWorksDW2017' TO 'C:\Software\DB\SQLSERVER\AdventureWorksDW2017.mdf',
MOVE 'AdventureWorksDW2017_log' TO 'C:\Software\DB\SQLSERVER\AdventureWorksDW2017.ldf'

USE AdventureWorksDW2017

-- 60398 Rows
select count(1) from FactInternetSales

select *
 from FactInternetSales

-- Total Sales
Select Sum(SalesAmount)
 From FactInternetSales

select *
 from DimProduct


--Weekly Sales
Select
	DatePart(WW,S.OrderDate) as 'WeekNum',
	Sum(S.SalesAmount) as 'Total Sales'
From
	FactInternetSales S
Where
	Year(S.OrderDate) = 2013
Group By
	DatePart(WW,S.OrderDate)
Order By 
	DatePart(WW,S.OrderDate) Asc