--------------------------------------------------------------------------------


----------------        MODULE 1        -------------------
---Câu 2: tạo cơ sở dữ liệu tên SmallWorks với 2 file group SWUserData1 và SWUserData2
CREATE DATABASE SmallWorks 
ON 
PRIMARY 
(   
	NAME = 'SmallWorksPrimary',  
	FILENAME = 'D:\BUILEHAITRIEU\SmallWorks.mdf',  
	SIZE = 10MB, 
	FILEGROWTH = 20%,  
	MAXSIZE = 50MB 
), 
FILEGROUP SWUserData1 
(   
	NAME = 'SmallWorksData1', 
	FILENAME = 'D:\BUILEHAITRIEU\SmallWorksData1.ndf', 
	SIZE = 10MB,  
	FILEGROWTH = 20%,  
	MAXSIZE = 50MB 
),
FILEGROUP SWUserData2 
(  
	NAME = 'SmallWorksData2',  
	FILENAME = 'D:\BUILEHAITRIEU\SmallWorksData2.ndf',  
	SIZE = 10MB,  
	FILEGROWTH = 20%, 
	MAXSIZE = 50MB 
) 
LOG ON 
(   
	NAME = 'SmallWorks_log',  
	FILENAME = 'D:\BUILEHAITRIEU\SmallWorks_log.ldf',  
	SIZE = 10MB,  
	FILEGROWTH = 10%,  
	MAXSIZE = 20MB 
)
-----Câu 3: Xem kết quả
----3a: Có 3 filegroup: PRIMARY, SWUserData1, SWUserData2
----3b: filegroup mặc định là PRIMARY



-----Câu 4: Tạo thêm một file group Test1FG1, add 2 file filedat1.ndf và filedat2.ndf 5MB vào filegroup vừa tạo
----Thêm filegroup Test1FG1 vào database SmallWorks
	alter database SmallWorks
	add filegroup Test1FG1
---- Thêm file vào Test1FG1
	alter database SmallWorks
	add file
	(
		NAME='filedat1',
		FILENAME = 'D:\BUILEHAITRIEU\filedat1.ndf', 
		SIZE = 5MB,  
		FILEGROWTH = 20%, 
		MAXSIZE = 50MB 
	) ,
	(
		NAME='filedat2',
		FILENAME = 'D:\BUILEHAITRIEU\filedat2.ndf', 
		SIZE = 5MB,  
		FILEGROWTH = 20%, 
		MAXSIZE = 50MB 
	) 
	to filegroup  Test1FG1
---File group Test1FG1 chứa 2 file filedat1 và filedat2 đã được thêm vào 




-------Câu 5: 
----Thêm filedat3 vào filegroup Test1FG1
ALTER DATABASE SmallWorks
ADD FILE 
(
	NAME='filedat3',
	FILENAME = 'D:\BUILEHAITRIEU\filedat3.ndf', 
	SIZE = 3MB,  
	FILEGROWTH = 20%, 
	MAXSIZE = 50MB 
)
to FILEGROUP  Test1FG1

----Chỉnh sửa kích thước tập tin lên 5MB
ALTER DATABASE SmallWorks
MODIFY FILE 
(	
	NAME = 'filedat3', 
	SIZE = 5MB
)



-------Câu 6: Xóa filegroup Test1FG1
ALTER DATABASE SmallWorks
REMOVE FILEGROUP Test1FG1
--Không thể thực hiện xóa filegroup vì file không rỗng. Nếu muốn xóa thì trước hết cần xóa hết các file bên trong filegroup rồi mới thực hiện xóa filegroup


------Câu 7:
sp_helpDb SmallWorks
 ---Thể hiện tên, kích thước, tên server trên sql, ID của cơ sở dữ liệ, trạng thái, cấp độ tương thích
use SmallWorks
sp_spaceUsed 
---trả về kích thước không gian của cơ sở dữ liệu hiện tại

sp_helpFile 
---trả về thông tin các file có trong cơ sở dữ liệu hiện tại




-------Câu 8: 
ALTER DATABASE SmallWorks set read_only 
---set readonly cho database thì bên cạnh tên database có thể hiện (read-only) và database bị khóa

alter database SmallWorks set read_write
---set read_write để gỡ thuộc tính read_only
alter database SmallWorks set multi_user
---set multi user cho phép nhiều người sử dụng database cùng lúc


-----Câu 9: Tạo 2 bảng mới trong SmallWorks
--Tạo bảng Person có các cột và thuộc tính như sau
Use SmallWorks
create table dbo.Person
(
	PersonID int not null, 
	FirstName varchar(50) not null,
	MiddleName varchar(50) null,
	LastName varchar(50) not null,
	EmailAddress nvarchar(50) null,
) on SWUserData1

---Tạo bảng Product có các cột và thuộc tính như sau
create table dbo.Product
(
	ProductID int not null,
	ProductName varchar(75) not null,
	ProductNumber nvarchar(25) not null,
	StandardCost money not null,
	ListPrice money not null,
) on SWUSerData2


------Câu 10: Chèn dữ liệu vào 2 bảng trên, lấy dữ liệu từ bảng Person và Prodcut từ AdventureWorks2008
insert into Person(PersonID,FirstName,MiddleName,LastName,EmailAddress)
select a.BusinessEntityID,FirstName,MiddleName,LastName,EmailAddress
from [AdventureWorks2008R2].Person.Person a,[AdventureWorks2008R2].Person.EmailAddress b
where a.BusinessEntityID=b.BusinessEntityID
----insert dữ liệu vào các cột của bảng Person trong đó: BusinessEntityID, FirstName, MiddleName, LastName và EmailAddress từ bảng Person và EmailAddress của AdventureWorks 
----kết hợp thêm điều kiện where: BusinessEntityID ở bảng Person phải bằng BusinessEntityID ở bảng EmailAddress vì cả 2 bảng đều có BusinessEntity nên nếu không có điều kiện thì khi chạy lệnh sẽ báo  lỗi



insert into Product(ProductID, ProductName, ProductNumber, StandardCost, ListPrice)
select ProductID, Name, ProductNumber, StandardCost, ListPrice
from AdventureWorks2008R2.Production.Product
---Insert dữ liệu vào bảng Product từ Product ở database AdventureWorks2008R2
---Vì bảng Product ở AdventureWorks đã có đủ các cột dữ liệu cần thiết nên ở đây không cần thêm điều kiện kết hợp nào 



----------------------------------------------------------------------------------------------------------
---------------------------------------       MODULE 2      ------------------------------------------------
--------I)
-------câu 1: liệt kê danh sách các hóa đơn:(SalesOrderID) lặp trong tháng 6 năm 2008 có tổng tiền >70000, 
--thông tin gồm SalesOrderID, Orderdate, SubTotal, trong đó SubTotal =SUM(OrderQty*UnitPrice). 
USE AdventureWorks2008R2
select a.SalesOrderID, OrderDate, SubTotal=sum(OrderQty * UnitPrice)-- chọn các cột SalesOrderID, OrderDate và Subtotal có giá trị bằng biểu thức như trên
	from Sales.SalesOrderDetail a join Sales.SalesOrderHeader b on a.SalesOrderID = b.SalesOrderID--kết hợp 2 bảng với điều kiện SalesOrderID bằng nhau
	where  MONTH(OrderDate) = 6 and YEAR(OrderDate) = 2008  --điều kiện tháng và năm của OrderDate bằng 6 và 2008
	group by a.SalesOrderID, OrderDate -- nhóm các hóa đơn có ID, ngày order giống nhau lại
	having SUM(OrderQty * UnitPrice) > 70000 -- điều kiện tổng tiền hóa đơn >70000



-------Câu 2: Đếm tổng số khách hàng và tổng tiền của những khách có mã vùng US
select a.TerritoryID, CountofCus= COUNT(c.CustomerID) , Subtotal=SUM(d.OrderQty * d.UnitPrice)  --chọn các cột TerritoryID, CoutofCus là tổng khách, Subtotal là tổng tiền
	from Sales.SalesTerritory a join Sales.Customer  b on a.TerritoryID=b.TerritoryID
								join Sales.SalesOrderHeader c on b.CustomerID=c.CustomerID
								join Sales.SalesOrderDetail d on c.SalesOrderID=d.SalesOrderID
								----kết hợp các bảng cùng các ID bằng nhau 
	where CountryRegionCode = 'US' --điều kiện mã vùng US
	group by a.TerritoryID----nhóm các record theo TerritoryID


------Câu 3:Tính tổng giá trị của những hóa đơn với CarrierTrackingNumber có 3 kí tự đầu là 4BD
select SalesOrderID, CarrierTrackingNumber, Subtotal=SUM(OrderQty * UnitPrice) 
	from Sales.SalesOrderDetail
	where left(CarrierTrackingNumber,3)  like '4BD%' ---Điều kiện 3 kí tự đầu từ trái qua là 4BD
	group by SalesOrderID, CarrierTrackingNumber

-----Câu 4: Liệt kê các Product có UnitPrice<25 và số lượng bán trung bình>5
select b.ProductID,Name,AverageOfQty=AVG(a.OrderQty) 
	from Sales.SalesOrderDetail a join Production.Product b on a.ProductID = b.ProductID--kết hợp 2 bảng theo ProductID
	where a.UnitPrice < 25 --Điều kiện UnitPrice<25
	group by b.ProductID, b.Name
	having AVG(a.OrderQty) > 5 --số lượng bán trung bình >5

-----Câu 5: Liệt kê các công việc có tổng số nhân viên >20
select JobTitle,CountOfPerson=Count(BusinessEntityID)
	from HumanResources.Employee
	group by JobTitle
	having Count(BusinessEntityID)>20 --Điều kiện tổng nhân viên lớn hơn 20

----Câu 6: Tính tổng số lượng và tổng trị giá của các sản phẩm do các nhà cung cấp có tên kết thúc bằng ‘Bicycles’ và tổng trị giá >800000, 
--thông tin gồm BusinessEntityID, Vendor_name, ProductID, sumofQty, SubTotal (sử dụng các bảng [Purchasing].[Vendor] [Purchasing].
--[PurchaseOrderHeader] và [Purchasing].[PurchaseOrderDetail])
select a.BusinessEntityID, a.Name, ProductID, SumOfQty = SUM(OrderQty), SubTotal = SUM(OrderQty * UnitPrice)
	from Purchasing.Vendor a join Purchasing.PurchaseOrderHeader b on b.VendorID = a.BusinessEntityID 
							 join Purchasing.PurchaseOrderDetail d on b.PurchaseOrderID = d.PurchaseOrderID
							 --kết hợp các bảng với các ID tương ứng
	where a.Name like '%Bicycles' --Điều kiện tên kết thúc là Bicycles
	group by a.BusinessEntityID, a.Name, ProductID
	having SUM(OrderQty * UnitPrice) > 800000 --điều kiện tổng giá trị >800000


