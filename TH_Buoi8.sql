-- Câu 1 Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.
create proc spTangLuong
as
update NHANVIEN set LUONG = LUONG*0.1
go
exec spTangLuong

-- Câu 2 Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP
-- spNghiHuu dùng để cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những
-- nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.
Alter table NHANVIEN
ADD NgayNghiHuu date 
CREATE PROC spNghiHuu
as
UPDATE NHANVIEN set NgayNghiHuu = (select GETDATE()+100)
go
EXEC spNghiHuu

-- Câu 3 Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi gọi thủ tục.
Create proc spXemDeAn @diadiem nvarchar(20)
as
select * from DEAN where DDIEM_DA = @diadiem
go
exec spXemDeAn N'TP HCM'

-- Câu 4 Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền vào là diadiem_cu, diadiem_moi. 
-- Câu 5 Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các trường của bảng DEAN.
