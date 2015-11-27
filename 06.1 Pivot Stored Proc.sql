use AdventureWorks2014
go

drop procedure PivotMe
go

create procedure PivotMe
	@TableName		as sysname			
	, @XAxisCol		as sysname			
	, @YAxisCol		as sysname			
	, @AggregateCol	as sysname			
	, @Aggregate	as nvarchar(25)		
as
begin
	-- Declare Variables for Dyanmic Queries and List Of Column Names
	declare @DynamicQuery as nvarchar(max)
	declare @ColumnNames as nvarchar(max)

	-- Use Dynamic Query to Get Distinct List of Column Names for Pivoting
	set @DynamicQuery = 
		N'select @ColumnNames = IsNull(@ColumnNames + '', '','''') + QuoteName(' + @XAxisCol + ')' +
		' from (select distinct ' + @XAxisCol + ' from ' + @TableName + ') as SourceTable'
	--print @DynamicQuery					-- For Testing Purposes
	execute sp_executesql 
		@DynamicQuery, 
		N'@TableName as sysname, @XAxisCol as sysname, @ColumnNames as nvarchar(max) output', 
		@TableName, @XAxisCol, @ColumnNames output
	--print @ColumnNames					-- For Testing Purposes


	-- Use Dynamic Query to Pivot Table
	set @DynamicQuery = 
		N'select ' + @YAxisCol + ', ' + @ColumnNames +
		' from (select ' + @XAxisCol + ', ' + @YAxisCol + ', ' + @AggregateCol + ' from ' + @TableName + ') as SourceTable' +
		' pivot' +
		' (' +
		' ' + @Aggregate + '(' + @AggregateCol + ')' +
		' for ' + @XAxisCol + ' IN (' + @ColumnNames + ')' +
		' ) as PivotTable'
	--print @DynamicQuery					-- For Testing Purposes
	execute sp_executesql 
		@DynamicQuery, 
		N'@TableName as sysname, @XAxisCol as sysname, @YAxisCol as sysname, @AggregateCol as sysname, @Aggregate as nvarchar(25)', 
		@TableName, @XAxisCol, @YAxisCol, @AggregateCol, @Aggregate
end
go

exec PivotMe
	@TableName		= 'Production.Product'
	, @XAxisCol		= 'DaysToManufacture'
	, @YAxisCol		= 'Color'
	, @AggregateCol	= 'StandardCost'
	, @Aggregate	= 'avg'


