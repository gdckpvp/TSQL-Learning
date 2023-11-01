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