----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE AdventureWorks2019
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN MODULE 1 ---
/*Tạo database*/
CREATE DATABASE Sales
ON      ( NAME = Sales_dat, FILENAME = 'D:\DoHoangThinh\Sales.mdf') 
LOG ON  ( NAME = Sales_log, FILENAME = 'D:\DoHoangThinh\Sales.ldf'); 
GO
-- BT1 --
/**/
USE [Sales]
GO
CREATE TYPE [dbo].[MoTa] FROM [nvarchar](40) NULL
GO
CREATE TYPE [dbo].[IDKH] FROM [char](10) NOT NULL
GO
CREATE TYPE [dbo].[DT] FROM [char](12) NULL
GO

-- BT2 --

CREATE TABLE KhachHang
(
	MaKH IDKH not null,
	TenKH varchar(30) not null,
	DiaChi varchar(40),
	DienThoai DT,
	PRIMARY KEY (MaKH)
)
GO
CREATE TABLE HoaDon
(
	MaHD char(10) not null,
	NgayLap Date not null,
	NgayGiao Date not null,
	MaKH IDKH not null,
	DienGiai Mota not null,
	PRIMARY KEY (MaHD),
	FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
)
GO
CREATE TABLE SanPham
(
	MaSP char(6) not null,
	TenSP varchar(50) not null,
	NgayNhap Date not null,
	DVT nvarchar(10) not null,
	SoLuongTon int not null,
	DonGiaNhap money not null,
	PRIMARY KEY (MaSP)
)
GO
CREATE TABLE ChiTietHD
(
	MaHD char(10) not null,
	MaSP char(6) not null,
	SoLuong int,
	FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
	FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
)
GO

-- BT3 --
ALTER TABLE HoaDon
	ALTER COLUMN DienGiai varchar(100)
GO

-- BT4 --
ALTER TABLE SanPham
	ADD TyLeHoaHong float
GO

-- BT5 --
USE [Sales]
GO
ALTER TABLE SanPham
	DROP COLUMN NgayNhap
GO

-- BT6 --
USE [Sales]
GO
ALTER TABLE ChiTietHD
	ADD CONSTRAINT FK_ChiTietHD_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD);
GO
ALTER TABLE ChiTietHD
	ADD CONSTRAINT FK_ChiTietHD_SanPham FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP);
GO

-- BT7 --
USE [Sales]
GO
ALTER TABLE HoaDon
ADD CONSTRAINT CK_NgayGiao_NgayLap CHECK (NgayGiao >= NgayLap);
GO
ALTER TABLE HoaDon
ADD CONSTRAINT CK_MaHD CHECK (MaHD LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9]');
GO
ALTER TABLE HoaDon
ADD CONSTRAINT DF_NgayLap DEFAULT GETDATE() FOR NgayLap;
GO

-- BT8 --
USE [Sales]
GO
ALTER TABLE SanPham 
	ADD CONSTRAINT CK_SoLuongTon CHECK (SoLuongTon Between 0 and 500);
GO
ALTER TABLE SanPham
	ADD CONSTRAINT CK_DonGiaNhap CHECK (DonGiaNhap > 0);
GO
ALTER TABLE SanPham
	ADD NgayNhap Date;
GO
Alter Table SanPham
	ADD CONSTRAINT DF_NgayNhap DEFAULT GETDATE() FOR NgayNhap;
GO
ALTER TABLE SanPham
	ADD CONSTRAINT CK_DVT CHECK (DVT IN ('Cái', 'Chiếc', 'Bộ', 'Hộp', 'Thùng'));
GO


