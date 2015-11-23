use AdventureWorks2014

-- Group By Clause
select Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by YEAR(soh.OrderDate), st.Name


-- With Rollup Modifier (Deprecated)
select Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by YEAR(soh.OrderDate), st.Name with rollup


-- With Cube Modifier (Deprecated)
select Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by YEAR(soh.OrderDate), st.Name with cube


-- Rollup()
select Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by rollup(YEAR(soh.OrderDate), st.Name)


-- Cube()
select Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by cube(YEAR(soh.OrderDate), st.Name)


-- Grouping Sets
select Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by grouping sets (
	(YEAR(soh.OrderDate), st.Name)
	--, (st.Name)
	--, (YEAR(soh.OrderDate))
	--, ()
)

-- Grouping_ID()
select Grouping_ID(YEAR(soh.OrderDate), st.Name)
	, Year(soh.OrderDate)						as [Year]
	, st.Name									as [Country]
	, sum(soh.TotalDue)							as [TotalDue]
from Sales.SalesOrderHeader						as soh
	join Sales.SalesTerritory					as st		on soh.TerritoryID = st.TerritoryID
group by cube(YEAR(soh.OrderDate), st.Name)

select 
	CASE 
		WHEN GROUPING_ID(YEAR(soh.OrderDate), st.Name) = 0 THEN st.Name
		WHEN GROUPING_ID(YEAR(soh.OrderDate), st.Name) = 1 THEN convert(varchar(40), YEAR(soh.OrderDate)) + ' Total: '
		WHEN GROUPING_ID(YEAR(soh.OrderDate), st.Name) = 2 THEN st.Name + ' Total:'
		WHEN GROUPING_ID(YEAR(soh.OrderDate), st.Name) = 3 THEN 'Company Total: '
    END AS [Territory]
	, sum(soh.TotalDue)
from Sales.SalesOrderHeader						as soh
	inner join Sales.SalesTerritory				as st		on soh.TerritoryID = st.TerritoryID
group by cube(YEAR(soh.OrderDate), st.Name)