-----Câu 7:Liệt kê các sản phẩm có trên 500 đơn đặt hàng trong quí 1 năm 2008 và có tổng trị giá >10000, thông tin gồm ProductID, Product_name, countofOrderID và Subtotal
select a.ProductID,a.Name Product_Name,CountOfOrderID=count(b.SalesOrderID),Subtotal=SUM(OrderQty * UnitPrice)
	from Production.Product a join Sales.SalesOrderDetail b on a.ProductID = b.ProductID
							  join sales.SalesOrderHeader c on c.SalesOrderID = b.SalesOrderID
							  --kết hợp các bảng với các ID tương ứng
	where Datepart(QUARTER, OrderDate) =1 and YEAR(OrderDate) = 2008 --điều kiện quý 1 và năm 2008
	group by a.ProductID, a.Name
	having sum(OrderQty * UnitPrice) > 10000 and COUNT(b.SalesOrderID) > 500 --tổng giá trị đơn >10000 và số lượng đơn lớn hơn 500


-----Câu 8:Liệt kê danh sách các khách hàng có trên 25 hóa đơn đặt hàng từ năm 2007 đến 2008, 
--thông tin gồm mã khách (PersonID) , họ tên (FirstName +' '+ LastName as FullName), Số hóa đơn (CountOfOrders). 

select PersonID, FirstName +' '+ LastName  FullName, CountOfOrders=count(*)
	from Person.Person p join Sales.Customer c on p.BusinessEntityID=c.CustomerID
						 join Sales.SalesOrderHeader ord on ord.CustomerID= c.CustomerID
	where YEAR([OrderDate])>=2007 and YEAR([OrderDate])<=2008 --điều kiện thời gian từ 2007 đến 2008
	group by PersonID, FirstName +' '+ LastName
	having count(*)>25 --tổng số lượng đơn hàng lớn hơn 25


-----Câu 9: Liệt kê những sản phẩm có tên bắt đầu với ‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi mỗi năm trên 500 sản phẩm, 
-- gồm ProductID, Name, CountOfOrderQty, Year. (dữ liệu lấy từ các bảng  Sales.SalesOrderHeader, Sales.SalesOrderDetail và Production.Product) 
select product.ProductID,product.Name, CountOfOrderQty=Sum(OrderQty),Year=YEAR(OrderDate)
	from Production.Product product join Sales.SalesOrderDetail ordDetail on product.ProductID=ordDetail.ProductID
									join Sales.SalesOrderHeader ordDate on ordDetail.SalesOrderID=ordDate.SalesOrderID
								--kết hợp các bảng với ID tương ứng
	where product.Name like 'Bike%'  or product.Name like 'Sport%' --Kí tự bắt đầu là Bike hoặc Sport
	group by product.ProductID,product.Name,YEAR(OrderDate)
	having Sum(OrderQty)>500 --- xét tổng đơn hàng lớn hơn 500


----Câu 10: Liệt kê những phòng ban có lương (Rate: lương theo giờ) trung bình >30, 
-- thông tin gồm Mã phòng ban (DepartmentID), tên phòng ban (name), Lương trung bình (AvgofRate). 
-- Dữ liệu từ các bảng [HumanResources].[Department],  [HumanResources].[EmployeeDepartmentHistory],[HumanResources].[EmployeePayHistory]
select dep.DepartmentID, dep.Name, AvgofRate=avg([Rate])
	from [HumanResources].[Department] dep join [HumanResources].[EmployeeDepartmentHistory] h on dep.DepartmentID=h.DepartmentID
									   join [HumanResources].[EmployeePayHistory] emp on h.BusinessEntityID=emp.BusinessEntityID
									   --Kết hợp các bảng với các ID tương ứng
	group by dep.DepartmentID, dep.name
	having avg([Rate])>30--xét lương trung bình lớn hơn 30



-------II)Subquery
-----Câu 1:Liệt kê các sản phẩm gồm các thông tin product names và product ID có trên 100 đơn đặt hàng trong tháng 7 năm 2008
select ProductID, Name
from Production.Product
where ProductID in (select ProductID
					from  Sales.SalesOrderDetail d join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
					where MONTH(OrderDate)=7 and YEAR(OrderDate)=2008 -- điều kiện tháng 7 2008
					group by  ProductID
					having COUNT(*)>100) --xét cái productID có trên 100 đơn 
					-- subquery trả về table chứa các productID của các sản phẩm có trên 100 đơn hàng trong tháng 7/2008

-----Câu 2:Liệt kê các sản phẩm (ProductID, name) có số hóa đơn đặt hàng nhiều nhất trong tháng 7/2008
select p.ProductID, Name
from Production.Product p join Sales.SalesOrderDetail d on p.ProductID=d.ProductID
	                      join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
where  MONTH(OrderDate)=7 and YEAR(OrderDate)=2008
group by p.ProductID, Name
having COUNT(*)>=all( select COUNT(*)
					  from Sales.SalesOrderDetail d join Sales.SalesOrderHeader h on d.SalesOrderID=h.SalesOrderID
	                  where MONTH(OrderDate)=7 and YEAR(OrderDate)=2008
					  group by ProductID
					  )
					  ---subquery trả về bảng chứa số lần đặt hàng của các sản ph trong tháng 7/2008
---điều kiện having trả về  sản phẩm có số lần đặt hàng lớn hơn hoặc bằng tất cả dữ liệu mà subquery vừa trả về  
--( cũng có thể hiểu là so sánh lớn hơn hoặc bằng với giá trị lớn nhất mà subquery trả về)


-----Câu 3: Hiển thị thông tin của khách hàng có số đơn đặt hàng nhieuefu nhất: CustomerID, Name,CountOfOrder
select sales.[CustomerID],LastName ,CountOfOrder=count(*)
from [Sales].[SalesOrderHeader] sales,Person.Person per
where sales.CustomerID=per.BusinessEntityID
group by [CustomerID],per.LastName
having count(*)>=all(	select count(*)
						from [Sales].[SalesOrderHeader]
						group by [CustomerID]
						)
						--subquery sẽ trả về tổng số đơn hàng của mỗi khách hàng 
---điều kiện having trả về  thông tin khách hàng có số lần đặt hàng lớn hơn hoặc bằng với giá trị lớn nhất mà subquery trả về



-----Câu 4: Liệt kê các sản phẩm (ProductID, Name) thuộc mô hình sản phẩm áo dài tay với tên bắt đầu với “Long-Sleeve Logo Jersey”, dùng phép IN và EXISTS	
---Dùng mệnh đề IN
select ProductID, Name
from Production.Product 
where ProductModelID in (select ProductModelID 
						 from Production.ProductModel
						 where Name like 'Long-Sleeve Logo Jersey%') 
						 --subquery trả về ProductModelID của áo dài tay 
---mệnh đề IN kiểm tra các product có productmodelID có nằm trongg các giá trị mà subquery trả về không

---Dùng mệnh đề EXISTS
select ProductID, Name
from Production.Product p
where exists (select ProductModelID 
						 from Production.ProductModel
						 where Name like 'Long-Sleeve Logo Jersey%' and ProductModelID=p.ProductModelID)
						--subquery trả về ProductModelID của áo dài tay 
---mệnh đề exists kiểm tra các product có productmodelID có tồn tại trong các giá trị mà subquery trả về không
----Khác với mệnh đề IN, ở mệnh đề EXISTS thì điều kiện cần kiểm tra ProductModelID phải được đưa vào subquery


------Câu 5:Tìm các mẫu sản phẩm (ProductModelID) mà giá niêm yết (list price) tối đa cao hơn giá trung bình của tất cả các mô hình.	
Select product.ProductModelID,model.Name,max(ListPrice)
from Production.ProductModel model join Production.Product product 
on model.ProductModelID=product.ProductModelID 
group by product.ProductModelID,model.Name
having max(product.ListPrice) >all(select avg(ListPrice) 
								from Production.ProductModel model join Production.Product product 
								on model.ProductModelID=product.ProductModelID)
							--Subquery trả về giá trị trung bình của tất cả model
---mệnh đề Having kiểm tra giá niêm yết tối đa của sản phẩm có lớn hơn giá trị trung bình không


-------Câu 6:Liệt kê các sản phẩm gồm các thông tin ProductID, Name, có tổng số lượng đặt hàng >5000 (dùng In, exists)
---Dùng IN
select ProductID, Name
from Production.Product 
where ProductID in (select ProductID 
					from Sales.SalesOrderDetail
					group by ProductID
					having SUM(OrderQty)>5000)
					--subquery trả về cái ID các sản phẩm có tổng lượng đặt >5000
---mệnh đề IN kiểm tra ProductID có nằm trong các giá trị subquery trả về không

---Dùng EXISTS
select ProductID, Name
from Production.Product p
where exists (select ProductID 
					from Sales.SalesOrderDetail
					where ProductID=p.ProductID
					group by ProductID
					having SUM(OrderQty)>5000)
					--subquery trả về ProductID có tổng lượng đặt  >5000 
---mệnh đề exists kiểm tra các product có productmodelID có tồn tại trong các giá trị mà subquery trả về không


------Câu 7:Liệt kê những sản phẩm (ProductID, UnitPrice) có đơn giá (UnitPrice) cao nhất trong bảng Sales.SalesOrderDetail
select distinct ProductID, UnitPrice
from Sales.SalesOrderDetail
where UnitPrice>=all (select distinct UnitPrice
					 from Sales.SalesOrderDetail)
					 --subquery trả về bảng các giá trị UnitPrice
--Mệnh đề where UnitPrice>=all(...) kiểm tra sản phẩm có unitprice lớn hơn hoặc bằng giá trị Unitprice cao nhất mà subquery trả về không



-------Câu 8:Liệt kê các sản phầm không có đơn đặt hàng nào thông tin gồm ProductID,Name, dùng 3 cách Not in, not exists và left join
--Dùng LEFT JOIN
select P.ProductID, Name
from Production.Product p left join Sales.SalesOrderDetail d on p.ProductID=d.ProductID --Kết trái 2 bảng Product và SalesOrderDetail
where d.ProductID is null -- kiểm tra ProductID null hay không