-- BT9 --
USE [Sales]
GO
INSERT INTO KhachHang values('KH001','Nguyễn Văn A','Hà Nội','090000001')
INSERT INTO KhachHang values('KH002','Nguyễn Văn B','Hà Nội','090000002')
INSERT INTO KhachHang values('KH003','Nguyễn Văn C','Hà Nội','090000003')
INSERT INTO KhachHang values('KH004','Nguyễn Văn D','Hà Nội','090000004')
INSERT INTO KhachHang values('KH005','Nguyễn Văn E','Hà Nội','090000005')
INSERT INTO KhachHang values('KH006','Nguyễn Văn F','Hà Nội','090000006')
INSERT INTO KhachHang values('KH007','Nguyễn Văn G','Hà Nội','090000007')
INSERT INTO KhachHang values('KH008','Nguyễn Văn H','Hà Nội','090000008')
INSERT INTO KhachHang values('KH009','Nguyễn Văn I','Hà Nội','090000009')
INSERT INTO KhachHang values('KH010','Nguyễn Văn J','Hà Nội','090000010')
GO
INSERT INTO SanPham values('SP001','Table','Bộ',100,500000,0.1,'2019-01-01')
INSERT INTO SanPham values('SP002','Chair','Chiếc',100,100000,0.1,'2019-01-01')
INSERT INTO SanPham values('SP003','Fridge','Chiếc',100,5000000,0.1,'2019-01-01')
INSERT INTO SanPham values('SP004','Air Conditioner','Chiếc',100,5000000,0.1,'2019-01-01')
INSERT INTO SanPham values('SP005','Dishwasher','Chiếc',100,10000000,0.1,'2019-01-01')
INSERT INTO SanPham values('SP006','Vacuum Cleaner','Bộ',100,2000000,0.1,'2019-01-01')
go
INSERT INTO HoaDon values('HD0001','2019-01-01','2019-01-02','KH001','1 Chair')
INSERT INTO HoaDon values('HD0002','2019-01-01','2019-01-02','KH002','1 Table')
INSERT INTO HoaDon values('HD0003','2019-01-01','2019-01-02','KH003','1 Fridge')
INSERT INTO HoaDon values('HD0004','2019-01-01','2019-01-02','KH004','1 Air Conditioner')
INSERT INTO HoaDon values('HD0005','2019-01-01','2019-01-02','KH005','1 Dishwasher')
INSERT INTO HoaDon values('HD0006','2019-01-01','2019-01-02','KH006','1 Vacuum Cleaner')
INSERT INTO HoaDon values('HD0007','2019-01-01','2019-01-02','KH007','1 Chair')
INSERT INTO HoaDon values('HD0008','2019-01-01','2019-01-02','KH008','1 Table')
INSERT INTO HoaDon values('HD0009','2019-01-01','2019-01-02','KH009','1 Fridge')
INSERT INTO HoaDon values('HD0010','2019-01-01','2019-01-02','KH010','1 Air Conditioner')
INSERT INTO HoaDon values('HD0011','2019-01-01','2019-01-02','KH001','1 Dishwasher')
INSERT INTO HoaDon values('HD0012','2019-01-01','2019-01-02','KH002','1 Vacuum Cleaner')
INSERT INTO HoaDon values('HD0013','2019-01-01','2019-01-02','KH003','1 Chair')
INSERT INTO HoaDon values('HD0014','2019-01-01','2019-01-02','KH004','1 Table')
INSERT INTO HoaDon values('HD0015','2019-01-01','2019-01-02','KH005','1 Fridge')
INSERT INTO HoaDon values('HD0016','2019-01-01','2019-01-02','KH006','1 Air Conditioner')
INSERT INTO HoaDon values('HD0017','2019-01-01','2019-01-02','KH007','1 Dishwasher')
INSERT INTO HoaDon values('HD0018','2019-01-01','2019-01-02','KH008','1 Vacuum Cleaner')
INSERT INTO HoaDon values('HD0019','2019-01-01','2019-01-02','KH009','1 Chair')
INSERT INTO HoaDon values('HD0020','2019-01-01','2019-01-02','KH010','1 Table')
INSERT INTO HoaDon values('HD0021','2019-01-01','2019-01-02','KH001','1 Fridge')
INSERT INTO HoaDon values('HD0022','2019-01-01','2019-01-02','KH002','1 Air Conditioner')
INSERT INTO HoaDon values('HD0023','2019-01-01','2019-01-02','KH003','1 Dishwasher')
go
INSERT INTO ChiTietHD values('HD0001','SP002',1)
INSERT INTO ChiTietHD values('HD0002','SP001',1)
INSERT INTO ChiTietHD values('HD0003','SP003',1)
INSERT INTO ChiTietHD values('HD0004','SP004',1)
INSERT INTO ChiTietHD values('HD0005','SP005',1)
INSERT INTO ChiTietHD values('HD0006','SP006',1)
INSERT INTO ChiTietHD values('HD0007','SP002',1)
INSERT INTO ChiTietHD values('HD0008','SP001',1)
INSERT INTO ChiTietHD values('HD0009','SP003',1)
INSERT INTO ChiTietHD values('HD0010','SP004',1)
INSERT INTO ChiTietHD values('HD0011','SP005',1)
INSERT INTO ChiTietHD values('HD0012','SP006',1)
INSERT INTO ChiTietHD values('HD0013','SP002',1)
INSERT INTO ChiTietHD values('HD0014','SP001',1)
INSERT INTO ChiTietHD values('HD0015','SP003',1)
INSERT INTO ChiTietHD values('HD0016','SP004',1)
INSERT INTO ChiTietHD values('HD0017','SP005',1)
INSERT INTO ChiTietHD values('HD0018','SP006',1)
INSERT INTO ChiTietHD values('HD0019','SP002',1)
INSERT INTO ChiTietHD values('HD0020','SP001',1)
INSERT INTO ChiTietHD values('HD0021','SP003',1)
INSERT INTO ChiTietHD values('HD0022','SP004',1)
INSERT INTO ChiTietHD values('HD0023','SP005',1)
GO

-- BT10 --
USE [Sales]
GO
DELETE FROM ChiTietHD WHERE MaHD = 'HD0023'
GO
DELETE FROM HoaDon WHERE MaHD = 'HD0023'
GO

/*
Về lý thuyết nếu ta chỉ xóa một dòng bất kỳ ở HoaDon thì việc này là không thể 
vì nó vẫn còn ràng buộc dữ liệu ở bảng ghi khác cụ thể là ChiTietHoaDon
Nên để có thể xóa được thì ta cần phải xóa dữ liệu đó ở các bảng tham chiếu trước
rồi tiếp đến ta mới xóa giá trị gốc ban đầu được.
*/

