-- BTVN Tuần 6 --

-- BT4 --
CREATE FUNCTION SumOfOrder (@thang INT, @nam INT)
RETURNS @DSHD TABLE
(
    SalesOrderID INT,
    OrderDate DATETIME,
    SubTotal MONEY
)
AS
BEGIN
    INSERT INTO @DSHD (SalesOrderID, OrderDate, SubTotal)
    SELECT 
        H.SalesOrderID, 
        H.OrderDate, 
        SUM(D.OrderQty * D.UnitPrice) AS SubTotal
    FROM 
        Sales.SalesOrderHeader H Join Sales.SalesOrderDetail D
		ON h.SalesOrderID = D.SalesOrderID
    WHERE 
        MONTH(OrderDate) = @thang 
        AND YEAR(OrderDate) = @nam 
    GROUP BY 
        H.SalesOrderID, 
        H.OrderDate
    HAVING 
        SUM(D.OrderQty * D.UnitPrice) > 70000
    RETURN
END


SELECT * FROM dbo.SumOfOrder(2, 2013)

-- BT5 --
CREATE FUNCTION NewBonus ()
RETURNS @DSNV TABLE
(
    SalesPersonID INT,
    NewBonus MONEY,
    SumOfSubTotal MONEY
)
AS
BEGIN
    INSERT INTO @DSNV (SalesPersonID, NewBonus, SumOfSubTotal)
    SELECT 
        P.BusinessEntityID, 
        P.Bonus + SUM(H.SubTotal)*0.01 AS NewBonus, 
        SUM(H.SubTotal) AS SumOfSubTotal
    FROM 
        Sales.SalesOrderHeader H
        INNER JOIN Sales.SalesPerson P ON H.SalesPersonID = P.BusinessEntityID
    GROUP BY 
        P.BusinessEntityID, 
        P.Bonus

    RETURN
END

SELECT * FROM dbo.NewBonus()

-- BT6 --
CREATE FUNCTION SumOfProduct (@MaNCC INT)
RETURNS @DSMH TABLE
(
    ProductID INT,
    SumOfQty INT,
    SumOfSubTotal MONEY
)
AS
BEGIN
    INSERT INTO @DSMH (ProductID, SumOfQty, SumOfSubTotal)
    SELECT 
        PurchaseOrderDetail.ProductID, 
        SUM(PurchaseOrderDetail.OrderQty) AS SumOfQty, 
        SUM(PurchaseOrderDetail.OrderQty * PurchaseOrderDetail.UnitPrice) AS SumOfSubTotal
    FROM 
        Purchasing.Vendor 
        INNER JOIN Purchasing.PurchaseOrderHeader ON Vendor.BusinessEntityID = PurchaseOrderHeader.VendorID 
        INNER JOIN Purchasing.PurchaseOrderDetail ON PurchaseOrderHeader.PurchaseOrderID = PurchaseOrderDetail.PurchaseOrderID 
    WHERE 
        Vendor.BusinessEntityID = @MaNCC 
    GROUP BY 
        PurchaseOrderDetail.ProductID

    RETURN
END


SELECT * FROM dbo.SumOfProduct(1496)

-- BT7 --
CREATE FUNCTION Discount_Func()
RETURNS TABLE
AS RETURN 
SELECT 
	SalesOrderID, 
	SubTotal,
	Discount = 
	(
	SELECT CASE	WHEN ([SubTotal])<1000 THEN 0
				WHEN ([SubTotal]) >=1000 and SubTotal <5000 THEN ([SubTotal])*0.05
				WHEN ([SubTotal]) >= 5000 and SubTotal<10000 THEN ([SubTotal])*0.1
				ELSE ([SubTotal])*0.15
			END
	)
FROM Sales.SalesOrderHeader 

SELECT * FROM dbo.Discount_Func()

-- BT8 --
CREATE FUNCTION TotalOfEmp (@MonthOrder INT, @YearOrder INT)
RETURNS @Result TABLE
(
    SalesPersonID INT,
    Total MONEY
)
AS
BEGIN
    INSERT INTO @Result (SalesPersonID, Total)
    SELECT 
        H.SalesPersonID, 
        SUM(H.SubTotal) AS Total
    FROM 
        Sales.SalesOrderHeader H
        INNER JOIN Sales.SalesOrderDetail D ON H.SalesOrderID = D.SalesOrderID 
    WHERE 
        MONTH(H.OrderDate) = @MonthOrder 
        AND YEAR(H.OrderDate) = @YearOrder 
    GROUP BY 
        H.SalesPersonID
    RETURN
END

SELECT * FROM dbo.TotalOfEmp(6, 2013)

-- BT10 --
CREATE FUNCTION SalaryOfEmp(@id int )
RETURNS @table TABLE (Id int,FName nvarchar(50),LName nvarchar(50),Salary money)
AS  BEGIN
	IF	@id IS NULL
		INSERT INTO @table
		SELECT 
			per.BusinessEntityID ID,
			per.FirstName FName,
			per.LastName LName,
			Emp.Rate Salary
		FROM 
			HumanResources.EmployeePayHistory Emp JOIN Person.Person per 
			ON Emp.BusinessEntityID = per.BusinessEntityID
		ORDER BY per.BusinessEntityID
		--trường hợp tham số NULL 
	ELSE
		INSERT INTO @table
		SELECT 
			per.BusinessEntityID ID,
			per.FirstName FName,
			per.LastName LName,
			Emp.Rate Salary
		FROM 
			HumanResources.EmployeePayHistory Emp JOIN Person.Person per 
			ON Emp.BusinessEntityID = per.BusinessEntityID
		WHERE 
			per.BusinessEntityID = @id

	RETURN
END

SELECT * FROM dbo.SalaryOfEmp(288)
SELECT * FROM dbo.SalaryOfEmp(NULL)