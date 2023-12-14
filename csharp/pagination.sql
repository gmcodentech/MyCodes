CREATE TABLE Product
(
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(100),
Price DECIMAL(18,2),
Units INT
)

insert into product(Name,Price,Units)values('Water',23.2,100)
insert into Product(Name,Price,Units)values('Sugar',12.5,200)
insert into Product(Name,Price,Units)values('Coffee',48.92,300)
insert into Product(Name,Price,Units)values('Milk',18.95,20)
insert into Product(Name,Price,Units)values('Tea',98.48,80)
insert into Product(Name,Price,Units)values('Toothpaste',34.4,100)

insert into Product(Name,Price,Units)values('Oil',120.5,200)
insert into Product(Name,Price,Units)values('Soap',8.92,30)
insert into Product(Name,Price,Units)values('Toothbrush',180.95,20)
insert into Product(Name,Price,Units)values('Chair',908.48,800)
insert into Product(Name,Price,Units)values('TV',3004.4,10)



EXECUTE GetProducts_SP 2,4

CREATE PROCEDURE GetProducts_SP
(
	@PageNo Int,
	@PageSize Int
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
	ID,
	Name,
	Price,
	Units
FROM Product
Order by ID
OFFSET (@PageNo -1) * @PageSize  Rows
FETCH NEXT @PageSize  Rows Only

	SET NOCOUNT OFF
END











