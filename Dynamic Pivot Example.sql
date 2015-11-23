use AdventureWorks2014

DECLARE @DynamicPivotQuery AS NVARCHAR(MAX)
DECLARE @ColumnName AS NVARCHAR(MAX)
 
--Get distinct values of the PIVOT Column 
SELECT @ColumnName= ISNULL(@ColumnName + ',','') 
       + QUOTENAME(DaysToManufacture)
FROM (SELECT DISTINCT DaysToManufacture FROM Production.Product) AS Days

--Prepare the PIVOT query using the dynamic 
SET @DynamicPivotQuery = 
  N'SELECT Color, ' + @ColumnName + '
FROM (SELECT DaysToManufacture, StandardCost, Color 
      FROM Production.Product)	AS SourceTable
PIVOT(
	Avg(StandardCost)
    FOR DaysToManufacture IN (' + @ColumnName + ')
) AS PivotTable'

--print @DynamicPivotQuery

--Execute the Dynamic Pivot Query
EXEC sp_executesql @DynamicPivotQuery