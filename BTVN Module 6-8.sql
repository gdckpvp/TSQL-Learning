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