use AdventureWorks2014

-- Pivot / Unpivot
SELECT DaysToManufacture, Color, AVG(StandardCost) AS AverageCost 
FROM Production.Product
GROUP BY DaysToManufacture, Color

SELECT Color							AS [Color]
	  , [0], [1], [2], [3], [4]			-- as [4 Days]
into PivotedTable
FROM (SELECT DaysToManufacture, StandardCost, Color 
      FROM Production.Product)			AS SourceTable
PIVOT
(
	Avg(StandardCost)
	FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
)										AS PivotTable

select * from PivotedTable

SELECT Color, [Day], Cost
FROM 
   (SELECT Color, [0], [1], [2], [3], [4]
    FROM PivotedTable)					as SourceTable
UNPIVOT
   ([Cost] FOR [Day] IN 
      ([0], [1], [2], [3], [4])
)										AS UnPivotTable

drop table PivotedTable
