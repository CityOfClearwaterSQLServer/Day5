use AdventureWorks2014

-- TableSample
select p.FirstName + ' ' + p.LastName					as [Employee Name]
from Person.Person										as p
--tablesample (10 percent)	
tablesample (1000 rows)

-- Row_Number
select p.FirstName + ' ' + p.LastName					as [Employee Name]
	 , e.HireDate										as [Hire Date]
	 , ROW_NUMBER() over (order by HireDate)			as [Seniority]
from HumanResources.Employee							as e
	inner join Person.Person							as p	on e.BusinessEntityID = p.BusinessEntityID
	
select p.FirstName + ' ' + p.LastName					as [Employee Name]
	 , e.HireDate										as [Hire Date]
	 , e.JobTitle										as [Job Title]
	 , ROW_NUMBER() 
	   over (partition by JobTitle order by HireDate)	as [Seniority]
from HumanResources.Employee							as e
	inner join Person.Person							as p	on e.BusinessEntityID = p.BusinessEntityID

-- Rank, Dense_Rank
select p.FirstName + ' ' + p.LastName					as [Employee Name]
	 , e.HireDate										as [Hire Date]
	 , e.JobTitle										as [Job Title]
	 , ROW_NUMBER() 
	   over (partition by JobTitle order by HireDate)	as [Seniority Row_Number]
	 , RANK() 
	   over (partition by JobTitle order by HireDate)	as [Seniority Rank]
	 , DENSE_RANK() 
	   over (partition by JobTitle order by HireDate)	as [Seniority Dense_Rank]
from HumanResources.Employee							as e
	inner join Person.Person							as p	on e.BusinessEntityID = p.BusinessEntityID
where JobTitle = 'Sales Representative'

-- NTile
select p.FirstName + ' ' + p.LastName					as [Employee Name]
	 , NTILE(3) over (order by e.rowguid)				as [Bucket] 
from HumanResources.Employee							as e
	inner join Person.Person							as p	on e.BusinessEntityID = p.BusinessEntityID
	
select p.FirstName + ' ' + p.LastName					as [Employee Name]
	 , YEAR(e.HireDate)									as [Hire Year]
	 , NTILE(3) over 
	 (partition by year(e.HireDate) order by e.rowguid)	as [Bucket] 
from HumanResources.Employee							as e
	inner join Person.Person							as p	on e.BusinessEntityID = p.BusinessEntityID
order by [Hire Year], [Bucket]