-- BT11 --
/* 
Không, bởi vì trước đó ở BT7 ta đã thêm ràng buộc cho giá trị của cột MaHD
trong đó nó có chứa 6 ký tự gồm 2 ký tự đầu là chữ cái, 4 ký tự sau là số
nên với giá trị nhập vào theo yêu cầu đề bài thì nó sẽ báo lỗi không thể thực thi
*/

-- BT12 --
ALTER DATABASE Sales SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE Sales MODIFY NAME = BanHang;
GO
ALTER DATABASE BanHang SET MULTI_USER;
GO

-- BT13 --
ALTER DATABASE BanHang SET OFFLINE WITH ROLLBACK IMMEDIATE;
GO
/* 
Có thể chép được vì cơ bản là mình chỉ tạo ra thêm một bản sao của CSDL bán hàng ở chỗ khác mà thôi
nhưng để có thể sao chép được thì đầu tiên ta cần set chế độ offline cho database
sau khi sao chép thì ta thực hiện việc kết nối CSDL đó trở lại là mọi thứ lại hoạt động bình thường
*/

-- BT14 --
BACKUP DATABASE [BanHang] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\BanHang.bak' WITH NOFORMAT, NOINIT,  NAME = N'BanHang-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- BT15 --
DROP DATABASE BanHang
GO

-- BT16 --
RESTORE DATABASE BanHang From Disk = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\BanHang.bak' 
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN MODULE 2 ---
--Module 2: SubQuery
-- BT1 --
USE [Sales]
GO
SELECT PRName.Name, PR.ProductID
FROM Production.Product AS PRName, Sales.SalesOrderDetail AS PR, Sales.SalesOrderHeader AS ODD
WHERE
	PRName.ProductID = PR.ProductID
	AND PR.SalesOrderID = ODD.SalesOrderID
	AND ODD.OrderDate >= '2008-07-01' 
	AND ODD.OrderDate <= '2008-07-31'
GROUP BY
	PRName.Name, PR.ProductID
HAVING COUNT(ODD.SalesOrderID) > 100
GO

-- BT2 --
USE [Sales]
GO
SELECT PR.ProductID, PR.Name
FROM Production.Product AS PR, Sales.SalesOrderDetail AS DE, Sales.SalesOrderHeader AS HE
WHERE
	PR.ProductID = DE.ProductID
	AND DE.SalesOrderID = HE.SalesOrderID
	AND HE.OrderDate BETWEEN '2008-07-01' AND '2008-07-31'
GROUP BY PR.ProductID, PR.Name
ORDER BY Count(DE.ProductID) DESC
GO

-- BT3--
USE AdventureWorks2019
GO
SELECT
	Sale.CustomerID, 
	(Per.FirstName + ' ' +Per.LAStName) AS 'NameCustomer',
	Count(Sale.SalesOrderID) AS 'CountOfOrder'
FROM Sales.SalesOrderHeader AS Sale, Person.Person AS Per
WHERE 
	Per.BusinessEntityID = Sale.CustomerID
Group BY
	Sale.CustomerID,
	Per.FirstName + ' ' +Per.LAStName
HAVING
	Count(Sale.SalesOrderID) >= All
	(
		SELECT			
			Count(Sale.SalesOrderID)
		FROM Sales.SalesOrderHeader AS Sale, Person.Person AS Per
		WHERE 
			Per.BusinessEntityID = Sale.CustomerID
		Group BY
			Sale.CustomerID
	)
Order By
	Sale.CustomerID
GO
--BT4--
/*IN*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE p.ProductID IN (
    SELECT ProductID
    FROM Production.ProductModel AS pm
    WHERE 
		p.Name LIKE 'LONg-Sleeve Logo Jersey%'
		and p.ProductModelID = pm.ProductModelID
	)
GO

/*Exists*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE EXISTS (
    SELECT *
    FROM Production.ProductModel AS pm
    WHERE 
		p.Name LIKE 'LONg-Sleeve Logo Jersey%'
		and p.ProductModelID = pm.ProductModelID 
	)
GO

--BT5--
USE AdventureWorks2019
GO
SELECT 
	P.ProductModelID
FROM 
	Production.Product AS P
Group BY 
	P.ProductModelID
HAVING
	Max(P.ListPrice) > All
	(
		SELECT 
			AVG(P.ListPrice)
		FROM 
			Production.Product AS P
	)
GO

--BT6--
/*IN*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE p.ProductID IN (
    SELECT p.ProductID
    FROM Sales.SalesOrderDetail AS Sale
    WHERE 
		p.ProductID = Sale.ProductID
	HAVING Sum(Sale.OrderQty) > 5000
	)
GO

/*Exists*/
USE AdventureWorks2019
GO
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE EXISTS (
    SELECT *
    FROM Sales.SalesOrderDetail AS Sale
    WHERE 
		p.ProductID = Sale.ProductID
	HAVING Sum(Sale.OrderQty) > 5000
	)
