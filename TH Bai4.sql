create database QLKho
go 
use QLKHO
go
create table Nhap
(
SoHDN nvarchar(20) primary key,
MaVT nvarchar(50) not null,
SoLuongN int,
DonGiaN money,
NgayN smalldatetime
)
create table Xuat
(
SoHDX nvarchar(20) primary key,
MaVT nvarchar(50) not null,
SoLuongX int,
DonGiaX money ,
NgayX smalldatetime
)
create table Ton
(
MaVT nvarchar(50) primary key,
TenVT nvarchar(50) not null,
SoLuongT int
)
alter table Nhap
add constraint fk_ton_nhap foreign key (MaVT) references Ton(MaVT)

alter table Xuat
add constraint fk_ton_xuat foreign key (MaVT) references Ton(MaVT)

insert into Ton values ('N01', N'Nước ngọt pepsi', 600)
insert into Ton values ('N02', N'Nước ngọt coca', 2500)
insert into Ton values ('N03', N'Nước ngọt fanta', 500)
insert into Ton values ('N04', N'Nước ngọt mirinda', 1400)
insert into Ton values ('N05', N'Nước ngọt sting', 500)
insert into Nhap values ('001', 'N01', 1000, 10000, '5/6/2022') 
insert into Nhap values ('002', 'N05', 3000, 12000, '5/6/2022')
insert into Nhap values ('003', 'N03', 2000, 8000, '7/6/2022')
insert into Xuat values ('1001', 'N04',900, 10000, '7/6/2022')
insert into Xuat values ('1002', 'N02',1000 ,10000, '7/6/2022')

-- Câu 2
create view cau2
as
select ton.MaVT,TenVT,sum(SoLuongX*DonGiaX) as tienban
from Xuat inner join ton on Xuat.MaVT=ton.MaVT
group by ton.mavt,tenvt
go
select*from cau2

-- câu 3 thống kê soluongxuat theo tên vattu
create view cau3
as
select Ton.TenVT, sum(SoLuongX) as SoLuongT
from Xuat inner join ton on Xuat.MaVT = Ton.MaVT
group by Ton.TenVT
go
select*from cau3

-- câu 4 thống kê soluongnhap theo tên vật tư
create view cau4
as
select ton.TenVT, SUM(SoLuongN) as SoLuongNhap
FROM Nhap inner join ton on Nhap.MaVT=ton.MaVT
group by ton.TenVT
go
select*from cau4

-- câu 5 đưa ra tổng soluong còn trong kho biết còn = nhap – xuất + tồn theo từng nhóm vật tư
create view cau5
as
select ton.mavt,ton.tenvt,sum(soluongN)-sum(soluongX) +
sum(soluongT) as tongton
from nhap inner join ton on nhap.mavt=ton.mavt
 inner join xuat on ton.mavt=xuat.mavt
group by ton.mavt,ton.tenvt
go 
select*from cau5

-- câu 6 đưa ra tên vật tư số lượng tồn nhiều nhất
create view cau6
as
select tenvt
from ton
where soluongT = (select max(soluongT) from Ton)
go
select*from cau6

-- câu 7 đưa ra các vật tư có tổng số lượng xuất lớn hơn 100
create view cau7
as
select ton.mavt,ton.tenvt
from ton inner join xuat on ton.mavt=xuat.mavt
group by ton.mavt,ton.tenvt
having sum(soluongX) >= 100
go
select*from cau7

--câu 8 Tạo view đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo tháng và năm xuất
create view cau8 as
select MONTH(NgayX) AS "Tháng xuất", YEAR(NgayX) AS "Năm xuất", SUM(SoLuongX) AS Total_Quantity
from Xuat
group by MONTH(NgayX), YEAR(NgayX);
go
select*from cau8

--câu 9: tạo view đưa ra mã vật tư. tên vật tư. số lượng nhập. số lượng xuất. đơn giá N. đơn giá X. ngày nhập. Ngày xuất
create view cau9 as
select t.MaVT, t.TenVT,n.SoLuongN,x.SoLuongX, n.DonGiaN,x.DonGiaX, n.NgayN, x.NgayX
from Ton t
INNER JOIN Nhap n ON t.MaVT = n.MaVT
INNER JOIN Xuat x ON t.MaVT = x.MaVT;
go
select*from cau9
 
--câu 10: Tạo view đưa ra mã vật tư. tên vật tư và tổng số lượng còn lại trong kho. biết còn lại = SoluongN-SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015

create view cau10 as
select t.MaVT, t.TenVT, SUM(n.SoLuongN-x.SoLuongX+t.SoLuongT) as "SL còn lại"
from Ton t
INNER JOIN Nhap n ON t.MaVT = n.MaVT
INNER JOIN Xuat x ON t.MaVT = x.MaVT
where YEAR(n.NgayN) = 2015 OR YEAR(x.NgayX) = 2015
group by t.MaVT,t.TenVT;
go
select*from cau10