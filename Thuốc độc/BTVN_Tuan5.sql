-- BT Tuần 5 --


-- Store Procedure --
-- BT1 --
CREATE PROCEDURE dbo.proc_TotalDue 
	@month INT,
	@year INT
AS
	SELECT 
		CustomerID,
		SumOfTotalDue=Sum(TotalDue)
	FROM 
		Sales.SalesOrderHeader
	WHERE 
		Month(OrderDate)=@month 
		AND Year(OrderDate)=@year
	GROUP BY CustomerID
GO
EXEC dbo.proc_TotalDue @month=6, @year=2013

-- BT2 --
CREATE PROCEDURE dbo.proc_SalesYTD 
	@SalesPerson INT,
	@SalesYTD MONEY OUTPUT
AS
	SELECT @SalesYTD = SUM(TotalDue)
	FROM 
		Sales.SalesOrderHeader soh
		INNER JOIN Sales.SalesPerson sp
		ON soh.SalesPersonID = sp.BusinessEntityID
	WHERE 
		sp.BusinessEntityID = @SalesPerson
		AND YEAR(OrderDate) = YEAR(GETDATE())
GO
DECLARE @SalesYTD MONEY
EXEC dbo.proc_SalesYTD @Salesperson = 279, @SalesYTD = @SalesYTD OUTPUT
SELECT @SalesYTD
/*Note: Ở đây @Salesperson chính là BusinessEntityID 
	hay ID của người bán hàng*/
	
-- BT3 --
CREATE PROCEDURE dbo.proc_GetProductsByMaxPrice
	@MaxPrice MONEY
AS
	SELECT ProductID, ListPrice
	FROM Production.Product
	WHERE ListPrice <= @MaxPrice
GO

EXEC dbo.proc_GetProductsByMaxPrice @MaxPrice = 50

-- BT4 --
CREATE PROCEDURE dbo.proc_NewBonus
	@SalesPersonID INT
AS
	BEGIN
		DECLARE @Bonus MONEY
		DECLARE @SumOfSubTotal MONEY

		-- Lấy giá trị hiện tại của tiền thưởng cho nhân viên
		SELECT 
			@Bonus = Bonus
		FROM 
			Sales.SalesPerson
		WHERE 
			BusinessEntityID = @SalesPersonID

		-- Tính tổng doanh thu của nhân viên
		SELECT 
			@SumOfSubTotal = SUM(SubTotal)
		FROM 
			Sales.SalesOrderHeader
		WHERE 
			SalesPersonID = @SalesPersonID

		-- Cập nhật tiền thưởng mới cho nhân viên
		UPDATE Sales.SalesPerson
		SET 
			Bonus = @Bonus + (@SumOfSubTotal * 0.01)
		WHERE 
			BusinessEntityID = @SalesPersonID

		-- Trả về kết quả bao gồm SalesPersonID, NewBonus và SumOfSubTotal
		SELECT 
			@SalesPersonID AS SalesPersonID, 
			(@Bonus + (@SumOfSubTotal * 0.01)) AS NewBonus, 
			@SumOfSubTotal AS SumOfSubTotal
	END
GO

EXEC dbo.proc_NewBonus @SalesPersonID = 279

-- BT5 --
CREATE PROCEDURE dbo.proc_TopProductCategory
    @year INT
AS
BEGIN
    SELECT 
        pc.ProductCategoryID, 
        pc.Name,
        SUM(sod.OrderQty) AS SumOfQty
    FROM 
        Production.ProductCategory pc
        JOIN Production.ProductSubcategory psc ON pc.ProductCategoryID = psc.ProductCategoryID
        JOIN Production.Product p ON psc.ProductSubcategoryID = p.ProductSubcategoryID
        JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
        JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE 
        YEAR(soh.OrderDate) = @year
        AND pc.ProductCategoryID = (
            SELECT TOP 1 pc1.ProductCategoryID
            FROM Production.ProductCategory pc1
                JOIN Production.ProductSubcategory psc1 ON pc1.ProductCategoryID = psc1.ProductCategoryID
                JOIN Production.Product p1 ON psc1.ProductSubcategoryID = p1.ProductSubcategoryID
                JOIN Sales.SalesOrderDetail sod1 ON p1.ProductID = sod1.ProductID
                JOIN Sales.SalesOrderHeader soh1 ON sod1.SalesOrderID = soh1.SalesOrderID
            WHERE 
                YEAR(soh1.OrderDate) = @year
            GROUP BY pc1.ProductCategoryID
            ORDER BY SUM(sod1.OrderQty) DESC
        )
    GROUP BY pc.ProductCategoryID, pc.Name
