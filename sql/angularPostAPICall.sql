Use DemoDB;
Create Procedure SaveProduct_SP
(
	@Name Varchar(100),
	@Price Decimal(18,2),
	@Units Int
)
AS
Begin
	Set NoCount On

	Insert Into Product(Name,Price,Units) Values(@Name,@Price,@Units)

	Select Cast(Scope_Identity() As Int) As LastInsertedId
	Set NoCount Off
End