--Dùng NOT IN
select ProductID, Name
from Production.Product
where ProductID not in (select ProductID 
						from Sales.SalesOrderDetail)
						--Subquery trả về các product được đặt hàng
---mệnh đề NOT IN kiểm tra ID có nằm trong giá trị subquery trả về không, nếu không thì trả về true 

--Dùng NOT EXISTS							
select ProductID, Name
from Production.Product p
where not exists (select productID 
				  from Sales.SalesOrderDetail
				  where p.ProductID=ProductID)
				  --Subquery trả về các product được đặt hàng
---mệnh đề NOT EXISTS kiểm tra ID có  tồn trại giá trị như subquery trả về không, nếu không thì trả về true 


-----Câu 9:Liệt kê các nhân viên không lập hóa đơn từ sau ngày 1/5/2008, thông tin gồm EmployeeID, FirstName, LastName (dữ liệu từ 2 bảng HR.Employees vàSalesOrdersHeader)
select [BusinessEntityID] as EmployeeID, FirstName, LastName
from [Person].[Person]
where [BusinessEntityID]  not in (select SalesPersonID
								 from [Sales].[SalesOrderHeader]
								 where [OrderDate]>'2008-5-1' and SalesPersonID is not null
								 )
								--subquery trả về ID các nhân viên lập hóa đơn sau ngày 1/5/2008
---Mệnh đề NOT IN kiểm tra BusinessEntityID có nằm trong giá trị subquery trả về  không, nếu không thì trả về giá trị true 



-----Câu 10:Liệt kê danh sách các khách hàng (customerID, name) có hóa đơn dặt hàng trong
--năm 2007 nhưng có hóa đơn đặt hàng trong năm 2008.
select [CustomerID], FirstName+' '+LastName Name
from [Sales].[SalesOrderHeader], Person.Person
where [CustomerID] in (select [CustomerID]
					   from [Sales].[SalesOrderHeader]
					   where year([OrderDate])=2007 )  
					   --subquery đầu trả về các ID các khách hàng đặt vào 2007
	and [CustomerID] not in (select [CustomerID]
					   from [Sales].[SalesOrderHeader]
					   where year([OrderDate])=2008)
					   --subquery thứ 2 trả về các ID khách hàng đặt vào 2008
---Thực hiện kiểm tra CustomeID nằm trong 2007 và không nằm trong 2008




-----------------------------------------------------------------------------------------
------------------------------------   MODULE 3  ----------------------------------------

---Câu 1:Tạo view dbo.vw_Products hiển thị danh sách các sản phẩm từ bảng
--Production.Product và bảng Production.ProductCostHistory. Thông tin bao gồm
--ProductID, Name, Color, Size, Style, StandardCost, EndDate, StartDate
go
create view dbo.vw_Products
as
	select product.ProductID,Name,Color,Size,Style,product.StandardCost,EndDate,StartDate
	from Production.Product product join Production.ProductCostHistory CostHis
	on product.ProductID=CostHis.ProductID
	--Kết 2 bảng Product và ProductCostHistory bằng ProductID
go
select*from [dbo].[vw_Products]-- Hiển thị view vừa tạo

----Câu 2: Tạo view List_Product_view chứa danh sách các sản phẩm có trên 500 đơn đặthàng trong quí 1 năm 2008 và có tổng trị giá >10000, thông tin gồm ProductID,Product_name, countofOrderID và Subtotal.
go
create view List_Product_View
as
	select a.ProductID,a.Name Product_Name,CountOfOrderID=count(b.SalesOrderID),Subtotal=SUM(OrderQty * UnitPrice)
	from Production.Product a join Sales.SalesOrderDetail b on a.ProductID = b.ProductID
							  join sales.SalesOrderHeader c on c.SalesOrderID = b.SalesOrderID
							  --kết hợp các bảng với các ID tương ứng
	where Datepart(QUARTER, OrderDate) =1 and YEAR(OrderDate) = 2008 --điều kiện quý 1 và năm 2008
	group by a.ProductID, a.Name
	having sum(OrderQty * UnitPrice) > 10000 and COUNT(b.SalesOrderID) > 500 --tổng giá trị đơn >10000 và số lượng đơn lớn hơn 500

go
select* from List_Product_View -- Hiển thị view vừa tạo

------Câu 3: Tạo view dbo.vw_CustomerTotals hiển thị tổng tiền bán được (total sales) từ cột TotalDue của mỗi khách hàng (customer) theo tháng và theo năm. Thông tin gồm
--CustomerID, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, SUM(TotalDue).
go
create view vw_CustomerTotals
as
	select CustomerID, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, SumOfTotal=SUM(TotalDue)
	from [Sales].[SalesOrderHeader]
	group by CustomerID, YEAR(OrderDate), MONTH(OrderDate)
	--Lấy các cột tương ứng từ bảng SalesOrderHeader và nhóm theo Id khách hàng, năm order và tháng order

------Câu 4: Tạo view trả về TotalQuality bán được của mỗi nhân viên theo từng năm.
--THông tin gồm SalesPersonID,OrderYear,sumOfOrderQty
go 
create view TotalQuality_View
as
	select SalesPersonID, OrderYear=year([OrderDate]), sumOfOrderQty=sum([OrderQty])
	from [Sales].[SalesOrderHeader] OrdH join [Sales].[SalesOrderDetail] OrdD on OrdH.SalesOrderID=OrdD.SalesOrderID
	group by SalesPersonID, year([OrderDate])
	--Kết 2 bảng SalesOrderHeader và SalesOrderDetail theo SalesOrderID

------Câu 5:Tạo view ListCustomer_view chứa danh sách các khách hàng có trên 25 hóa đơn
--đặt hàng từ năm 2007 đến 2008, thông tin gồm mã khách (PersonID) , họ tên
--(FirstName +' '+ LastName as fullname), Số hóa đơn (CountOfOrders).
go
create view ListCustomer_view
as
	select  [CustomerID], FirstName +' '+ LastName as FullName, CounOfOrders=Count(*)
	from [Sales].[SalesOrderHeader] h join [Person].[Person] p on h.CustomerID=p.BusinessEntityID
	where year([OrderDate])>=2007 AND year([OrderDate])<=2008 --điều kiện từ năm 2007 đến 2008
	GROUP BY  [CustomerID], FirstName +' '+ LastName
	HAVING count(*)>25 --xét số hóa đơn hơn 25

------Câu 6:Tạo view ListProduct_view chứa danh sách những sản phẩm có tên bắt đầu với
--‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi năm trên 500 sản phẩm,
--thông tin gồm ProductID, Name, CountofOrderQty, year. (dữ liệu lấy từ các
--bảng Sales.SalesOrderHeader, Sales.SalesOrderDetail, and
--Production.Product)
go
create view ListProduct_view
as
	select product.ProductID,product.Name, CountOfOrderQty=Sum(OrderQty),Year=YEAR(OrderDate)
	from Production.Product product join Sales.SalesOrderDetail ordDetail on product.ProductID=ordDetail.ProductID
									join Sales.SalesOrderHeader ordDate on ordDetail.SalesOrderID=ordDate.SalesOrderID
								--kết hợp các bảng với ID tương ứng
	where product.Name like 'Bike%'  or product.Name like 'Sport%' --Kí tự bắt đầu là Bike hoặc Sport
	group by product.ProductID,product.Name,YEAR(OrderDate)
	having Sum(OrderQty)>500 --- xét tổng đơn hàng lớn hơn 500


------Câu 7:Tạo view List_department_View chứa danh sách các phòng ban có lương (Rate:lương theo giờ) trung bình >30, thông tin gồm Mã phòng ban (DepartmentID),tên phòng ban (name), Lương trung bình (name)

go
create view List_department_View
as
	select dep.DepartmentID, dep.Name, AvgofRate=avg([Rate])
	from [HumanResources].[Department] dep join [HumanResources].[EmployeeDepartmentHistory] h on dep.DepartmentID=h.DepartmentID
									   join [HumanResources].[EmployeePayHistory] emp on h.BusinessEntityID=emp.BusinessEntityID
									   --Kết hợp các bảng với các ID tương ứng
	group by dep.DepartmentID, dep.name
	having avg([Rate])>30--xét lương trung bình lớn hơn 30


-----Câu 8:Tạo view Sales.vw_OrderSummary với từ khóa WITH ENCRYPTION gồm
--orderYear (năm của ngày lập), OrderMonth (tháng của ngày lập), OrderTotal
--(tổng tiền). Sau đó xem thông tin và trợ giúp về mã lệnh của view này
go
create view Sales.vw_OrderSummary WITH ENCRYPTION -- with encryption sẽ làm cho view được tạo không thể xem và sửa 
as
	select year([OrderDate]) as OrderYear, month([OrderDate]) as OrderMonth, OrderTotal=sum([OrderQty]*[UnitPrice])
	from [Sales].[SalesOrderHeader] h join [Sales].[SalesOrderDetail] d on h.SalesOrderID=h.SalesOrderID
	group by year([OrderDate]), month([OrderDate])
go
sp_helptext [List_Department_view]
sp_helptext [Sales.vw_OrderSummary] -- không xem được vì view này đã được mã hóa 

------Câu 9:Tạo view Production.vwProducts với từ khóa WITH SCHEMABINDING gồm ProductID, Name, StartDate,EndDate,ListPrice của bảng Product và bảng
--ProductCostHistory. Xem thông tin của View. Xóa cột ListPrice của bảng Product. Có xóa được không? Vì sao? 
go
create view Production.vwProducts WITH SCHEMABINDING
as 
	select p.ProductID, Name, StartDate,EndDate,ListPrice 
	from  [Production].[Product] p join  [Production].[ProductCostHistory] h on p.ProductID=h.ProductID

go 
select*from Production.vwProducts

go
alter table Production.Product
drop column ListPrice ---không thể thực hiện xóa vì cột này đang được ràng buộc bởi vwProducts
---Muốn xóa cột thì phải sửa thuộc tính Schemabinding của view hoặc xóa view trước


------Câu 10:Tạo view view_Department với từ khóa WITH CHECK OPTION chỉ chứa các
--phòng thuộc nhóm có tên (GroupName) là “Manufacturing” và “Quality
--Assurance”, thông tin gồm: DepartmentID, Name, GroupName.
go
create view view_Department 
as
	select DepartmentID, Name, GroupName
	from [HumanResources].[Department]
	where GroupName='Manufacturing' or GroupName='Quality Assurance'
	WITH CHECK OPTION
