  Select * From Product

  Execute GetProductTotalPages_SP 50

 Create Procedure GetProductTotalPages_SP
(@PageSize int)
AS
Begin
	Set NoCount On
	 Select
	Cast((Ceiling(Count(1)/Cast(@PageSize as Float))) as Int) As TotalPage
 From
	Product
	Set NoCount Off
End

Execute GetProducts_SP 2,50

Create Procedure GetProducts_SP
(
	@PageNo int,
	@PageSize int
)
AS
Begin
	Set NoCount On
	Select
	ID,
	Name,
	Price,
	Units
From
	Product
Order By ID
Offset (@PageNo -1) * 50 Rows
Fetch Next @PageSize Rows Only
	Set NoCount Off
End