GO

--BT7--
USE AdventureWorks2019
GO
SELECT
	ProductID,
	UnitPrice
FROM 
	Sales.SalesOrderDetail
Group BY
	ProductID,
	UnitPrice
HAVING
	UnitPrice >= ALL
	(
		SELECT UnitPrice
		FROM
			Sales.SalesOrderDetail
	)
GO

-- BT8 --
/*NOT IN*/
USE AdventureWorks2019
GO
SELECT
	P.ProductID,
	P.Name
FROM
	Production.Product AS P
WHERE
	P.ProductID NOT IN
	(
		SELECT Sale.ProductID
		FROM
			Sales.SalesOrderDetail AS Sale
	)
GO

/*NOT EXISTS*/
USE AdventureWorks2019
GO
SELECT P.ProductID, P.Name
FROM Production.Product AS P
WHERE
	NOT EXISTS
	(
		SELECT *
		FROM Sales.SalesOrderDetail AS S
		WHERE
			P.ProductID = S.ProductID
	)
GO

/*LEFT JOIN*/
USE AdventureWorks2019
GO
SELECT P.ProductID, P.Name
FROM Production.Product P Left JOIN Sales.SalesOrderDetail S 
	ON P.ProductID = S.ProductID
WHERE 
	S.ProductID IS null
GO

-- BT9 --
USE AdventureWorks2019
GO
SELECT ES.BusinessEntityID, E.FirstName , E.LAStName
FROM Person.Person E, Sales.SalesOrderHeader S, HumanResources.Employee AS ES
WHERE 
	E.BusinessEntityID = ES.BusinessEntityID
	AND not exists
	(
		SELECT E.BusinessEntityID
		FROM Person.Person E, Sales.SalesOrderHeader S
		WHERE
			E.BusinessEntityID = ES.BusinessEntityID
			AND E.BusinessEntityID = S.SalesPersonID
			AND S.OrderDate > '2007-05-01'
		Group by E.BusinessEntityID
	)
GROUP BY ES.BusinessEntityID, E.FirstName , E.LAStName
GO


-- BT10 --
USE AdventureWorks2019
GO
SELECT C.CustomerID, (E.FirstName + ' ' + E.LAStName) AS 'Name'
FROM (Person.Person E JOIN Sales.Customer AS C
	ON C.CustomerID = E.BusinessEntityID) JOIN Sales.SalesOrderHeader S
	ON C.CustomerID = S.CustomerID
WHERE C.CustomerID = E.BusinessEntityID
	AND S.OrderDate Between '2007-01-01' and '2007-12-31'
	AND C.CustomerID not in
	(
		SELECT C2.CustomerID
		FROM (Person.Person E JOIN Sales.Customer AS C2
			ON C2.CustomerID = E.BusinessEntityID) JOIN Sales.SalesOrderHeader S
			ON C2.CustomerID = S.CustomerID
		WHERE 
			S.OrderDate Between '2008-01-01' and '2008-12-31'
		GROUP BY C2.CustomerID
	)
GROUP BY C.CustomerID,(E.FirstName + ' ' + E.LAStName)
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN WEEK 3 ---
USE AdventureWorks2019
GO

-- BT1 --
USE AdventureWorks2019
GO
CREATE TABLE MyDepartment
(
	DepID SMALLINT NOT NULL PRIMARY KEY,
	DepName NVARCHAR(50),
	GrpName NVARCHAR(50)
)
GO
CREATE TABLE MyEmployee
(
	EmpID INT NOT NULL PRIMARY KEY,
	FrstName NVARCHAR(50),
	MidName NVARCHAR(50),
	LstName NVARCHAR(50),
	DepID SMALLINT NOT NULL FOREIGN KEY REFERENCES MyDepartment(DepID)
)
GO
-- BT2 --
USE AdventureWorks2019
GO
INSERT INTO MyDepartment 
SELECT D.DepartmentID,D.Name,D.GroupName
FROM HumanResources.Department AS D
GO

-- BT3 --
USE AdventureWorks2019
GO
INSERT INTO MyEmployee
SELECT TOP 20 E.BusinessEntityID,P.FirstName,P.MiddleName,P.LastName,E.DepartmentID
FROM HumanResources.EmployeeDepartmentHistory AS E JOIN Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID
GROUP BY E.BusinessEntityID,P.FirstName,P.MiddleName,P.LastName,E.DepartmentID
GO

-- BT4 --
DELETE FROM MyDepartment
WHERE DepID = 1

/*Được, bởi vì ở bảng MyEmployee không có hàng nào có giá trị DepID = 1
Trong trường hợp ta muốn xóa những giá trị khác mà ở bảng MyEmployee đang có DepID
thì ta phải xóa những hàng có giá trị DepID đó rồi mới xóa hàng có DepID đó ở bảng MyDepartment*/

-- BT5 --
INSERT INTO MyDepartment 
SELECT D.DepartmentID,D.Name,D.GroupName
FROM HumanResources.Department AS D
WHERE D.DepartmentID = 1
GO
Alter table MyEmployee
ADD CONSTRAINT DF_DepID DEFAULT 1 FOR DepID;