--a. Chèn thêm một phòng ban mới thuộc nhóm không thuộc hai nhóm
--“Manufacturing” và “Quality Assurance” thông qua view vừa tạo. Có chèn được không? Giải thích
go
insert view_Department values( 'IT Resource', 'Development')
--không chèn được vì thuộc tính with check option sẽ áp dụng điều kiện khi tạo view cho các lệnh insert và update data sau này

--b. Chèn thêm một phòng mới thuộc nhóm “Manufacturing” và một phòng
--thuộc nhóm “Quality Assurance”.
insert view_Department values( 'IT Resource', 'Quality Assurance') 
---Insert thành công vì thỏa mãn điều kiện được định nghĩa trong view

--c. Dùng câu lệnh select xem kết quả trong bảng Department
select*from HumanResources.Department
--Có thể thấy dữ liệu ở câu b đã được thêm vào 




----------------------------------MODULE 4---------------------------------------
----I) Batch
----Câu 1:Viết một batch khai báo biến @tongsoHD chứa tổng số hóa đơn của sản phẩm
--có ProductID=’778’, nếu @tongsoHD>500 thì in ra chuỗi “San pham 778 có
--trên 500 đơn hàng”, ngược lại tin ra chuỗi “San pham 778 co it don dat hang”
use AdventureWorks2008R2
declare @tongsoHD int, @productId int --khai báo biến tongsoHD và productId 
set @productId=778 --gán giá trị cho biến 
set @tongsoHD=(select count(*)
			   from [Sales].[SalesOrderDetail]
			   where [ProductID]=@productId
			   )
			   --subquery trả về số đơn đặt hàng của sản phẩm có ProductID bằng giá trị của biến productId 
if @tongsoHD>500
	print N'Sản phẩm ' +cast(@productId as char(3))+ N' có trên 500 đơn hàng'
else 
	print N'Sản phẩm ' +cast(@productId as char(3))+ N' có ít đơn đặt hàng'
----In kết quả 



-----Câu 2:Viết một đoạn Batch với tham số @makh và @n chứa số hóa đơn của khách hàng @makh, tham số @nam chứa năm lập hóa đơn (ví dụ @nam=2008), 
--nếu @n>0 thì in ra chuỗi:”Khách hàng có @n hóa đơn trong năm 2008” 
--ngược lại nếu @n=0 thì in ra chuỗi “Khách hàng không có hóa đơn nào trong năm 2008”

declare @makh int, @n int, @nam int --khai báo các biến cần thiết
set @nam=2008 set @makh=1402 --gán giá trị cho biến
set @n=(select count(*)
		from [Sales].[SalesOrderHeader]
		where [CustomerID]=@makh and YEAR([OrderDate])=@nam
		)
		--subquery trả về số hóa đơn mà khách hàng có ID bằng giá trị biến makh và có năm đặt hàng bằng biến @nam 
	--gán giá trị biến @n cho giá trị mà subquery trả về
if @n>0 
	print N'Khách hàng ' + cast(@makh as char(5) )+N' có'+ cast(@n as char(4)) + N' hóa đơn trong năm'+ cast(@nam as char(4))
else 
	print N'Khách hàng ' + cast(@makh as char(5))+N' không có hóa đơn trong năm '+ cast(@nam as char(4))
--In kết quả



----Câu  3:Viết một batch tính số tiền giảm cho những hóa đơn (SalesOrderID) có tổng tiền>100000, thông tin gồm [SalesOrderID], Subtotal=sum([LineTotal]), Discount (tiền giảm), 
--với Discount được tính như sau:
--• Những hóa đơn có Subtotal<100000 thí không giảm,
--• Subtotal từ 100000 đến <120000 thì giảm 5% của Subtotal
--• Subtotal từ 120000 đến <150000 thì giảm 10% của Subtotal
--• Subtotal từ 150000 trở lên thì giảm 15% của Subtotal

 select h.SalesOrderID, Subtotal=sum([LineTotal]), Discount= (
			case
				when sum([LineTotal])<100000 then 0
				when sum([LineTotal]) between 100000 and 120000 then sum([LineTotal])*0.05
				when sum([LineTotal]) between 120000 and 150000 then sum([LineTotal])*0.1
				else sum([LineTotal])*0.15
			end )
			--Sử dụng cấu trúc case when then để gán giá trị cho Discount
			----Khi subtotal<100000 -> Discount =0
			----Khi 100000<=Subtotal<120000  -> Discount =Subtotal *0.05
			----Khi 120000<=Subtotal<150000  -> Discount =Subtotal *0.10
			----Khi Subtotal >=1500000  -> Discount =Subtotal *0.15

 from [Sales].[SalesOrderHeader] h join [Sales].[SalesOrderDetail] d 
 on h.SalesOrderID=d.SalesOrderID
 group by h.SalesOrderID
 having sum([LineTotal])>100000 -- xét các hóa đơn có tổng >100000


 --------Câu 4:Viết một  Batch với 3 tham số: @mancc, @masp, @soluongcc, chứa giá trị của các field ProductID, BusinessEntityID, OnOrderQty
 --với giá trị truyền cho các biến @mancc, @masp (VD:@mancc=1650,@masp=4)thì chương trình sẽ gán giá trị tương ứng của field OnOrderQty cho biến @soluongcc, nếu @soluongcc
 --trả về giá trị là null thì in ra chuỗi "Nhà cung cấp 1650 không cung cấp sản phẩn 4"
 --ngược lại thì in chuỗi với số lượng tương ứng
 
declare @mancc int, @masp int,@soluongcc int --khai báo các biến cần thiết
set @mancc=1650
set @masp=4
set @soluongcc=(select OnOrderQty
				from Purchasing.ProductVendor
				where ProductID=@masp and BusinessEntityID=@mancc)
		--gán giá trị @soluongcc tương ứng với giá trị ở cột OnOrderQty
if @soluongcc is null
	print N'Nhà cung cấp ' + cast(@mancc as char(5) )+N' không cung cấp sản phẩm '+ cast(@masp as char(4)) 
else 
	print N'Nhà cung cấp ' + cast(@mancc as char(5))+N' cung cấp sản phẩm  '+ cast(@masp as char(4))+N' với số lượng là '+cast(@soluongcc as char(5))
--In kết quả



--------Câu 5:Batch thực hiện tăng lượng giờ của nhân viên 
while(Select sum(rate) from[HumanResources].EmployeePayHistory) <6000
begin
	update [HumanResources].EmployeePayHistory
	set Rate=Rate*1.1 ---set lương tăng lên 10%
	if(select max(rate) from [HumanResources].EmployeePayHistory)>150
		break--kiểm tra điều kiện lương giờ cao nhất >150 thì thoát vòng lặp
	else 
		continue--tiếp tục vòng lặp
end
----thực hiện vòng lặp while với điều kiện tổng lương nhân viên <6000


-----II)Stored Procedure:
---Câu 1: Thủ tục tính tổng tiền thu của mỗi khách hàng trong một tháng của một năm bất kì
go
create procedure TotalDue_proc 
	@month int,
	@year int	 --tạo procedure với 2 tham số 
as
	select CustomerID,SumOfTotalDue=Sum(TotalDue)
	from Sales.SalesOrderHeader
	where Month(OrderDate)=@month and Year(OrderDate)=@year
	group by CustomerID
exec TotalDue_proc @month=6 , @year=2008



----Câu 2:Thủ tục xem doanh thu từ đầu năm cho đến hiện tại của 1 nhân viên
go
create procedure Sales_proc 
	@SalesPerson int
as
	declare @SalesYTD int --khai báo output
	set @SalesYTD=(select SalesYTD from Sales.SalesPerson
					where BusinessEntityID=@SalesPerson)
	select @SalesYTD--trả về output sau khi 

----Câu 3:Thủ tục trả về danh sách productID,ListPrice của các sản phẩm có giá bán không vượt quá một giá trị chỉ định (input:@maxprice)
go
create procedure ListProduct_proc
	@MaxPrice money
as
	select ProductID,ListPrice
	from Production.Product
	where ListPrice<=@MaxPrice --giá bán không vượt quá giá trị nhập vào
	group by ProductID,ListPrice

exec ListProduct_proc @MaxPrice=1000


-----Câu 4:viêt thủ tục NewBonus cập nhật lại tiền thưởng cho 1 nhân viên bán hàng, dựa trên tổng doanh thu của nhân viên đó
go
create procedure NewBonus
	@SalesPersonID int
as
	declare @newbonus money
	set @newbonus=(select sum(head.Subtotal)*0.01 from Sales.SalesPerson per join Sales.SalesOrderHeader head
	on per.BusinessEntityID=head.SalesPersonID)
	Update Sales.SalesPerson
	set Bonus=Bonus+@newbonus
	

	
------Câu 5:Thủ tục xem thông tin của ProductCategory có OrderQty cao nhất trong 1 năm tùy ý
go
create procedure MaxOrder_view
			@year int
as
	select cat.ProductCategoryID,cat.Name, SumOfQty=Sum(OrderQty)
	from Production.ProductCategory cat join Production.ProductSubcategory sub on cat.ProductCategoryID=sub.ProductCategoryID
										join Production.Product product on sub.ProductSubcategoryID=product.ProductSubcategoryID
										join Sales.SalesOrderDetail sales on product.ProductID=sales.ProductID
										join Sales.SalesOrderHeader header on sales.SalesOrderID=header.SalesOrderID
										---kết các bảng cần thiết lại với nhau
	where year(OrderDate)=@year and cat.ProductCategoryID in
				(select top(1)cat.ProductCategoryID
				from Production.ProductCategory cat 
										join Production.ProductSubcategory sub on cat.ProductCategoryID=sub.ProductCategoryID
										join Production.Product product on sub.ProductSubcategoryID=product.ProductSubcategoryID
										join Sales.SalesOrderDetail sales on product.ProductID=sales.ProductID
										join Sales.SalesOrderHeader header on sales.SalesOrderID=header.SalesOrderID
				where year(OrderDate)=@year
				group by cat.ProductCategoryID
				order by Sum(OrderQty) desc) --sort giảm dần để lấy giá trị top1 là giá trị cao nhất
				--subquery trả về 1 ID nhóm sản phẩm có số lượng đặt cao nhất của năm 
				----thực hiện kiểm tra productcategory nào có ID nằm trong giá trị subquery vừa trả thì thỏa mãn
	group by cat.ProductCategoryID,cat.Name

exec MaxOrder_view @year=2006