END

EXEC dbo.proc_TopProductCategory @year = 2013

-- BT6 --
CREATE PROCEDURE TongThu
    @EmployeeID INT,
    @TotalSales MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @TotalSales = SUM(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID = @EmployeeID;

    IF @TotalSales IS NOT NULL
    BEGIN
        RETURN 0; -- trạng thái thành công
    END
    ELSE
    BEGIN
        RETURN 1; -- trạng thái thất bại
    END
END

DECLARE @TotalSales MONEY

EXEC dbo.TongThu @EmployeeID = 274, @TotalSales = @TotalSales OUTPUT

IF @TotalSales IS NULL
    PRINT N'Thủ tục thất bại'
ELSE
    PRINT N'Tổng trị giá các hóa đơn của nhân viên là: ' 
	+ CONVERT(VARCHAR, @TotalSales)

-- BT7 --
CREATE PROCEDURE GetTopPurchasingStore
    @year INT
AS
BEGIN
    SELECT TOP 1 s.Name AS StoreName, SUM(oh.SubTotal) AS TotalPurchasedAmount
    FROM Sales.SalesOrderHeader AS oh
    JOIN Sales.SalesOrderDetail AS od ON oh.SalesOrderID = od.SalesOrderID
    JOIN Sales.Customer AS c ON oh.CustomerID = c.CustomerID
    JOIN Sales.Store AS s ON c.StoreID = s.BusinessEntityID
    WHERE YEAR(oh.OrderDate) = @year
    GROUP BY s.Name
    ORDER BY TotalPurchasedAmount DESC

    IF @@ROWCOUNT = 0
        RETURN 1 -- Trả về trạng thái thất bại nếu không có dữ liệu

    RETURN 0 -- Trả về trạng thái thành công
END

EXEC GetTopPurchasingStore @year = 2013;

-- BT8 --
CREATE PROCEDURE Sp_InsertProduct
    @ProductID INT,
	@Name NVARCHAR(50),
	@ProductNumber NVARCHAR(25),
	@MakeFlag BIT,
	@FinishedGoodsFlag BIT,
	@Color NVARCHAR(15),
	@SafetyStockLevel SMALLINT,
	@ReorderPoint SMALLINT,
	@StandardCost MONEY,
	@ListPrice MONEY,
	@Size NVARCHAR(5),
	@SizeUnitMeasureCode NVARCHAR(3),
	@WeightUnitMeasureCode NVARCHAR(3),
	@Weight DECIMAL(8,2),
	@DaysToManufacture INT,
	@ProductLine NVARCHAR(2),
	@Class NVARCHAR(2),
	@Style NVARCHAR(2),
	@ProductSubcategoryID INT,
	@ProductModelID INT,
	@SellStartDate DATETIME,
	@SellEndDate DATETIME,
	@DiscontinuedDate DATETIME,
	@rowguid UNIQUEIDENTIFIER,
	@ModifiedDate DATETIME
AS
BEGIN
    IF (@ProductID IS NOT NULL AND @Name IS NOT NULL AND @ProductNumber IS NOT NULL AND @MakeFlag IS NOT NULL 
	AND @FinishedGoodsFlag IS NOT NULL AND @Color IS NOT NULL AND @SafetyStockLevel IS NOT NULL 
	AND @ReorderPoint IS NOT NULL AND @StandardCost IS NOT NULL AND @ListPrice IS NOT NULL 
	AND @Size IS NOT NULL AND @SizeUnitMeasureCode IS NOT NULL AND @WeightUnitMeasureCode IS NOT NULL 
	AND @Weight IS NOT NULL AND @DaysToManufacture IS NOT NULL AND @ProductLine IS NOT NULL 
	AND @Class IS NOT NULL AND @Style IS NOT NULL AND @ProductSubcategoryID IS NOT NULL 
	AND @ProductModelID IS NOT NULL AND @SellStartDate IS NOT NULL AND @SellEndDate IS NOT NULL 
	AND @DiscontinuedDate IS NOT NULL AND @rowguid IS NOT NULL AND @ModifiedDate IS NOT NULL)
    BEGIN
        INSERT INTO Production.Product(ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate, ProductModelID)
        VALUES (@ProductID, @Name, @ProductNumber, @Color, @StandardCost, @ListPrice, @SellStartDate, @ProductModelID)
        SELECT 'Success' AS Status
    END
    ELSE
    BEGIN
        SELECT 'Failed' AS Status
    END
END

-- BT9 --
CREATE PROCEDURE XoaHD 
    @SalesOrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Xóa các chi tiết hóa đơn trong bảng SalesOrderDetail
        DELETE FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;

        -- Xóa hóa đơn trong bảng SalesOrderHeader
        DELETE FROM Sales.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;

        COMMIT;
        PRINT 'Xóa hóa đơn thành công';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END

        PRINT 'Xóa hóa đơn thất bại';
    END CATCH
END

EXEC XoaHD @SalesOrderID = 43659;

-- BT10 --
CREATE PROCEDURE Sp_Update_Product
    @ProductID INT
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại hay không
    IF EXISTS (SELECT 1 FROM Production.Product WHERE ProductID = @ProductID)
    BEGIN
        -- Tăng giá ListPrice lên 10%
        UPDATE Production.Product
        SET ListPrice = ListPrice * 1.1
        WHERE ProductID = @ProductID
        
        -- Hiển thị thông báo cập nhật thành công
        SELECT 'Update successfully!' AS Result
    END
    ELSE
    BEGIN
        -- Hiển thị thông báo sản phẩm không tồn tại
        SELECT 'Product does not exist!' AS Result
    END
END
EXEC Sp_Update_Product @ProductID = 514;

-- FUNCTION --
-- BT1 --
CREATE FUNCTION CountOfEmployees (@deptID INT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT
    SELECT @count = COUNT(*) 
	FROM HumanResources.EmployeeDepartmentHistory
	WHERE DepartmentID = @deptID
    RETURN @count
END


SELECT d.DepartmentID, d.Name, dbo.CountOfEmployees(d.DepartmentID) AS countOfEmp
FROM HumanResources.Department d
ORDER BY countOfEmp DESC

-- BT2 --
CREATE FUNCTION InventoryProd (@ProductID INT, @LocationID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Inventory INT;
    SELECT 
		@Inventory = Quantity
    FROM 
		Production.ProductInventory
    WHERE 
		ProductID = @ProductID 
		AND LocationID = @LocationID;  
    RETURN @Inventory;
END


SELECT dbo.InventoryProd(316, 5) as 'Inventory'

-- BT3 --
CREATE FUNCTION SubTotalOfEmp (@EmpID INT, @MonthOrder INT, @YearOrder INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @SubTotal MONEY
    SELECT @SubTotal = SUM(D.UnitPrice * D.OrderQty)
    FROM Sales.SalesOrderHeader H
		JOIN Sales.SalesOrderDetail  D ON H.SalesOrderID = D.SalesOrderID
    WHERE H.SalesPersonID = @EmpID
    AND MONTH(H.OrderDate) = @MonthOrder
    AND YEAR(H.OrderDate) = @YearOrder
    RETURN @SubTotal
END

SELECT H.SalesPersonID, dbo.SubTotalOfEmp(H.SalesPersonID, 6, 2013) AS 'TotalRevenue'
FROM Sales.SalesOrderHeader H
WHERE YEAR(H.OrderDate) = 2013 AND MONTH(H.OrderDate) = 6
GROUP BY H.SalesPersonID