-- BT6 --
insert into MyEmployee (EmpID,FrstName,MidName,LstName)
values (1,'Nguyen','Nhat','Nam')

/*Giá trị của DepID = 1*/

-- BT7 --
ALTER TABLE MyEmployee DROP CONSTRAINT FK__MyEmploye__DepID__73DA2C14;
GO
ALTER TABLE MyEmployee ADD CONSTRAINT FK_MyEmployee_Department 
FOREIGN KEY (DepID) REFERENCES MyDepartment(DepID) ON DELETE SET DEFAULT;
GO

-- BT8 --
DELETE FROM MyDepartment
WHERE DepID = 7

-- BT9 --
ALTER TABLE MyEmployee 
DROP CONSTRAINT FK_MyEmployee_Department;

ALTER TABLE MyEmployee 
WITH CHECK ADD CONSTRAINT FK_MyEmployee_Department FOREIGN KEY (DepID) 
REFERENCES MyDepartment(DepID) ON DELETE CASCADE ON UPDATE CASCADE;

-- BT10 --
DELETE FROM MyDepartment WHERE DepID = 3
GO
/*Có thực hiện được*/

-- BT11 --
DELETE FROM MyDepartment
ALTER TABLE MyDepartment
ADD CONSTRAINT CHK_Department_GrpName CHECK (GrpName = 'Manufacturing');
GO

-- BT12 --
ALTER TABLE HumanResources.Employee 
DROP CONSTRAINT CK_Employee_BirthDate;
ALTER TABLE HumanResources.Employee
ADD CONSTRAINT CK_Employee_BirthDate 
CHECK (DATEDIFF(year, BirthDate, GETDATE()) BETWEEN 18 AND 60);
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- BTVN Module 3 ---

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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

-- BTVN Tuần 5 --
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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN Tuần 6 ---

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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN MODULE 5 ---

-- BT1 --
CREATE TABLE M_Department
(
	DepartmentID INT NOT NULL PRIMARY KEY,
	Name NVARCHAR(50),
	GroupName NVARCHAR(50)
)

GO
CREATE TABLE M_Employees 
(
	EmployeeID INT NOT NULL PRIMARY KEY,
	Firtname NVARCHAR(50),
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50),
	DepartmentID INT FOREIGN KEY REFERENCES M_Department(DepartmentID)
)
---Tạo view
	GO
	create view EmpDepart_View
	AS
		SELECT EmployeeID, Firtname, MiddleName, LastName, e.DepartmentID, Name, groupName
		FROM M_Employees e JOIN M_Department d ON e.DepartmentID=d.DepartmentID
	GO
---tạo trigger
	CREATE TRIGGER InsteadOf_Trigger ON EmpDepart_View
	INSTEAD OF INSERT
	AS	
		BEGIN
			INSERT M_Department
			SELECT DepartmentID, Name, groupName FROM inserted
			INSERT M_Employees
			SELECT EmployeeID, Firtname, MiddleName, LastName, DepartmentID
			FROM inserted
		END

---Insert dữ liệu để test trigger
	INSERT EmpDepart_View values(1, 'Nguyen','Hoang','Huy', 11,'Marketing','Sales')
	SELECT*FROM M_Department
	SELECT*FROM M_Employees 


-- BT2 --
CREATE TABLE MCustomer
(
	CustomerID INT NOT NULL PRIMARY KEY,
	CustPriority INT
)

CREATE TABLE MsalesOrders
(
	SalesOrderID INT NOT NULL PRIMARY KEY,
	OrderDate date,
	SubTotal money,
	CustomerID INT FOREIGN KEY REFERENCES MCustomer(customerID)
)
---Chèn dữ liệu cho bảng MCustomers
INSERT Mcustomer ([CustomerID],custpriority)
SELECT [CustomerID], null
FROM [Sales].[Customer]
WHERE CustomerID>30100 and CustomerID<30118 


---Chèn dữ liệu cho bảng MSalesOrders
INSERT MsalesOrders
SELECT [SalesOrderID],OrderDate, [SubTotal], [CustomerID]
FROM [Sales].[SalesOrderHeader]
WHERE CustomerID in (SELECT CustomerID FROM MCustomer)--chỉ lấy các hóa đơn của khách hàng có trong bảng MCustomer


--Tạo trigger
GO
CREATE TRIGGER SETPriority ON MsalesOrders
for INSERT, update, delete
AS
	WITH CTE AS (
		SELECT CustomerId FROM inserted
		union
		SELECT CustomerId FROM deleted
	) --- định nghĩa kết quả mà subquery trả về và đặt tên cho kết quả đấy
	UPDATE MCustomer
	SET CustPriority = case
							when t.Total < 10000 then 3
							when t.Total between 10000 and 50000 then 2
							when t.Total > 50000 then 1
							when t.Total IS NULL then NULL
						END
	FROM MCustomer cus INNER JOIN CTE ON CTE.CustomerId = cus.CustomerId
					 LEFT JOIN (SELECT MSalesOrders.CustomerID, SUM(SubTotal) Total
								FROM MSalesOrders inner JOIN CTE 
								ON CTE.CustomerId = MsalesOrders.CustomerId
								group by MsalesOrders.customerID) t ON t.CustomerId = cus.CustomerId

