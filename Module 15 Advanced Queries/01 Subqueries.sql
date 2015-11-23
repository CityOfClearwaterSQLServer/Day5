use AdventureWorks2014

-- Single Value Subquery
-- Error
select SalesOrderID, UnitPrice
from Sales.SalesOrderDetail
where UnitPrice > AVG(UnitPrice)

-- Good
select SalesOrderID, UnitPrice
from Sales.SalesOrderDetail
where UnitPrice > (select AVG(UnitPrice) from Sales.SalesOrderDetail)

-- Multi-Value Subquery (Multiple Cols)
select SalesOrderID, UnitPrice
from Sales.SalesOrderDetail
where UnitPrice in 
	(select distinct top 10 UnitPrice from Sales.SalesOrderDetail order by UnitPrice desc)

-- Correlated Column Subquery
-- With Aliases
SELECT soh.SalesOrderID, soh.OrderDate,
    (SELECT MAX(sod.UnitPrice)
     FROM Sales.SalesOrderDetail AS sod
     WHERE soh.SalesOrderID = sod.SalesOrderID) AS MaxUnitPrice
FROM Sales.SalesOrderHeader AS soh

SELECT SalesOrderID, OrderDate,
    (SELECT MAX(UnitPrice)
     FROM Sales.SalesOrderDetail
     WHERE Sales.SalesOrderHeader.SalesOrderID = SalesOrderID) AS MaxUnitPrice
FROM Sales.SalesOrderHeader 

-- IN, =ANY, =SOME, =ALL 
-- IN, =ANY, =SOME are equivalent
SELECT Name
FROM Production.Product
WHERE ProductSubcategoryID = all			-- in -- = some -- = any -- = all
    (SELECT ProductSubcategoryID
     FROM Production.ProductSubcategory
     WHERE Name like '%s')					-- for IN =ANY and =SOME
    --WHERE Name = 'Wheels')				-- for =ALL

	-- To Help Students See Inner Subquery Data
	SELECT Name FROM Production.ProductSubcategory
	WHERE Name like '%s'						-- 37 Rows returned
	--WHERE Name = 'Wheels'						-- Only 1 row returned

-- Exists
SELECT Name
FROM Production.Product							as p
WHERE EXISTS
    (SELECT * 
     FROM Production.ProductSubcategory
     WHERE ProductSubcategoryID = p.ProductSubcategoryID
        AND Name = 'Wheels')
              
-- Join Version
SELECT p.Name
FROM Production.Product							as p
	inner join Production.ProductSubcategory	as ps	on p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.Name = 'Wheels'



-- Common Table Expression     
-- From Multi-Value Subquery Version
select ProductSubcategoryID, DATEDIFF(YEAR, Earliest, Latest) as Years
from (select ProductSubcategoryID, min(SellStartDate) as Earliest, MAX(SellStartDate) as Latest
	  from Production.Product
	  group by ProductSubcategoryID) as [inner]

-- CTE Version
with [inner] (CategoryID, Earliest, Latest)
as
(
	  select ProductSubcategoryID, min(SellStartDate) as Earliest, MAX(SellStartDate) as Latest
	  from Production.Product
	  group by ProductSubcategoryID
)
select CategoryID, DATEDIFF(YEAR, Earliest, Latest) as Years
from [inner]

-- Apply Operator
SELECT  p.BusinessEntityID, p.PersonType, p.EmailPromotion,
        ci.FirstName, ci.LastName, ci.JobTitle, ci.BusinessEntityType 
FROM Person.Person AS p
--CROSS APPLY dbo.ufnGetContactInformation(p.BusinessEntityID) AS ci;
Outer APPLY dbo.ufnGetContactInformation(p.BusinessEntityID) AS ci;



