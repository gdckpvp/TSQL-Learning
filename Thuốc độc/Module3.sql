-- BTVN4 --
-- Module 3: view

-- BT1 --
CREATE VIEW dbo.vw_Products
AS
SELECT P.ProductID,P.Name,P.Color,P.Size,P.StandardCost,P.SellEndDate,P.SellStartDate
FROM Production.Product P JOIN Production.ProductCostHistory H 
ON P.ProductID = H.ProductID
GO

-- BT2 --
CREATE VIEW dbo.vw_List_Product_View
AS
SELECT P.ProductID,P.Name,Count(H.SalesOrderID) AS 'CountOfOrderID', SUM(SubTotal) AS 'SubTotal'
FROM 
	(Production.Product P JOIN Sales.SalesOrderDetail D ON P.ProductID = D.ProductID) 
	JOIN Sales.SalesOrderHeader H ON D.SalesOrderID = H.SalesOrderID
WHERE
	H.OrderDate BETWEEN '2008-01-01' AND '2008-03-31'
GROUP BY P.ProductID,P.Name
HAVING Count(H.SalesOrderID) > 500
	AND SUM(SubTotal) > 10000
GO


-- BT3 --
CREATE VIEW dbo.vw_CustomerTotals AS
SELECT 
    CustomerID, 
    YEAR(OrderDate) AS OrderYear, 
    MONTH(OrderDate) AS OrderMonth, 
    SUM(TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader
GROUP BY 
    CustomerID, YEAR(OrderDate), MONTH(OrderDate);
GO

-- BT4 --
CREATE VIEW dbo.vw_SalesPerson_Qty_ByYear AS
SELECT 
    H.SalesPersonID, 
    YEAR(H.OrderDate) AS 'OrderYear',
    SUM(CAST(OrderQty AS bigint)) AS 'sumOfOrderQty'
FROM 
    Sales.SalesOrderHeader H,Sales.SalesOrderDetail D
GROUP BY 
    H.SalesPersonID, 
    YEAR(H.OrderDate);
GO

-- BT5 --
CREATE VIEW dbo.vw_ListCustomer AS 
SELECT 
	P.BusinessEntityID AS 'PersonID',
	(P.FirstName + ' ' + P.MiddleName + ' ' + p.LastName) AS 'FullName',
	COUNT(H.SalesOrderID) AS 'CountOfOrders'
FROM
	Person.Person P,
	Sales.SalesOrderHeader H
WHERE
	P.BusinessEntityID = H.CustomerID
GROUP BY
	P.BusinessEntityID,
	(P.FirstName + ' ' + P.MiddleName + ' ' + p.LastName)
GO

-- BT6 --
CREATE VIEW dbo.vw_ListProduct AS 
SELECT 
	P.ProductID,
	P.Name,
	SUM(D.OrderQty) AS 'SumOfOrderQty',
	YEAR(H.OrderDate) AS 'OrderYear'
FROM
	(Sales.SalesOrderHeader H JOIN
	Sales.SalesOrderDetail D ON H.SalesOrderID = D.SalesOrderID) JOIN
	Production.Product P ON P.ProductID = D.ProductID
GROUP BY
	P.ProductID,
	P.Name,
	YEAR(H.OrderDate)	
GO

-- BT7 --
CREATE VIEW dbo.vw_ListDepartment_AvgOfRate
AS
SELECT 
	D.DepartmentID,
	D.Name AS 'Department Name',
	AVG(P.Rate) AS 'AvgOfRate'
FROM
	(HumanResources.Department D JOIN
	HumanResources.EmployeeDepartmentHistory H ON D.DepartmentID = H.DepartmentID) JOIN
	HumanResources.EmployeePayHistory P ON H.BusinessEntityID = P.BusinessEntityID
GROUP BY
	D.DepartmentID,
	D.Name
HAVING
	AVG(P.Rate) > 30;
GO

-- BT8 --
CREATE VIEW Sales.vw_OrderSummary
WITH ENCRYPTION
AS
SELECT 
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	SUM(TotalDue) AS OrderTotal
FROM
	Sales.SalesOrderHeader
GROUP BY 
	YEAR(OrderDate),
	MONTH(OrderDate)
GO

-- BT9 --
CREATE VIEW Production.vwProducts
WITH SCHEMABINDING
AS
SELECT 
	P.ProductID,
	P.Name,
	P.SellStartDate,
	P.SellEndDate,
	P.ListPrice
FROM 
	Production.Product P JOIN Production.ProductCostHistory C 
	ON P.ProductID = C.ProductID;
 /*Nếu ta muốn xóa cột ListPrice của bảng Product, thì ta không thể thực hiện được
 do view Production.vwProducts được ràng buộc với cột ListPrice trong bảng ProductCostHistory.
 Việc xóa cột ListPrice sẽ gây ra lỗi trong view vì cột này không còn tồn tại trong bảng Product.
 Do đó, ta phải sửa đổi view trước khi xóa cột ListPrice trong bảng Product.*/
 
 -- BT10 --
 CREATE VIEW Department
AS
SELECT DepartmentID, Name, GroupName
FROM HumanResources.Department
WHERE GroupName IN ('Manufacturing', 'Quality Assurance')
WITH CHECK OPTION;
--a
/*Nếu chèn thêm một phòng ban mới không thuộc hai nhóm "Manufacturing" 
hoặc "Quality Assurance" thông qua view vừa tạo, 
thì sẽ không chèn được do tính năng CHECK OPTION 
sẽ ngăn chặn việc thêm dữ liệu không hợp lệ vào bảng.*/
--b
/*
Nếu chèn thêm một phòng mới thuộc nhóm "Manufacturing" 
và một phòng mới thuộc nhóm "Quality Assurance" thông qua view, 
thì sẽ chèn được do các phòng này thỏa mãn điều kiện của view.
vd:
INSERT INTO Department (Name, GroupName) VALUES ('New Department 1', 'Manufacturing');
INSERT INTO Department (Name, GroupName) VALUES ('New Department 2', 'Quality Assurance');

*/
--c
SELECT * FROM HumanResources.Department;