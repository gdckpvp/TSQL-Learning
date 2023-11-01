-- BTVN3 --
-- BTVN WEEK 3
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