---------Câu 6: Tạo thủ tục đặt tên là TongThu có tham số vào  là mã nhân viên, tham số đầu ra là tổng giá trị các hóa đơn nhân viên đó bán được
----sử dụng lệnh returrn để trả về trạng thái thành công hay thất bại của thủ tục
go
create procedure TongThu
			@id int,
			@total money output --khai báo tham số output
as
	select @total=sum(TotalDue) from Sales.SalesOrderHeader sales
	where sales.SalesPersonID=@id
	if @total is null
		return 0 --- return 0 nếu không thực hiện thành công ( total = null)

---test procedure
declare @tong money;
exec dbo.TongThu @id=277, @total=@tong output
select @tong

			
-----Câu 7:Tạo thủ tục hiển thị tên, số tiền mua của cửa hàng mua nhiều hàng nhất theo năm đã cho


-----Câu 8:Sp_InsertProduct có tham số dạng innput để chèn một mẫu tin vào bảng Product
--Chỉ thêm vào các trường có giá trị not null và các field là khóa ngoại
go 
create procedure Sp_InsertProduct
	@id int ,
	@name nvarchar(50),
	@number nvarchar(25),
	@flag bit,
	@finishedflag bit,
	@stocklevel smallint,
	@reorderpoint smallint,
	@standardcost money,
	@listprice money,
	@sizeUnit nchar(3),
	@weightUnit decimal(8,2),
	@daystomanu int,
	@subcaID int,
	@modelID int,
	@sellstartDate datetime,
	@discontinuedDate datetime,
	@rowguid uniqueidentifier,
	@modifiedDate datetime 
as
	insert into Production.Product values(@id,@name,@number,@flag,@finishedflag,null,@stocklevel,@reorderpoint,@standardcost,@listprice,null,
								@sizeUnit,@weightUnit,null,@daystomanu,null,null,null,@subcaID,@modelID,@sellstartDate,null,null,@rowguid,@modifiedDate)


------Câu 9: Thủ tục XoaHD xóa 1 record trong SalesOrderHeader khi biết SalesOrderID
go
create procedure XoaHD
	@id int
as
	delete from Sales.SalesOrderDetail  where SalesOrderDetail.SalesOrderID=@id 
	delete from Sales.SalesOrderHeader  where SalesOrderHeader.SalesOrderID=@id 

exec XoaHD @id=43659


--------------Câu 10:Sp_Update_Product có tham số ProductId dùng để tăng listprice lên 10% nếu sản phẩm này tồn tại
--ngược lại hiện thông báo không có sản phẩm
go
create procedure Sp_Update_Product
	@ProductId int
as	
	if @ProductId in (select ProductID from Production.Product ) --Kiểm tra sản phẩm có tồn tai không
			update Production.Product --thực hiện update nếu  có
			set ListPrice=ListPrice+ListPrice*0.1
			where ProductID=@ProductId
	else	
		print('Sản phẩm không tồn tại')
	

exec Sp_Update_Product @ProductId=00





-------III)Function
--Scalar Function
-----Caau1 : viết hàm CountOfEmployees với tham số @mapb, giá trị truyền vào lấy từ field DepartmentID
--trả về số nhân viên trong phòng ban tương ứng. 
go
create function CountOfEmployees (@mapb int)
returns int 
as begin 
	return (select count(*) from HumanResources.EmployeeDepartmentHistory where DepartmentID=@mapb)
end


--Áp dụng hàm đã viết vào câu truy vấn liệt kê danh sách các phòng ban với số nhân viên của mỗi phòng ban
go
select DepartmentID, Name, countOfEmp=dbo.CountOfEmployees(DepartmentID) from HumanResources.Department


----Câu 2:Viết hàm tên InventoryProd với tham số vào là @ProductID và @LocationID trả về số lượng tồn kho của sản phẩm
--trong khu vực tương ứng với giá trị tham số
go 
create function InventoryProd (@ProductID int,@LocationID int)
returns int 
as begin
	return (select Quantity from Production.ProductInventory where ProductID=@ProductID and LocationID=@LocationID)
	--trả về số lượng tồn kho của sản phẩm có productID và locationID bằng giá trị tham số truyền vào 
end


-----Câu 3:Viết hàm SubTotalOfEmp trả về tổng doanh thu của một nhân viên trong một tháng tùy ý trong một năm tùy ý
--tham số input: @EmpID,@MonthOrder,@YearOrder
go
create function SubTotalOfEmp (@id int,@month int ,@year int  ) 
returns money
as begin
	return (select sum(SubTotal) from Sales.SalesOrderHeader where SalesPersonID=@id 
											and month(OrderDate)=@month
											and year(OrderDate)=@year) 
								--xét điều kiện id month and year
end											

-----Câu 4: Viết hàm SumOfOrder với 2 tham số @thang và @nam trả về danh sách các hóa đơn (SalesOrderID) lập trong tháng và năm input
--có tổng tiền >70000
go
create function SumOfOrder (@month int, @year int)
returns table
as 
	return (select a.SalesOrderID, OrderDate, SubTotal=sum(OrderQty * UnitPrice)-- chọn các cột SalesOrderID, OrderDate và Subtotal có giá trị bằng biểu thức như trên
	from Sales.SalesOrderDetail a join Sales.SalesOrderHeader b on a.SalesOrderID = b.SalesOrderID--kết hợp 2 bảng với điều kiện SalesOrderID bằng nhau
	where  MONTH(OrderDate) = @month and YEAR(OrderDate) = @year  --điều kiện tháng và năm 
	group by a.SalesOrderID, OrderDate -- nhóm các hóa đơn có ID, ngày order giống nhau lại
	having SUM(OrderQty * UnitPrice) > 70000)

select  * from dbo.SumOfOrder(6,2008)	


----Câu 5:viết hàm tên NewBonus tính lại tiền thưởng cho nhân viên bán hàng dựa trên tổng doanh thu của mỗi nhân viên, 
--mức thưởng mới bằng mức thưởng hiện tại tăng thêm 1% tổng doanh thu 

go 
create function NewBonus_fn()
returns table 
as
	return select head.SalesPersonID,SumOfSubTotal=sum(SubTotal),Bonus=Bonus+sum(Subtotal)*0.01
	from Sales.SalesOrderHeader head join Sales.SalesPerson per on head.SalesPersonID=per.BusinessEntityID
	group by head.SalesPersonID,Bonus


----Câu 6: Viết hàm tên SumOfProduct với tham số đầu vào là @mancc, dùng để tính tổng SumOfQty và tổng trị giá SumOfSubTotal
--của các sản phẩm do nhà cung cấp @mancc cung cấp, thông tin gồm ProductID, SumOfProduct SumOfSubTotal
use AdventureWorks2008R2
go
create function SumOfProduct (@id int )
returns table
as 
	return select ProductID,SumOfProduct=sum(OrderQty),SumOfSubTotal=sum(UnitPrice*OrderQty)
				from Purchasing.Vendor vendor join Purchasing.PurchaseOrderHeader head on vendor.BusinessEntityID=head.VendorID
											  join Purchasing.PurchaseOrderDetail detail on head.PurchaseOrderID=detail.PurchaseOrderID
				where vendor.BusinessEntityID=@id
				group by ProductID
				
----Câu 7:viết hàm tên Discount_Func tính số tiền giảm trên các hóa đơn (SalesOrderID) gồm SalesOrderID,SubTotal,Discount
go
create function Discount_Func()
returns table
as
	return select SalesOrderID, SubTotal,Discount=(select case
				when ([SubTotal])<1000 then 0
				when ([SubTotal]) >=1000 and SubTotal <5000 then ([SubTotal])*0.05
				when ([SubTotal]) >= 5000 and SubTotal<10000 then ([SubTotal])*0.1
				else ([SubTotal])*0.15
				end   ) from Sales.SalesOrderHeader 


-----Câu 8: TotalOfEmp với tham số @monthorder, @yearorder để tính tổng doanh thu của các nhân viên bán hàng (SalesPerson)
--thông tin gồm ID,Total 
go 
create function TotalOfEmp(@month int, @year int)
returns table
as
	return select SalesPersonID,Total=SUm(SubTotal) from Sales.SalesOrderHeader
			where month(OrderDate)=@month and year(OrderDate)=@year
			group by SalesPersonID

select * from dbo.TotalOfEmp(6,2008)



-------Câu 10: SalaryOfEmp trả về kết quả là bảng lương của nhân viên, với tham số vào là @manv
go
create function SalaryOfEmp(@id int )
returns @table table (Id int,FName nvarchar(50),LName nvarchar(50),Salary money)
as  begin
	if	@id is null
		insert into @table
		select per.BusinessEntityID ID,per.FirstName FName,per.LastName LName,Emp.Rate Salary
		from HumanResources.EmployeePayHistory Emp join Person.Person per on Emp.BusinessEntityID=per.BusinessEntityID
		order by per.BusinessEntityID
		--trường hợp tham số null 
	else
		insert into @table
		select per.BusinessEntityID ID,per.FirstName FName,per.LastName LName,Emp.Rate Salary
		from HumanResources.EmployeePayHistory Emp join Person.Person per on Emp.BusinessEntityID=per.BusinessEntityID
		where per.BusinessEntityID=@id

	return
end

select*from dbo.SalaryOfEmp(288)
select*from dbo.SalaryOfEmp(null)








--------------------------------------------------------------------------------------------------------
----------------------------------------------------MODULE5---------------------------------------------
--Câu 1: Tạo một Instead of trigger thực hiện trên view
go
create table M_Department
(
	DepartmentID int not null primary key,
	Name nvarchar(50),
	GroupName nvarchar(50)
)

go
create table M_Employees 
(
	EmployeeID int not null primary key,
	Firtname nvarchar(50),
	MiddleName nvarchar(50),
	LastName nvarchar(50),
	DepartmentID int foreign key references M_Department(DepartmentID)
)
---Tạo view
	go
	create view EmpDepart_View
	as
		select EmployeeID, Firtname, MiddleName, LastName, e.DepartmentID, Name, groupName
		from M_Employees e join M_Department d on e.DepartmentID=d.DepartmentID
	go
---tạo trigger
	create trigger InsteadOf_Trigger on EmpDepart_View
	instead of insert
	as	
		begin
			insert M_Department
			select DepartmentID, Name, groupName from inserted
			insert M_Employees
			select EmployeeID, Firtname, MiddleName, LastName, DepartmentID
			from inserted
		end

---Insert dữ liệu để test trigger
	insert EmpDepart_View values(1, 'Nguyen','Hoang','Huy', 11,'Marketing','Sales')
	select*from M_Department
	select*from M_Employees 


-----Câu 2: --Tạo một trigger thực hiện trên bảng MySalesOrders có chức năng thiết lập độ ưu tiên của khách hàng (custpriority) khi người dùng thực hiện các thao tác Insert, Update và Delete trên bảng MySalesOrders theo điều kiện như sau:
--Nếu tổng tiền Sum(SubTotal) của khách hàng dưới 10,000 $ thì độ ưu tiên của khách hàng (custpriority) là 3
-- Nếu tổng tiền Sum(SubTotal) của khách hàng từ 10,000 $ đến dưới 50000 thì độ ưu tiên của khách hàng (custpriority) là 2
-- Nếu tổng tiền Sum(SubTotal) của khách hàng từ 50000$ trở lên thì độ ưu tiên của khách hàng (custpriority) là 1
--Tạo 2 bảng dữ liệu, chèn dữ liệu lấy từ các bảng trong AdventureWorks
create table MCustomer
(
	CustomerID int not null primary key,
	CustPriority int
)

create table MsalesOrders
(
	SalesOrderID int not null primary key,
	OrderDate date,
	SubTotal money,
	CustomerID int foreign key references MCustomer(customerID)
)
---Chèn dữ liệu cho bảng MCustomers
insert Mcustomer ([CustomerID],custpriority)
select [CustomerID], null
from [Sales].[Customer]
where CustomerID>30100 and CustomerID<30118 


---Chèn dữ liệu cho bảng MSalesOrders
insert MsalesOrders
select [SalesOrderID],OrderDate, [SubTotal], [CustomerID]
from [Sales].[SalesOrderHeader]
where CustomerID in (select CustomerID from MCustomer)--chỉ lấy các hóa đơn của khách hàng có trong bảng MCustomer


--Tạo trigger
go
create trigger SetPriority on MsalesOrders
for insert, update, delete
as
	WITH CTE AS (
		select CustomerId from inserted
		union
		select CustomerId from deleted
	) --- định nghĩa kết quả mà subquery trả về và đặt tên cho kết quả đấy
	UPDATE MCustomer
	SET CustPriority =
						case
							when t.Total < 10000 then 3
							when t.Total between 10000 and 50000 then 2
							when t.Total > 50000 then 1
							when t.Total IS NULL then NULL
						end
	FROM MCustomer cus INNER JOIN CTE ON CTE.CustomerId = cus.CustomerId
					 LEFT JOIN (select MSalesOrders.CustomerID, SUM(SubTotal) Total
								from MSalesOrders inner join CTE 
								on CTE.CustomerId = MsalesOrders.CustomerId
								group by MsalesOrders.customerID) t ON t.CustomerId = cus.CustomerId

----test trigger
GO
insert MsalesOrders values(44054, '2012-01-01', 1000, 30102)
select*from Mcustomer
where CustomerId=30102
select sum(SubTotal)from MsalesOrders where CustomerID=30102



-------Câu 3:Viết một trigger thực hiện trên bảng Memployees sao cho khi người dùng thực hiện chèn thêm một nhân viên mới vào bảng Memployees thì chương trình cập nhật số
--nhân viên trong cột NumOfEmployee của bảng MDepartment. 
--Nếu tổng số nhân viên của phòng tương ứng <=200 thì cho phép chèn thêm, ngược lại thì hiển thị thông báo “Bộ phận đã đủ nhân viên” và hủy giao tác.
--tạo bảng
create table MDepartment
(
	DepartmentID int not null primary key,
	Name nvarchar(50),
	NumOfEmployee int
)

insert MDepartment
select [DepartmentID],[Name], null
from [HumanResources].[Department]

create table MEmployees
(
	EmployeeID int not null,
	Firtname nvarchar(50),
	MiddleName nvarchar(50),
	LastName nvarchar(50),
	DepartmentID int foreign key references MDepartment(DepartmentID)
	constraint pk_emp_depart primary key(EmployeeID, DepartmentID)
)
insert [MEmployees]
select p.[BusinessEntityID], [FirstName],[MiddleName],[LastName], [DepartmentID]
from  [Person].[Person] p join [HumanResources].[EmployeeDepartmentHistory] h on p.BusinessEntityID=h.BusinessEntityID


--tao trigger
go
create trigger Update_NumOfEmp on [dbo].[Memployees]
for insert 
as
	declare @numofEmp int, @DepartID int --khai báo 2 tham số chứa giá trị số lượng nhân viên và DepartmentID của record được insert
	select @DepartID=inserted.DepartmentID from inserted 
	set @numofEmp=(select COUNT(*) 
			       from [dbo].[Memployees] e
			       where e.DepartmentID=@DepartID
			      )
	if @numofEmp>200
	begin
			print 'Bộ phận đã đủ nhân viên'
			rollback ---hủy giao tác khi đã đủ nhân viên
		end
	else
		update MDepartment
		set NumOfEmployee =@numofEmp
		where DepartmentID= @DepartID
go
--test
insert [dbo].[Memployees] values(291, 'Bui',null,'Anh',1)
--kiem tra ket qua
select *from MDepartment


-------Câu 4: Bảng [Purchasing].[Vendor], chứa thông tin của nhà cung cấp, thuộc tính CreditRating hiển thị thông tin đánh giá mức tín dụng, có các giá trị:
--1 = Superior
--2 = Excellent
--3 = Above average
--4 = Average
--5 = Below average
--Viết một trigger nhằm đảm bảo khi chèn thêm một record mới vào bảng [Purchasing].[PurchaseOrderHeader], 
--nếu Vendor có CreditRating=5 thì hiển thị thông báo không cho phép chèn và đồng thời hủy giao tác
go
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

-------Câu 5: 
go
create trigger UpdateQuantity on Sales.SalesOrderDetail
after insert
as 
	begin
		declare @ordqty int, @quantity int, @masp int
		select @masp =i.ProductID from inserted i
		select @ordqty=i.OrderQty from inserted i
		set @quantity=(select Quantity from Production.ProductInventory 
						where productID=@masp)
		if @ordqty<@quantity
			update Production.ProductInventory
			set quantity=quantity-@ordqty
			where ProductID=@masp
		else			
				print 'Kho het hang'
				rollback transaction			
	end



-----Câu 6:
go
create table M_SalesPerson
(
	SalePSID int not null primary key,
	TerritoryID int,
	BonusPS money
)
create table M_SalesOrderHeader
(
	SalesOrdID int not null primary key,
	OrderDate date,
	SubTotalOrd money,
	SalePSID int foreign key references M_SalesPerson(SalePSID)
)
--insert dữ liệu

insert M_SalesPerson 
select BusinessEntityID,TerritoryID,Bonus  from Sales.SalesPerson

insert M_SalesOrderHeader
select SalesOrderID,OrderDate,SubTotal,SalesPersonID from Sales.SalesOrderHeader

--tạo trigger
go
CREATE trigger UpdateEmpBonus on M_SalesOrderHeader
for insert
as
	begin
		declare @total money, @spersonID int
		select @spersonID= i.SalePSID  from inserted i
		set @total=(select sum([SubTotalOrd]) 
				 from [dbo].[M_SalesOrderHeader] 
				 where SalePSID=@spersonID)
		if @total>10000000
		begin
			update [dbo].[M_SalesPerson] 
			set BonusPS=BonusPS*1.1
			where SalePSID=@spersonID
		end
	end




---------------------------------------------------------------------------------
-------------------------------------MODULE 6-------------------------------------
---Câu 1: 
USE [master]
GO
ALTER LOGIN [sa] WITH PASSWORD=N'sa'
GO
ALTER LOGIN [sa] ENABLE
GO

---Câu 2:
USE [master]
GO
CREATE LOGIN [User3] WITH PASSWORD=N'user3' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

USE [master]
GO
CREATE LOGIN [User2] WITH PASSWORD=N'user2' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO


----Cau 3:
USE [AdventureWorks2008R2]
GO
CREATE USER [User2] FOR LOGIN [User2]
GO

USE [AdventureWorks2008R2]
GO
CREATE USER [User3] FOR LOGIN [User3]
GO


----Câu 4: không thể thực hiện select trên user2
----Câu 5:
use AdventureWorks2008R2
--cấp quyền select cho User2
grant select on AdventureWorks2008R2.HumanResources.Employee to User2

--xóa quyền select
revoke select on AdventureWorks2008R2.HumanResources.Employee to User2


-----Câu 6:
USE [AdventureWorks2008R2]
GO
CREATE ROLE [Employee_Role]
GO

grant select, delete, update to Employee_Role

----Câu 7
--Add User2 và User3 vào Employee_Role
USE [AdventureWorks2008R2]
GO
ALTER ROLE [Employee_Role] ADD MEMBER [User2]
GO
USE [AdventureWorks2008R2]
GO
ALTER ROLE [Employee_Role] ADD MEMBER [User3]
GO
---Select xem thông tin bảng Employee với User2
select*from HumanResources.Employee

---Update với User3
Update HumanResources.Employee set JobTitle='Sale Manager' where BusinessEntityID=1

---Xem lại kết quả bằng User2 thì đã thấy dữ liệu được cập nhật
----Quá trình xóa Employee_Role
USE [AdventureWorks2008R2]
GO

DECLARE @RoleName sysname
set @RoleName = N'Employee_Role'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
/****** Object:  DatabaseRole [Employee_Role]    Script Date: 2/21/2023 11:52:42 AM ******/
DROP ROLE [Employee_Role]
GO




-----------------------------------------------------------------------
----------------------------------MODULE 7----------------------------
-----Câu 1
----1a: chèn dữ liệu vào Department bằng Begin tran và rollback
begin tran;
set identity_insert HumanResources.Department on
insert into HumanResources.Department(DepartmentID,Name,GroupName) values(18,'Machine Learning','Security')
select*from HumanResources.Department
rollback;
--Rollback sẽ hoàn tác các transaction vừa chạy và trả về dữ liệu như ban đầu

select*from HumanResources.Department

-----1b:
begin tran
insert into HumanResources.Department(DepartmentID,Name,GroupName) values(18,'Machine Learning','Security')
select*from HumanResources.Department
rollback;
select*from HumanResources.Department
commit
--dữ liệu đã được lưu vào database khi dùng cômmit

------Câu 2:
SET IMPLICIT_TRANSACTIONS OFF;
begin tran
insert into HumanResources.Department(DepartmentID,Name,GroupName) values(19,'Deep Learning','AI')
CREATE TABLE Test (id INT NOT NULL PRIMARY KEY, s VARCHAR(30), si SMALLINT);
INSERT INTO Test (id, s) VALUES (1, 'first');
rollback
select*from HumanResources.Department
select*from Test


-----câu 3:
SET XACT_ABORT ON;  
--SET IMPLICIT_TRANSACTIONS ON;
SELECT 1/0 AS Dummy;  -- division by zero
update HumanResources.Department set Name='@@' where DepartmentID=999
delete HumanResources.Department where DepartmentID=66
insert into HumanResources.Department(DepartmentID,Name,GroupName) values(25,'Foreign Investment','Invest')
COMMIT;

--báo lỗi không thể thực hiện phép chia cho 0

----Câu 4:
GO
SET XACT_ABORT OFF
SELECT 1/0 AS Dummy;  -- division by zero
update HumanResources.Department set Name='@@' where DepartmentID=999
delete HumanResources.Department where DepartmentID=66
insert into HumanResources.Department(DepartmentID,Name,GroupName) values(25,'Foreign Investment','Invest')
COMMIT
SELECT * FROM HumanResources.Department;
---măc dù không tồn tại ID nhưng transaction vẫn thực hiện tiếp tục các câu lệnh sau đó 
---vì thế mà dữ liệu mới đã được thêm vào bảng Department


----------CONCURRENT TRANSACTIONS
----Câu 1: tạo bảng account
CREATE TABLE Accounts (
AccountID  int NOT NULL PRIMARY KEY,
balance int NOT NULL 
        CONSTRAINT unloanable_account CHECK (balance >= 0)
);

INSERT INTO Accounts (AccountID,balance) VALUES (101,1000);
INSERT INTO Accounts (AccountID,balance) VALUES (202,2000);

----Câu 2:Set transaction isolation level

----Cau 3: 
----CLient A:
set transaction isolation level read committed
begin tran
select*from Accounts where AccountID=101
update Accounts set balance=1000-200 where AccountID=101
select*from Accounts where AccountID=101
commit;


-----Client B:
set transaction isolation level read committed
begin tran
select*from Accounts where AccountID=101
update Accounts set balance=1000-500 where AccountID=101
select*from Accounts where AccountID=101
commit;

---kết quả hiện thị 2 bảng với 2 giá trị balance là 800 và 500 do 2 transaction chạy độc lập với nhau
---kết quả cuối mà balance của Account 101 sẽ nhận là 500



------Câu 5:
Use AdventureWorks2008R2
----ClientA
set transaction isolation level read committed
begin tran
Update Accounts set balance=balance-100 where AccountID=101
UPDATE Accounts SET balance = balance + 100 WHERE AccountID = 202;
commit

use AdventureWorks2008R2
---ClientB:
set transaction isolation level read committed
begin tran
UPDATE Accounts SET balance = balance - 200 WHERE AccountID = 202;
UPDATE Accounts SET balance = balance + 200 WHERE AccountID = 101;

commit


-------Câu 6:
DELETE FROM Accounts;
INSERT INTO Accounts (AccountID,balance) VALUES (101,1000);
INSERT INTO Accounts (AccountID,balance) VALUES (202,2000);

---ClientA:
begin tran 
Update Accounts set balance =balance-100 where AccountID=101
UPDATE Accounts SET balance = balance + 100 WHERE AccountID = 202;
rollback;
select*from Accounts;
commit;

---Client B:
begin tran
set tran Isolation level read uncommitted 
select*from Accounts
commit;

---sau khi sử dụng lệnh rollback ở transaction client A thì các tasks chưa commit ở client A đã được hoàn tác và trả về giá trị balance band dầu của các account



----Câu 7:
SET IMPLICIT_TRANSACTIONS ON; 
DELETE FROM Accounts;
INSERT INTO Accounts (AccountID,balance) VALUES (101,1000);
INSERT INTO Accounts (AccountID,balance) VALUES (202,2000);
COMMIT;


---ClientA: 
set tran isolation level repeatable read
SELECT * FROM Accounts WHERE balance > 1000;


---ClientB:
SET IMPLICIT_TRANSACTIONS ON; 
INSERT INTO Accounts (AccountID,balance) VALUES (303,3000);
COMMIT;

---Client A:
SELECT * FROM Accounts WHERE balance > 1000;

COMMIT;

---kết quả có 2 ID 202 và 303 vì 2 account này có balance >1000



------------------------------------------------------------------------------------------
--------------------------------------------MODULE 8-----------------------------------------

---Câu 1:
BACKUP DATABASE [AdventureWorks2008R2] TO  DISK = N'D:\backup\adv2008back' WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks2008R2-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

---Câu 2: 
USE [master] ;  
ALTER DATABASE AdventureWorks2008R2 SET RECOVERY FULL ;  
BACKUP DATABASE [AdventureWorks2008R2] TO  DISK = N'D:\backup\adv2008back' WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks2008R2-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

----Câu 3:
use AdventureWorks2008R2
begin tran
declare @sumBike money, @sumAll money
set @sumBike=(select sum(ListPrice) from Production.Product product join Production.ProductSubCategory sub on product.ProductSubcategoryID=sub.ProductSubcategoryID
																 join Production.ProductCategory cate on sub.ProductCategoryID=cate.ProductCategoryID
																 where cate.Name='Bikes')
set @sumAll=(select sum(ListPrice) from Production.Product product join Production.ProductSubCategory sub on product.ProductSubcategoryID=sub.ProductSubcategoryID
																 join Production.ProductCategory cate on sub.ProductCategoryID=cate.ProductCategoryID)

if @sumBike >=@sumAll*0.6
	update Production.Product set ListPrice=15 where ProductSubcategoryID=1										 
commit;


----Câu 4:
---4a differential backup
BACKUP DATABASE [AdventureWorks2008R2] TO  DISK = N'D:\backup\adv2008back' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'AdventureWorks2008R2-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


----4b transaction log backup
BACKUP LOG [AdventureWorks2008R2] TO  DISK = N'D:\backup\adv2008back' WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks2008R2-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO












-----------------------------------------------------------------------------HOMEWORK1--------------------------------------------------
--Tạo cơ sở dữ liệu với theo đường dẫn T:\BUILEHAITRIEU\Sales với các thông số như sau 
create database Sales
on primary
(
	name= 'Sales',
	filename= 'T:\BUILEHAITRIEU\Sales.mdf',
	size=10MB,
	filegrowth=20%,
	maxsize=50MB
)
log on
(
	name= 'Sales_log',
	filename= 'T:\BUILEHAITRIEU\Sales_log.ldf',
	size=8MB, 
	filegrowth=10%,
	maxsize=20MB
)

--câu 1: tạo các kiểu dữ liệu người dùng
USE [SALES]
GO
CREATE TYPE [dbo].[Mota] FROM [nvarchar](40) NULL -- kiểu dữ liệu Mota theo thuộc kiểu nvarchar có Length là 40 cho phép null

GO
CREATE TYPE [dbo].[IDKH] FROM [char](10) NOT NULL --kiểu dữ liệu IDKH thuộc kiểu char có Length là 10 và không cho phép null
GO

CREATE TYPE [dbo].[DT] FROM [char](12) NULL -- kiểu dữ liệu DT thuộc kiểu char có Length là 10 cho phép null
GO


--Câu 2: tạo bảng
create table SanPham --tạo bảng SanPham 
(
	Masp char(6) not null,
	TenSp varchar(20) not null,
	NgayNhap Date,
	DVT char(10),
	SoLuongTon int,
	DonGiaNhhap money,
)

go
create table HoaDon -- tạo bảng HoaDon
(
	MaHD char(10) not null,
	NgayLap Date,
	NgayGiao Date,
	Makh IDKH not null,
	DienGiai Mota,
)

go
create table KhachHang -- tạo bảng KhachHang
(
	MaKH IDKH not null,
	TenKH nvarchar(30) not null,
	Diachi nvarchar(40),
	Dienthoai DT,
)

go
create table ChiTietHD -- tạo bảng ChiTietHD 
(
	MaHD char(10) not null,
	Masp char(6) not null,
	Soluong int,
)


--Câu 3: trongg table HoaDon, sửa cột DienGiai thành nvarchar(100)
alter table HoaDon 
alter column DienGiai nvarchar(100)--Câu lệnh này sẽ truy cập vào bảng HoaDon rồi tìm đến và chỉnh sửa cột DienGiai sang kiểu dữ liệu nvarchar(100)

--Câu 4: Thêm vào bảng SanPham cột TyLeHoaHong float
go
alter table SanPham add TyLeHoaHong float--Câu lệnh này sẽ truy cập vào bảng SanPham rồi thêm cột TyLeHoaHong với kiểu dữ liệu nvarchar(100)

--Câu 5: Xóa cột NgayNhap trong bảng SanPham
go 
alter table SanPham drop column NgayNhap

--Câu 6: Tạo bảng các ràng buộc khóa chính và khóa ngoại cho các bảng trên
go
alter table SanPham add primary key (Masp) -- tạo khóa chính là Masp

go
alter table KhachHang add primary key(MaKH) -- tạo khóa chính là MaKH

go
alter table HoaDon add primary key (MaHD) --tạo khóa chính là MaHD
alter table HoaDon add foreign key (Makh) references KhachHang(MaKH) --tạo khóa ngoại là Makh tham chiếu đến MaKH ở bảng KhachHang

go
alter table ChiTietHD add foreign key (MaHD) references HoaDon (MaHD) --tạo khóa ngoại là MaHD tham chiếu đến MaHD ở bảng HoaDon
alter table ChiTietHD add foreign key (Masp) references SanPham (Masp)-- tạo khóa ngoại là Masp tham chiếu đến Masp ở bảng SanPham


-----Câu 7: thêm các ràng buộc vào bảng HoaDon-----
go
alter table HoaDon
add constraint CHK_Ngay check (NgayGiao>=NgayLap) 
--tạo constraint check CHK_Ngay để kiểm tra điều kiện NgayGiao>=NgayLap ở bảng HoaDon

go
alter table HoaDon
add constraint CHK_MaHD check( (len([MaHD])=6) and ((left(MaHD,2) like '%[^a-zA]%' and (right(MaHD,4) like  '%[Z0-9]%'))))
--tạo constraint CHK_MaHD để kiểm tra điều kiện: dữ liệu nhập vào chỉ chứa 6 kí tự, trong đó 2 kí tự đầu tính từ trái qua là chữ và 4 kí tự từ phải qua là số
go
alter table HoaDon 
add constraint df_NgayLap default GETDATE() for NgayLap
--tạo giá trị mặc định cho cột NgayLap bằng giá trị của hàm GETDATE(), hàm này sẽ trả về giá trị ngày giờ theo thời gian thực nhập vào


----Câu 8: thêm ràng buộc cho bảng SanPham
go
alter table SanPham 
add constraint CHK_SoLuongTon check (SoLuongTon>=0 and SoLuongTon<=500)
--tạo ràng buộc CHK_SoLuongTon ở bảng SanPham để kiểm tra SoLuongTon lớn hơn hoặc bằng 0 và bé hơn hoặc bằng 500

alter table SanPham
add constraint CHK_DonGiaNhap check(DonGiaNhap>0)
--tạo ràng buộc CHK_DonGiaNhap kiểm tra DonGiaNhap có lớn hơn 0 không

alter table SanPham
add constraint df_NgayNhap default GETDATE() for NgayNhap
--tạo constraint giá trị mặc định NgayNhap là giá trị của hàm GETDATE trả về giá trị thời gian thực lúc nhập

alter table SanPham
add constraint CHK_DVT check (DVT in ('KG','Thùng', 'Hộp', 'Cái'))
--tạo constraint kiểm tra giá trị DVT nhập vào có nằm trong các giá trị trên không

---Câu 9: Nhập dữ liệu vào 4 table
insert into KhachHang values ('KH0001','Bùi Lê Hải Triều','Quy Nhơn','0828042319')
insert into SanPham values('SP0001','Iphone 13 Pro Max','Cái',100,27000000,0.05)
insert into HoaDon values('HD0001',default,'2023-02-14 13:00:00','KH0001','Fragile')
insert into ChiTietHD values('HD0001','SP0001',1)


----Câu 10:Xóa 1 hóa đơn bất kì trong bảng HoaDon. Có xóa được không? Tại sao? Nếu vẫn muốn xóa thì dung cách nào ?
--Ans: Không xóa được bởi vì khóa ngoại MaHD ở bảng CHiTietHD tham chiếu đến khóa chính MaHD ở bảng HoaDon nên nếu xóa thì sẽ gây xung đột ràng buộc giữa các khóa.
--Để có thể xóa được hóa đơn thì trước hết cần xóa bản ghi ở bảng ChiTietHD mà có khóa ngoại MaHD tham chiếu đến MaHD của bản ghi cần xóa ở bảng HoaDon 


---Câu 11:Nhập 2 bản ghi mới vào bảng ChiTietHD:
--11.1:Với MaHD= “HD999999999” 
--Không nhập được vì chưa tồn tại MaHD=“HD999999999” ở bảng HoaDon để tham chiếu đến, trước hết cần thực hiện nhập bản ghi mới với MaHD=“HD999999999” vào bảng HoaDon 
--nhưng cũng sẽ không nhập được vì độ dài tối đa cho MaHD là 10 trong khi độ dài MaHD nhập vào là 11 =>>>>> Trường hợp này không thể nhập được 


--11.2:Với MaHD=’1234567890’
--Đầu tiên sẽ không nhập được vì chưa tồn tại MaHD=“1234567980” ở bảng HoaDon để tham chiếu đến, trước hết cần thực hiện nhập bản ghi mới với MaHD=“1234567890” vào bảng HoaDon,
--bản ghi mới sẽ được nhập vào vì độ dài tối đa cho MaHD là 10 trong khi độ dài MaHD nhập vào cũng bằng 10 =>>>>> Trường hợp này có thể nhập được nếu tồn tại trước một bản ghi có MaHD=’1234567890’ ở bảng HoaDon




------------------------------------------------------------------HOMEWORK 2-------------------------------------------------
--Câu 1: tạo 2 bảng mới trong cơ sở dữ liệu AdventureWorks2008R2 

use AdventureWorks2008R2
create table
MyDepartment(
	DepID smallint not null primary key,
	DepName nvarchar(50),
	GrpName nvarchar(50)
)

create table MyEmployee(
	EmpID int not null primary key,
	FrstName nvarchar(50),
	MidName nvarchar(50),
	LstName nvarchar(50),
	DepID smallint not null foreign key references MyDepartment(DepID)
	)

----Câu 2: Dùng lệnh insert <table> select <fieldlist> from <table2> để chèn dữ liệu cho bảng MyDepartment
insert into MyDepartment(DepID,DepName,GrpName) 
select DepartmentID, Name, GroupName
from [HumanResources].[Department]
--Chèn dữ liệu cho bảng MyDepartment các dữ liệu từ cột DepartmentID, Name, Groupname từ bảng [HumanResources].Department] vào các cột của bảng MyDepartment vừa tạo

----Câu 3: chèn dữ liệu cho bảng MyEmployee từ 2 bảng [Person].[Person] và [HumanResources].[EmloyeeDepartmentHistory]
insert into MyEmployee(EmpID,FrstName,MidName,LstName,DepID)
select top(20) a.BusinessEntityID,FirstName,MiddleName,LastName,DepartmentID
from [Person].[Person] a,[HumanResources].[EmployeeDepartmentHistory] b
where a.BusinessEntityID=b.BusinessEntityID
-- insert 20 dòng đầu của bảng [Person].[Person], [HumanResources].[EmloyeeDepartmentHistory] với các column tương ứng với bảng MyEmployee, tuy nhiên ở BusinessEntityID đồng thời tồn tại ở 2 bảng nên thực hiện lấy từ bảng Person vì là khóa chính 
--kết hợp thêm điều kiện DepID ở bảng Person phải bằng DepID ở bảng EmloyeeDepartmentHistory


----Câu 4: dùng lệnh delete xóa một record trong bảng MyDepartment với DepID=1 được không ? vì sao?----------
--Ans: Không xóa được vì DepID ở bảng MyDepartment được tham chiếu bởi khóa ngoại DepID ở bảng MyEmployee. 
--Để có thể xóa được cần thực hiện xóa record có DepID=1 ở bảng MyEmployeee trước rồi mới có thể xóa trên bảng MyDepartment



----Câu 5: thêm default constraint vào field DepID trong bảng MyEmloyeee với giá trị mặc định là 1
alter table MyEmployee 
add constraint df_DepID default 1 for DepID


---Câu 6: thêm một record mới trong bảng MyEmployee theo cú pháp và quan sát giá trị trong field depID của record mới thêm
insert into MyEmployee(EmpID,FrstName,MidName,LstName) values (1,'Nguyen','Nhat','Nam')
--record mới thêm đã được tự đồng set giá trị depID=1 nhờ default constraint tạo ở câu 5


---Câu 7: Xóa foreign key trong bảng MyEmployee, thiết lập lại khóa ngoại DepID tham chiếu đến DepID của bảng MyDepartment với thuộc tính on delete set default
alter table MyEmployee
drop constraint FK__MyEmploye__DepID__5C02A283  --đây là tên constraint khóa ngoại trên sql server của em



alter table MyEmployee
add constraint FK_MyEmployee_DepID foreign key (DepID) references MyDepartment(DepID) on delete set default
--thêm constraint foreign key FK_MyEmployee_DepID với khóa ngoại DepID tham chiếu đến cột DepID ở bảng MyDepartment với thuộc tính on delete set default 
--on delete set default sẽ set DepID ở bảng MyEmployee thành giá trị default nếu DepID ở bảng MyDepartment bị xóa


----Câu 8: Xóa một record trong bảng MyDepartment có DepID=7, quan sát kết quả trong 2 bảng MyEmployee and MyDepartment
delete from MyDepartment where DepID=7 
--Bảng MyDepartment bị xóa đi một record DepID=7 nên chỉ còn 15 record
--Ở bảng MyEmployee, số lượng các row vẫn giữ nguyên, tuy nhiên tại các record có DepID=7 lúc trước thì đã thay đối DepID=1 nhờ ràng buộc khóa ngoại on delete set default


----Câu 9: Xóa foreign key trong bang MyEmployee. Hiệu chỉnh ràng buộc khóa ngoại DepID trong bảng MyEmployee, thiết lập thuộc tính on delete cascade và on update cascade
alter table MyEmployee
drop constraint FK_MyEmployee_DepID --xóa foreign key trong bảng MyEmployee

alter table MyEmployee
add constraint FK_MyEmployee_DepID foreign key (DepID) references MyDepartment(DepID) on delete cascade on update cascade
--thêm constraint khóa ngoại cùng thuộc tính on delete cascade và on update cascade
--2 thuộc tính này sẽ thực hiện xóa và update các record liên quan(record được tham chiếu ở parent table hoặc tham chiếu từ child table) đến record vừa được update hoặc xóa


----Câu 10:  Xóa một record trong bảng MyDepartment với DepID=3
delete from MyDepartment where DepID=3
--Xóa được. Quan sát ở bảng MyDepartment cho thấy record có DepID=3 đã bị xóa
--Ở bảng MyEmployee, các record có DepID=3 cũng đồng thời bị xóa do thuộc tính delete cascade được set 


----Câu 11:Thêm ràng buộc check vào bảng MyDepartment tại field GrpName, chỉ cho phép nhận thêm những Department thuộc group Manufacturing
alter table MyDepartment with nocheck
add constraint CHK_GrpName check (GrpName='Manufacturing')
--sử dụng nocheck cho constraint sẽ khiến constraint không kiểm tra qua các dữ liệu đang tồn tại trên bảng, do đó không gây ra lỗi conflict như khi không dùng nocheck


----Câu 12:Thêm ràng buộc check vào bảng [HumanResources].[Employee], tại cột BirthDate, chỉ cho phép nhập thêm nhân viên mới có tuổi 18->60

go
alter table [HumanResources].[Employee] with nocheck
add constraint CHK_Age check ((datediff(MONTH,BirthDate, getdate())/12 - 
											case when month(BirthDate)=month(getdate()) and day(BirthDate) > day(getdate()) then 1 else 0 end)>=18 and 
(datediff(MONTH,BirthDate, getdate())/12 - 
											case when month(BirthDate)=month(getdate()) and day(BirthDate) > day(getdate()) then 1 else 0 end)<=60)

--Giải thích biểu thức kiểm tra: Đầu tiên sẽ dùng datediff để tính khoảng cách về tháng giữa  ngày sinh và ngày hiện tại. 
---thực hiện tính tuổi bằng cách chia con số vừa tính cho 12
---"case when month(birthDate)=month(getdate()) and day(birthdate) > day(getdate()) then 1 else 0” 
----> code này sẽ kiểm tra xem tháng của ngày hiện tại và tháng của ngày sinh có giống nhau không, và ngày của tháng sinh có  lớn hơn ngày của ngày hiện tại không
