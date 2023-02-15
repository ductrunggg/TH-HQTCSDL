SE master

CREATE DATABASE Sales
  ON
  PRIMARY
  (
  NAME = tuan1_data,
  FILENAME ='T:\ThucHanhSQL\tuan1_data.mdf',
  SIZE = 10MB,
  MAXSIZE = 20MB,
  FILEGROWTH = 20%
  )
  LOG ON
  (
  NAME = tuan1_log,
  FILENAME = 'T:\ThucHanhSQL\tuan1_log.ldf',
  SIZE = 10MB,
  MAXSIZE = 20MB,
  FILEGROWTH = 20%
  )
  USE Sales
-- 1. Kiểu dữ liệu tự định nghĩa
EXEC sp_addtype 'Mota', 'NVARCHAR(40)'
EXEC sp_addtype 'IDKH', 'CHAR(10)', 'NOT NULL'
EXEC sp_addtype 'DT', 'CHAR(12)'
-- 2. Tạo table
GO
CREATE TABLE SanPham (
MaSP CHAR(6) NOT NULL,
TenSP VARCHAR(20),
NgayNhap Date,
DVT CHAR(10),
SoLuongTon INT,
DonGiaNhap money,
)
CREATE TABLE HoaDon (
MaHD CHAR(10) NOT NULL,
NgayLap Date,
NgayGiao Date,
MaKH IDKH,
DienGiai Mota,
)
CREATE TABLE KhachHang (
MaKH IDKH,
TenKH NVARCHAR(30),
DiaChi NVARCHAR(40),
DienThoai DT,
)
CREATE TABLE ChiTietHD (
MaHD CHAR(10) NOT NULL,
MaSP CHAR(6) NOT NULL,
SoLuong INT
)

-- 3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100).
ALTER TABLE HoaDon
ALTER COLUMN DienGiai NVARCHAR(100)
-- 4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SanPham
ADD TyLeHoaHong float
-- 5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SanPham
DROP COLUMN NgayNhap
-- 6. Tạo các ràng buộc khóa chính và khóa ngoại
ALTER TABLE SanPham
ADD
CONSTRAINT pk_sp primary key(MASP)

ALTER TABLE HoaDon
ADD
CONSTRAINT pk_hd primary key(MaHD)

ALTER TABLE KhachHang
ADD
CONSTRAINT pk_khanghang primary key(MaKH)

ALTER TABLE HoaDon
ADD
CONSTRAINT fk_khachhang_hoadon FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_hoadon_chitiethd FOREIGN KEY(MaHD) REFERENCES HoaDon(MaHD)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_sanpham_chitiethd FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
-- 7. Thêm các ràng buộc vào table Hóa Đơn 
ALTER TABLE HoaDon
ADD CHECK (NgayGiao >= NgayLap)

ALTER TABLE HoaDon
ADD CHECK (MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]')

ALTER TABLE HoaDon
ADD CONSTRAINT df_ngaylap DEFAULT GETDATE() FOR NgayLap
-- 8. Thêm các ràng buộc vào table Sản Phẩm
ALTER TABLE SanPham
ADD CHECK (SoLuongTon like '[0-500]')

ALTER TABLE SanPham
ADD CHECK (DonGiaNhap > 0)

ALTER TABLE SanPham
ADD CONSTRAINT df_ngaynhap DEFAULT GETDATE() FOR NgayNhap

ALTER TABLE SanPham
ADD CHECK (DVT like 'KG''Thùng''Hộp''Cái')
-- 9. Dùng lệnh T-SQL nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi table
INSERT INTO SanPham VALUES ('001',N'TAi nghe bluetooth','2022-12-2',N'Cái', 100, 200000)
INSERT INTO SanPham VALUES ('002',N'Sữa Milo','2022-12-15',N'Thùng', 100, 400000)
INSERT INTO KhachHang VALUES ('111', N'Nguyễn Minh Huy', N'118 Nguyễn Văn Lạc', '0909555789') 
INSERT INTO KhachHang VALUES ('222', N'Phan Công Thành', N'98 Nơ Trang Long ', '0903225449') 
INSERT INTO HoaDon VALUES ('HD01', '2022-12-20', '2022-12-21', '111',N'Đổi trả nếu sản phẩm lỗi trong vòng 7 ngày') 
INSERT INTO HoaDon VALUES ('HD02', '2022-12-25', '2022-12-26', '222',N'Đổi trả nếu sản phẩm lỗi trong vòng 7 ngày') 
INSERT INTO ChiTietHD VALUES ('HD01', '001', 5) 
INSERT INTO ChiTietHD VALUES ('HD02', '002', 10)
-- 10.Xóa 1 hóa đơn bất kỳ trong bảng HoaDon. Có xóa được không? Tại sao? Nếu vẫn muốn xóa thì phải dùng cách nào ?
DELETE from HoaDon
where MaHD = 'HD02'