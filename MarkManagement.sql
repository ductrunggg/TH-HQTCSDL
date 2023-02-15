create database MarkManagement
go 
use MarkManagement
go

create table Students
(
StudentID nvarchar(12) primary key,
StudentName nvarchar(25) not null,
DateofBirth Datetime not null,
Email nvarchar(40),
Phone nvarchar(12),
Class nvarchar(10)
)

create table Subjects
(
SubjectID nvarchar(10) primary key,
SubjectName nvarchar(25) not null
)

create table Mark
(
StudentID nvarchar(12) not null,
SubjectID nvarchar(10) not null,
Date datetime,
Theory tinyint,
Practical tinyint
constraint mark_pk primary key (StudentID, SubjectID)
)

insert into Students values ('AV0807005',N'Mai Trung Hiếu','11/10/1989','trunghieu@yahoo.com','0904115116','AV1')
insert into Students values ('AV0807006',N'Nguyễn Quý Hùng','2/12/1988','quyhung@yahoo.com','0955667787','AV2')
insert into Students values ('AV0807007',N'Đỗ Đắc Huỳnh','2/1/1990','dachuynh@yahoo.com','0988574747','AV2')
insert into Students values ('AV0807009',N'An Đăng Khuê','6/3/1986','dangkhue@yahoo.com','0986757463','AV1')
insert into Students values ('AV0807010',N'Nguyễn T.Tuyết Lan','12/7/1989','tuyetlan@gmail.com','0983310342','AV2')
insert into Students values ('AV0807011',N'Đinh Phụng Long','2/12/1990','phunglong@yahoo.com',null,'AV1')
insert into Students values ('AV0807012',N'Nguyễn Tuấn Nam','2/3/1990','tuannam@yahoo.com',null,'AV1')

insert into Subjects values ('S001', 'SQL')
insert into Subjects values ('S002', 'Java Simplefield')
insert into Subjects values ('S003', 'Active Server Page')

insert into Mark values ('AV0807005','S001','6/5/2008','8','25')
insert into Mark values ('AV0807006','S002','6/5/2008','16','30')
insert into Mark values ('AV0807007','S001','6/5/2008','10','25')
insert into Mark values ('AV0807009','S003','6/5/2008','7','13')
insert into Mark values ('AV0807010','S003','6/5/2008','9','16')
insert into Mark values ('AV0807011','S002','6/5/2008','8','30')
insert into Mark values ('AV0807012','S001','6/5/2008','7','31')
insert into Mark values ('AV0807005','S002','6/6/2008','12','11')
insert into Mark values ('AV0807009','S003','6/6/2008','11','20')
insert into Mark values ('AV0807010','S001','6/6/2008','7','6')

-- 1. Hiển thị nội dung bảng Students
select*from Students
-- 2. Hiển thị nội dung danh sách sinh viên lớp AV1
select*from Students
where Class = 'AV1'
-- 3. Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
update Students
set Class = 'AV2'
where StudentID = 'AV0807012'
-- 4. Tính tổng số sinh viên của từng lớp
create procedure tinhtongssv @malop nvarchar(10)
as
begin
select count(StudentID) as 'Số lượng sinh viên',Class as 'mã lớp'
from Students where Class = @malop
group by Class
end
go
exec tinhtongssv 'AV1'
exec tinhtongssv 'AV2'
-- 5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
select*from Students
where Class = 'AV2'
order by StudentName
-- 6. Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
select * from Students inner join Mark ON Students.StudentID = Mark.StudentID
Where SubjectID = 'S001' and theory < 10 and Date = '6/5/2008'
-- 7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
select count(Class) As 'Tổng số sinh viên' From Students inner join Mark ON Students.StudentID = Mark.StudentID
Where SubjectID = 'S001' and theory < 10
-- 8. Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
select*from Students
where Class = 'AV1' and DateofBirth > '1/1/1980'
-- 9. Xoá sinh viên có mã AV0807011
DELETE FROM Students Where StudentID = 'AV0807011'
-- 10. Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
select Students.StudentID,Mark.SubjectID,Theory,Practical,Date 
from Students inner join Mark ON Students.StudentID = Mark.StudentID 
where SubjectID = 'S001' and Date = '6/5/2008'