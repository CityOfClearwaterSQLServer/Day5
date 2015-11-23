use AdventureWorks2014

-- Create an Employee table.
CREATE TABLE dbo.MyEmployees
(
	EmployeeID smallint NOT NULL,
	FirstName nvarchar(30)  NOT NULL,
	LastName  nvarchar(40) NOT NULL,
	Title nvarchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);

-- Populate the table with values.
INSERT INTO dbo.MyEmployees VALUES 
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);


-- Self Join
SELECT e.EmployeeID
	, e.FirstName + ' ' + e.LastName					AS [EmployeeName]
	, e.ManagerID										AS [ManagerID]
	, m.FirstName + ' ' + m.LastName					AS [ManagerName]
FROM dbo.MyEmployees									AS e 
	left outer join dbo.MyEmployees						AS m						ON e.ManagerID = m.EmployeeID;
		
-- Recursive CTE
WITH EmployeesRecursiveCTE AS
(
  SELECT e.EmployeeID
	   , e.FirstName + ' ' + e.LastName					AS [EmployeeName]
	   , CAST(null as int)								AS [ManagerID]
	   , CAST(null as nvarchar(255))					AS [ManagerName]
  FROM dbo.MyEmployees									AS e
  WHERE ManagerID is null

  UNION ALL

  SELECT e.EmployeeID
	   , e.FirstName + ' ' + e.LastName
	   , e.ManagerID
	   , cast(m.EmployeeName as nvarchar(255))
  FROM EmployeesRecursiveCTE							AS m
    INNER JOIN dbo.MyEmployees							AS e						ON e.ManagerID = m.EmployeeID
)
SELECT * FROM EmployeesRecursiveCTE;


-- Hierarchical Query
WITH EmployeesHierarchicalCTE 
AS
(

-- Anchor member definition
	SELECT e.EmployeeID
		, e.FirstName + ' ' + e.LastName				AS [EmployeeName]
		, CAST(null as int)								AS [ManagerID]
		, CAST(null as nvarchar(255))					AS [ManagerName]
		, 0												AS [Level]
	FROM dbo.MyEmployees								AS e
	WHERE ManagerID is null
    
    UNION ALL
    
-- Recursive member definition
	SELECT e.EmployeeID
	   , e.FirstName + ' ' + e.LastName
	   , e.ManagerID
	   , cast(m.EmployeeName as nvarchar(255))
       , Level + 1
    FROM dbo.MyEmployees								AS e
    INNER JOIN EmployeesHierarchicalCTE					AS m						ON e.ManagerID = m.EmployeeID
)

-- Statement that executes the CTE
SELECT * FROM EmployeesHierarchicalCTE;

DROP TABLE dbo.MyEmployees