----test trigger
GO
INSERT MsalesOrders values(44054, '2012-01-01', 1000, 30102)
SELECT*FROM Mcustomer
WHERE CustomerId=30102
SELECT sum(SubTotal)FROM MsalesOrders WHERE CustomerID=30102



-- BT3 --
CREATE TABLE MDepartment
(
	DepartmentID INT NOT NULL PRIMARY KEY,
	Name NVARCHAR(50),
	NumOfEmployee INT
)

INSERT MDepartment
SELECT [DepartmentID],[Name], null
FROM [HumanResources].[Department]

CREATE TABLE MEmployees
(
	EmployeeID INT NOT NULL,
	Firtname NVARCHAR(50),
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50),
	DepartmentID INT FOREIGN KEY REFERENCES MDepartment(DepartmentID)
	constraINT pk_emp_depart PRIMARY KEY(EmployeeID, DepartmentID)
)
INSERT [MEmployees]
SELECT p.[BusinessEntityID], [FirstName],[MiddleName],[LastName], [DepartmentID]
FROM  
	[Person].[Person] p JOIN [HumanResources].[EmployeeDepartmentHistory] h 
	ON p.BusinessEntityID=h.BusinessEntityID


--tao trigger
GO
CREATE TRIGGER Update_NumOfEmp on [dbo].[Memployees]
for INSERT 
AS
	declare @numofEmp INT, @DepartID INT --khai báo 2 tham số chứa giá trị số lượng nhân viên và DepartmentID của record được insert
	SELECT @DepartID=inserted.DepartmentID FROM inserted 
	SET @numofEmp=(SELECT COUNT(*) 
			       FROM [dbo].[Memployees] e
			       WHERE e.DepartmentID=@DepartID
			      )
	if @numofEmp>200
	BEGIN
			prINT 'Bộ phận đã đủ nhân viên'
			rollback ---hủy giao tác khi đã đủ nhân viên
		END
	else
		update MDepartment
		SET NumOfEmployee =@numofEmp
		WHERE DepartmentID= @DepartID
GO
--test
INSERT [dbo].[Memployees] values(291, 'Bui',null,'Anh',1)
--kiem tra ket qua
SELECT *FROM MDepartment


-- BT4 --
CREATE TRIGGER CheckCredit ON Purchasing.PurchaseOrderHeader
AFTER INSERT
AS
IF EXISTS (SELECT *
           FROM Purchasing.PurchaseOrderHeader AS p 
				   JOIN inserted AS i ON p.PurchaseOrderID = i.PurchaseOrderID 
				   JOIN Purchasing.Vendor AS v ON v.BusinessEntityID = p.VendorID
           WHERE v.CreditRating = 5
          )
BEGIN
	RAISERROR ('A vendor''s credit rating is too low to accept new purchase orders.', 16, 1);
	ROLLBACK TRANSACTION;
END;
GO

-- BT5 --
CREATE TRIGGER UpdateQuantity ON Sales.SalesOrderDetail
after INSERT
AS 
	BEGIN
		declare @ordqty INT, @quantity INT, @masp INT
		SELECT @masp =i.ProductID FROM inserted i
		SELECT @ordqty=i.OrderQty FROM inserted i
		SET @quantity=(SELECT Quantity FROM Production.ProductInventory 
						WHERE productID=@masp)
		if @ordqty<@quantity
			update Production.ProductInventory
			SET quantity=quantity-@ordqty
			WHERE ProductID=@masp
		else			
				prINT 'Kho het hang'
				rollback transaction			
	END



-- BT6 --
GO
CREATE TABLE M_SalesPerson
(
	SalePSID INT NOT NULL PRIMARY KEY,
	TerritoryID INT,
	BonusPS money
)
CREATE TABLE M_SalesOrderHeader
(
	SalesOrdID INT NOT NULL PRIMARY KEY,
	OrderDate date,
	SubTotalOrd money,
	SalePSID INT FOREIGN KEY REFERENCES M_SalesPerson(SalePSID)
)
--insert dữ liệu

INSERT M_SalesPerson 
SELECT BusinessEntityID,TerritoryID,Bonus  FROM Sales.SalesPerson

INSERT M_SalesOrderHeader
SELECT SalesOrderID,OrderDate,SubTotal,SalesPersonID FROM Sales.SalesOrderHeader

--tạo trigger
GO
CREATE TRIGGER UpdateEmpBonus ON M_SalesOrderHeader
for INSERT
AS
	BEGIN
		declare @total money, @spersonID INT
		SELECT @spersonID= i.SalePSID  FROM inserted i
		SET @total=(SELECT sum([SubTotalOrd]) 
				 FROM [dbo].[M_SalesOrderHeader] 
				 WHERE SalePSID=@spersonID)
		if @total>10000000
		BEGIN
			update [dbo].[M_SalesPerson] 
			SET BonusPS=BonusPS*1.1
			WHERE SalePSID=@spersonID
		END
	END


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN MODULE 6 ---
-- BT1 --
USE [master]
GO
ALTER LOGIN [sa] WITH PASSWORD=N'sa'
GO
ALTER LOGIN [sa] ENABLE
GO

