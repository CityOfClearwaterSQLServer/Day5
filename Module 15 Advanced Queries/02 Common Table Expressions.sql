use AdventureWorks2014
go

-- Common Table Expression are similar to SubQueries but also support Recursion
with YearlyCustomerCountCTE as 
(
	select year(OrderDate) as OrderYear
		 , count(distinct CustomerID) as NumCustomers
	from Sales.SalesOrderHeader
	group by year(OrderDate)
)

-- Single Reference
select OrderYear
	 , NumCustomers								as [Current Num Customers]
from YearlyCustomerCountCTE;


-- Multiple References
with YearlyCustomerCountCTE as 
(
	select year(OrderDate) as OrderYear
		 , count(distinct CustomerID) as NumCustomers
	from Sales.SalesOrderHeader
	group by year(OrderDate)
)
select cur.OrderYear
	 , cur.NumCustomers							as [Current Num Customers]
	 , prv.NumCustomers							as [Previous Num Customers]
	 , cur.NumCustomers - prv.NumCustomers		as [Growth]
from YearlyCustomerCountCTE as cur
	left outer join YearlyCustomerCountCTE as prv on cur.OrderYear = prv.OrderYear + 1


-- Multiple CTEs
WITH CTE1 AS
(
  SELECT YEAR(OrderDate) AS OrderYear, CustomerID
  FROM Sales.SalesOrderHeader
),
CTE2 AS
(
  SELECT OrderYear, COUNT(DISTINCT CustomerID) AS NumCusts
  FROM CTE1
  GROUP BY OrderYear
)
SELECT OrderYear, NumCusts
FROM CTE2
WHERE NumCusts > 70


-- Recursive CTE
-- See Hierarchical Queries for Example...