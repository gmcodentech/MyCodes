Alter Procedure GetProductsByCategoryID_SP
(
	@CategoryID Int,
	@Price Decimal(18,2)
)
As
Begin
	Select P.ProductName,p.UnitPrice,P.UnitsInStock,C.CategoryName From Products P
	Join Categories C On P.CategoryID = C.CategoryID
	Where (@CategoryID>0 And C.CategoryID=@CategoryID) OR (@CategoryID=0 And C.CategoryID>0)
	And P.UnitPrice > @Price
End

Select * from Products

GetProductsByCategoryID_SP 1,100