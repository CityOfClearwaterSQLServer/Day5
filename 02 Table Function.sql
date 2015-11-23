use AdventureWorks2014

-- Simple Table Function Syntax
drop function GetProducts
go
create function GetProducts(@ProductName nvarchar(40) = '%')
	returns @ReturnProducts table
		(
			ProductID		int,
			ProductName		nvarchar(40),
			Price			money
		)
as
begin
	if @ProductName is null
		set @ProductName = '%'

	insert into @ReturnProducts	
		select ProductID, Name, ListPrice
		from Production.Product
		where Name like @ProductName

	return
end
go

select *
from GetProducts('C%')

-- Descriptive Table Function Syntax
drop function GetProducts
go
create function GetProducts()
	returns @ReturnProducts table
		(
			ProductID		int,
			ProductName		nvarchar(40),
			Price			money
		)
as
begin
	insert into @ReturnProducts values (1, 'Product 1', 10)
	insert into @ReturnProducts values (2, 'Product 2', 20)
	insert into @ReturnProducts values (3, 'Product 3', 30)
	insert into @ReturnProducts values (4, 'Product 4', 40)

	return
end
go

select *
from GetProducts()
