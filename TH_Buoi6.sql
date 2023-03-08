--1. Cho biết danh sách các nhân viên có ít nhất một thân nhân 
select (NHANVIEN.HONV + ' '+ NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) as'danh sách các nv có ít nhất 1 thân nhân'  
from THANNHAN, NHANVIEN
where THANNHAN.MA_NVIEN = NHANVIEN.MANV
group by (NHANVIEN.HONV + ' '+ NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
having count(THANNHAN.MA_NVIEN) = 1

--2. Cho biết danh sách các nhân viên không có thân nhân nào
select (NHANVIEN.HONV +' '+ NHANVIEN.TENLOT +' '+ NHANVIEN.TENNV) as 'danh sách nhân viên không có thân nhân'
from NHANVIEN
where NHANVIEN.MANV not in (select THANNHAN.MA_NVIEN
							from NHANVIEN, THANNHAN
							where NHANVIEN.MANV = THANNHAN.MA_NVIEN)

--3. Cho biết họ tên các nhân viên có trên 2 thân nhân
select (NHANVIEN.HONV + ' '+ NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) as'danh sách các nv có trên 2 thân nhân'  
from THANNHAN, NHANVIEN
where THANNHAN.MA_NVIEN = NHANVIEN.MANV
group by (NHANVIEN.HONV + ' '+ NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
having count(THANNHAN.MA_NVIEN) > 2

--4. Cho biết họ tên những trưởng phòng có ít nhất một thân nhân
select (NHANVIEN.HONV + ' '+ NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) as'danh sách các trường phòng có ít nhất 1 thân nhân'
from NHANVIEN, PHONGBAN
where NHANVIEN.MANV = PHONGBAN.TRPHG AND PHONGBAN.TRPHG IN (select THANNHAN.MA_NVIEN
															from NHANVIEN, THANNHAN
															where NHANVIEN.MANV = THANNHAN.MA_NVIEN)

--6. Cho biết họ tên các nhân viên phòng Quản lý có mức lương trên mức lương trung bình của phòng Quản lý.
select (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Nhân viên lương trên mức trung bình của phòng quản lý'
from NHANVIEN,PHONGBAN
where NHANVIEN.PHG = PHONGBAN.MAPHG AND
      PHONGBAN.TENPHG = N'Quản lý' AND
	  NHANVIEN.LUONG >(select AVG(NHANVIEN.LUONG)
					   from NHANVIEN, PHONGBAN
					   where NHANVIEN.PHG = PHONGBAN.MAPHG AND PHONGBAN.TENPHG = N'Quản lý')

--7. Cho biết họ tên nhân viên có mức lương trên mức lương trung bình của phòng mà nhân
-- viên đó đang làm việc

--8. Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất.
select PHONGBAN.TENPHG, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên trưởng phòng của phòng ban đông nhân viên nhất'
from NHANVIEN, PHONGBAN
where NHANVIEN.MANV = PHONGBAN.TRPHG AND
	  PHONGBAN.MAPHG = (select top 1 PHONGBAN.MAPHG
						from NHANVIEN, PHONGBAN
						where NHANVIEN.PHG = PHONGBAN.MAPHG
						group by PHONGBAN.MAPHG
						order by COUNT(NHANVIEN.PHG) desc)

--9. Cho biết danh sách các đề án mà nhân viên có mã là 456 chưa tham gia.
select DEAN.MADA
from DEAN
where DEAN.MADA NOT IN (select PHANCONG.MADA
						from PHANCONG
						where PHANCONG.MA_NVIEN = '456')

--10. Danh sách nhân viên gồm mã nhân viên, họ tên và địa chỉ của những nhân viên không
--sống tại TP Quảng Ngãi nhưng làm việc cho một đề án ở TP Quảng Ngãi.
select distinct (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
from NHANVIEN, DEAN, DIADIEM_PHG
where NHANVIEN.PHG = DEAN.PHONG AND
	  NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND
	  DEAN.DDIEM_DA LIKE '%Quảng Ngãi' AND
	  DIADIEM_PHG.DIADIEM NOT LIKE '%Quảng Ngãi'

--11. Tìm họ tên và địa chỉ của các nhân viên làm việc cho một đề án ở một địa điểm nhưng lại không sống tại địa điểm đó.
select distinct (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
from NHANVIEN, DEAN, DIADIEM_PHG
where NHANVIEN.PHG = DEAN.PHONG AND
		  NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND
		  DEAN.DDIEM_DA IN (SELECT DEAN.DDIEM_DA FROM DEAN) AND
		  DIADIEM_PHG.DIADIEM NOT LIKE DEAN.DDIEM_DA
--12. Cho biết danh sách các mã đề án có: nhân công với họ là Lê hoặc có người trưởng phòng chủ trì đề án với họ là Lê.
select PHANCONG.MADA FROM NHANVIEN, PHANCONG 
where NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Lê'
UNION 
select DEAN.MADA
from NHANVIEN, PHONGBAN, DEAN
where NHANVIEN.MANV = PHONGBAN.TRPHG AND PHONGBAN.MAPHG = DEAN.PHONG AND NHANVIEN.HONV = N'Lê'
--13. Liệt kê danh sách các đề án mà cả hai nhân viên có mã số 123 và 789 cùng làm.
select DEAN.MADA
from DEAN
where DEAN.MADA IN (select PHANCONG.MADA from PHANCONG where PHANCONG.MA_NVIEN = '123' AND PHANCONG.MA_NVIEN = '789')
--14. Liệt kê danh sách các đề án mà cả hai nhân viên Đinh Bá Tiến và Trần Thanh Tâm cùng làm
select DEAN.TENDEAN
from NHANVIEN, DEAN, PHANCONG
where DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Đinh' AND NHANVIEN.TENLOT = N'Bá' AND NHANVIEN.TENNV = N'Tiến' 
UNION
select DEAN.TENDEAN
from NHANVIEN, DEAN, PHANCONG
where DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Trần' AND NHANVIEN.TENLOT = N'Thanh' AND NHANVIEN.TENNV = N'Tâm'
--15. Danh sách những nhân viên (bao gồm mã nhân viên, họ tên, phái) làm việc trong mọi đề án của công ty
select MANV, PHAI, (HONV+ '' +TENLOT+ '' +TENNV) AS 'HỌ TÊN'
from NHANVIEN 
select DEAN.TENDEAN
from NHANVIEN, DEAN, PHANCONG
where DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN