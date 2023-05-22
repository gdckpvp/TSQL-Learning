-- BTVN MODULE 1 --
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