-- BT2 --
USE [master]
GO
CREATE LOGIN [User3] WITH PASSWORD=N'user3' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

USE [master]
GO
CREATE LOGIN [User2] WITH PASSWORD=N'user2' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO


-- BT3 --
USE [AdventureWorks2019]
GO
CREATE USER [User2] FOR LOGIN [User2]
GO

USE [AdventureWorks2019]
GO
CREATE USER [User3] FOR LOGIN [User3]
GO


-- BT4 --
/*không thể thực hiện SELECT trên user2*/
-- BT5 --
USE AdventureWorks2019
--cấp quyền SELECT cho User2
GRANT SELECT ON AdventureWorks2019.HumanResources.Employee TO User2

--xóa quyền SELECT
REVOKE SELECT ON AdventureWorks2019.HumanResources.Employee TO User2


-- BT6 --
USE [AdventureWorks2019]
GO
CREATE ROLE [Employee_Role]
GO

GRANT SELECT, DELETE, UPDATE TO Employee_Role

-- BT7 --
--Add User2 và User3 vào Employee_Role
USE [AdventureWorks2019]
GO
ALTER ROLE [Employee_Role] ADD MEMBER [User2]
GO
USE [AdventureWorks2019]
GO
ALTER ROLE [Employee_Role] ADD MEMBER [User3]
GO
---SELECT xem thông tin bảng Employee với User2
SELECT * FROM HumanResources.Employee

---UPDATE với User3
UPDATE HumanResources.Employee SET JobTitle='Sale Manager' WHERE BusinessEntityID=1

---Xem lại kết quả bằng User2 thì đã thấy dữ liệu được cập nhật
----Quá trình xóa Employee_Role
USE [AdventureWorks2019]
GO

DECLARE @RoleName sysname
SET @RoleName = N'Employee_Role'

IF @RoleName <> N'public' and (SELECT is_fixed_role FROM sys.database_principals WHERE name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    SELECT [name]
    FROM sys.database_principals 
    WHERE principal_id in ( 
        SELECT member_principal_id
        FROM sys.database_role_members
        WHERE role_principal_id in (
            SELECT principal_id
            FROM sys.database_principals WHERE [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    INTO @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        INTO @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
/****** Object:  DatabaseRole [Employee_Role]    Script Date: 2/21/2023 11:52:42 AM ******/
DROP ROLE [Employee_Role]
GO



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN MODULE 7 ---
-- BT1 --
----1a: chèn dữ liệu vào Department bằng BEGIN tran và rollback
BEGIN TRAN;
SET identity_INSERT HumanResources.Department on
INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName) VALUES(18,'Machine Learning','Security')
SELECT*FROM HumanResources.Department
ROLLBACK;
--Rollback sẽ hoàn tác các TRANSACTION vừa chạy và trả về dữ liệu như ban đầu

SELECT*FROM HumanResources.Department

----1b:
BEGIN TRAN
INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName) VALUES(18,'Machine Learning','Security')
SELECT*FROM HumanResources.Department
ROLLBACK;
SELECT*FROM HumanResources.Department
COMMIT
--dữ liệu đã được lưu vào database khi dùng cômmit

-- BT2 --
SET IMPLICIT_TRANSACTIONS OFF;
BEGIN TRAN
INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName) VALUES(19,'Deep Learning','AI')
CREATE TABLE Test (id INT NOT NULL PRIMARY KEY, s VARCHAR(30), si SMALLINT);
INSERT INTO Test (id, s) VALUES (1, 'first');
ROLLBACK
SELECT*FROM HumanResources.Department
SELECT*FROM Test


-- BT3 --
SET XACT_ABORT ON;  
--SET IMPLICIT_TRANSACTIONS ON;
SELECT 1/0 AS Dummy;  -- division by zero
UPDATE HumanResources.Department SET Name='@@' WHERE DepartmentID=999
DELETE HumanResources.Department WHERE DepartmentID=66
INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName) VALUES(25,'Foreign Investment','Invest')
COMMIT;

--báo lỗi không thể thực hiện phép chia cho 0

-- BT4 --
GO
SET XACT_ABORT OFF
SELECT 1/0 AS Dummy;  -- division by zero
UPDATE HumanResources.Department SET Name='@@' WHERE DepartmentID=999
DELETE HumanResources.Department WHERE DepartmentID=66
INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName) VALUES(25,'Foreign Investment','Invest')
COMMIT
SELECT * FROM HumanResources.Department;
---măc dù không tồn tại ID nhưng TRANSACTION vẫn thực hiện tiếp tục các câu lệnh sau đó 
---vì thế mà dữ liệu mới đã được thêm vào bảng Department


