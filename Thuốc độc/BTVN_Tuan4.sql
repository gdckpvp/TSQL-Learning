-- BTVN Tuần 4 --

-- BT1 --
DECLARE @tongsoHD INT;

SELECT 
	@tongsoHD = COUNT(*) 
FROM 
	Sales.SalesOrderDetail 
WHERE 
	ProductID = '778';

IF @tongsoHD > 500
    PRINT 'Sản phẩm 778 có trên 500 đơn hàng';
ELSE
    PRINT 'Sản phẩm 778 có ít đơn đặt hàng';

-- BT2 --
DECLARE @makh INT, @n INT, @nam INT
SET @nam = 2008 SET @makh = 1402
SET @n = 
(
		SELECT COUNT(*)
		FROM 
			Sales.SalesOrderHeader
		where 
			CustomerID = @makh 
			AND YEAR(OrderDate) = @nam
)	
IF @n > 0 
	PRINT N'Khách hàng ' + 
	CAST(@makh AS char(5) ) + N' có'+ 
	CAST(@n AS char(4)) + N' hóa đơn trong năm'+ 
	CAST(@nam AS char(4))
ELSE 
	PRINT N'Khách hàng ' + 
	CAST(@makh AS char(5)) + N' không có hóa đơn trong năm '+ 
	CAST(@nam AS char(4))

-- BT3 --
SELECT h.SalesOrderID, Subtotal = SUM(LineTotal), Discount =  
(
	CASE
		WHEN SUM(LineTotal)<100000 THEN 0
		WHEN SUM(LineTotal) BETWEEN 100000 AND 120000 THEN SUM(LineTotal)*0.05
		WHEN SUM(LineTotal) BETWEEN 120000 AND 150000 THEN SUM(LineTotal)*0.1
		ELSE SUM(LineTotal)*0.15
	END
)
 FROM 
	Sales.SalesOrderHeader h join Sales.SalesOrderDetail d 
	on h.SalesOrderID = d.SalesOrderID
 GROUP BY 
	h.SalesOrderID
 HAVING 
	SUM(LineTotal) > 100000

-- BT4 --
DECLARE @mancc INT, @masp INT,@soluongcc INT
SET @mancc = 1650
SET @masp = 4
SET @soluongcc = 
(
	SELECT OnOrderQty
	FROM 
		Purchasing.ProductVendor
	where 
		ProductID = @masp AND BusinessEntityID = @mancc
)
IF @soluongcc is null
	PRINT N'Nhà cung cấp ' + 
	CAST(@mancc AS char(5) ) + N' không cung cấp sản phẩm '+ 
	CAST(@masp AS char(4)) 
ELSE 
	PRINT N'Nhà cung cấp ' + 
	CAST(@mancc AS char(5)) + N' cung cấp sản phẩm  '+ 
	CAST(@masp AS char(4)) + N' với số lượng là '+
	CAST(@soluongcc AS char(5))

-- BT5 --
WHILE( SELECT SUM(rate) FROM HumanResources.EmployeePayHistory ) <6000
BEGIN
	UPDATE HumanResources.EmployeePayHistory
	SET Rate = Rate*1.1
	IF( SELECT MAX(rate) FROM HumanResources.EmployeePayHistory ) > 150
		BREAK
	ELSE 
		CONTINUE
END