----------CONCURRENT TRANSACTIONS
-- BT1 -- tạo bảng account
CREATE TABLE Accounts (
AccountID  int NOT NULL PRIMARY KEY,
balance int NOT NULL 
        CONSTRAINT unloanable_account CHECK (balance >= 0)
);

INSERT INTO Accounts (AccountID,balance) VALUES (101,1000);
INSERT INTO Accounts (AccountID,balance) VALUES (202,2000);


-- BT3 --
----CLient A:
SET TRANSACTION ISOLATION LEVEL READ commited
BEGIN tran
SELECT*FROM Accounts WHERE AccountID=101
UPDATE Accounts SET balance=1000-200 WHERE AccountID=101
SELECT*FROM Accounts WHERE AccountID=101
COMMIT;


-----Client B:
SET TRANSACTION ISOLATION LEVEL READ commited
BEGIN tran
SELECT*FROM Accounts WHERE AccountID=101
UPDATE Accounts SET balance=1000-500 WHERE AccountID=101
SELECT*FROM Accounts WHERE AccountID=101
COMMIT;

---kết quả hiện thị 2 bảng với 2 giá trị balance là 800 và 500 do 2 TRANSACTION chạy độc lập với nhau
---kết quả cuối mà balance của Account 101 sẽ nhận là 500



-- BT5 --
Use AdventureWorks2019
----ClientA
SET TRANSACTION ISOLATION LEVEL READ commited
BEGIN tran
UPDATE Accounts SET balance=balance-100 WHERE AccountID=101
UPDATE Accounts SET balance = balance + 100 WHERE AccountID = 202;
COMMIT

use AdventureWorks2019
--ClientB:
SET TRANSACTION ISOLATION LEVEL READ commited
BEGIN tran
UPDATE Accounts SET balance = balance - 200 WHERE AccountID = 202;
UPDATE Accounts SET balance = balance + 200 WHERE AccountID = 101;

COMMIT


-- BT6 --
DELETE FROM Accounts;
INSERT INTO Accounts (AccountID,balance) VALUES (101,1000);
INSERT INTO Accounts (AccountID,balance) VALUES (202,2000);

---ClientA:
BEGIN tran 
UPDATE Accounts SET balance =balance-100 WHERE AccountID=101
UPDATE Accounts SET balance = balance + 100 WHERE AccountID = 202;
ROLLBACK;
SELECT*FROM Accounts;
COMMIT;

---Client B:
BEGIN tran
SET tran ISOLATION LEVEL READ uncommited 
SELECT*FROM Accounts
COMMIT;

---sau khi sử dụng lệnh rollback ở TRANSACTION client A thì các tasks chưa COMMIT ở client A đã được hoàn tác và trả về giá trị balance band dầu của các account



-- BT7 --
SET IMPLICIT_TRANSACTIONS ON; 
DELETE FROM Accounts;
INSERT INTO Accounts (AccountID,balance) VALUES (101,1000);
INSERT INTO Accounts (AccountID,balance) VALUES (202,2000);
COMMIT;


---ClientA: 
SET tran isolation level repeatable read
SELECT * FROM Accounts WHERE balance > 1000;


---ClientB:
SET IMPLICIT_TRANSACTIONS ON; 
INSERT INTO Accounts (AccountID,balance) VALUES (303,3000);
COMMIT;

---Client A:
SELECT * FROM Accounts WHERE balance > 1000;

COMMIT;

---kết quả có 2 ID 202 và 303 vì 2 account này có balance >1000


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BTVN MODULE 8 ---
-- BT1 --
BACKUP DATABASE [AdventureWorks2019] 
TO DISK = N'D:\backup\adv2019back' WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- BT2 --
USE [master] ;  
ALTER DATABASE AdventureWorks2019 SET RECOVERY FULL ;  
BACKUP DATABASE [AdventureWorks2019] 
TO DISK = N'D:\backup\adv2019back' WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- BT3 --
use AdventureWorks2019
BEGIN tran
declare @sumBike money, @sumAll money
SET @sumBike=(SELECT sum(ListPrice) 
FROM 
	Production.Product product join Production.ProductSubCategory sub 
	on product.ProductSubcategoryID=sub.ProductSubcategoryID join Production.ProductCategory cate 
	on sub.ProductCategoryID=cate.ProductCategoryID
WHERE 
	cate.Name='Bikes')
SET @sumAll=(SELECT sum(ListPrice) 
FROM Production.Product product join Production.ProductSubCategory sub 
	on product.ProductSubcategoryID=sub.ProductSubcategoryID join Production.ProductCategory cate 
	on sub.ProductCategoryID=cate.ProductCategoryID)
if @sumBike >=@sumAll*0.6
	UPDATE Production.Product SET ListPrice=15 
	WHERE ProductSubcategoryID=1										 
COMMIT;


-- BT4 --
---4a differential backup
BACKUP DATABASE [AdventureWorks2019] 
TO DISK = N'D:\backup\adv2019back' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


----4b TRANSACTION log backup
BACKUP LOG [AdventureWorks2019] 
TO DISK = N'D:\backup\adv2019back' WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks2019-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO