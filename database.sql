use master
go

drop database if exists QLKS
go
create database QLKS
go
use QLKS
go

set dateformat YMD;
go

drop table if exists dbo.KhachHang
go
create table dbo.KhachHang
(
	MaKH varchar(5) primary key,
	HoTenKH nvarchar(100) not null,
	CMND varchar(50) not null,
	QuocTich nvarchar(100) not null,
	SoLanDatPhong int check(SoLanDatPhong >= 0) default(0)
)
go

drop table if exists dbo.Nomal
go
create table dbo.Nomal
(
	MaKH varchar(5) primary key(MaKH),
	foreign key(MaKH) references KhachHang(MaKH)
)
go

drop table if exists dbo.Vip
go
create table dbo.Vip
(
	MaKH varchar(5) primary key,
	foreign key(MaKH) references KhachHang(MaKH),
	NgayhetHan datetime
)
go

drop table if exists dbo.KhachHang_SDT
go
create table dbo.KhachHang_SDT 
(
	SDT char(10),
	MaKH varchar(5),
	primary key(SDT, MaKH),
	foreign key(MaKH) references KhachHang(MaKH)
)
go

drop table if exists dbo.DongKhach
go
create table dbo.DongKhach 
(
	SDT char(10) primary key,
	HoTenDK nvarchar(100) not null,
	CMND varchar(50) not null
)
go

drop table if exists dbo.KhachHang_Co_DongKhach
go
create table dbo.KhachHang_Co_DongKhach 
(
	SDT char(10),
	MaKH varchar(5),
	primary key(SDT, MaKH),
	foreign key(SDT) references DongKhach(SDT),
	foreign key(MaKH) references KhachHang(MaKH)
)
go

drop table if exists dbo.LoaiPhong
go
create table dbo.LoaiPhong
(
	MaLP varchar(5) primary key,
	TenLP nvarchar(100) not null,
	DonGia decimal check(DonGia >= 0) default(0)
)
go

drop table if exists dbo.Phong
go
create table dbo.Phong
(
	MaPhong varchar(4) primary key,
	SucChua int check(SucChua > 0) default(1),
	SoGiuong int check(SoGiuong > 0) default(1),
	ViTri nvarchar(100),
	TinhTrang int check (TinhTrang >= 0 and TinhTrang <= 2) default(0),
	MaLP varchar(5) not null,
	foreign key (MaLP) references LoaiPhong(MaLP)
)
go

drop table if exists dbo.DichVu
go
create table dbo.DichVu
(
	MaDV varchar(5) primary key,
	TenDV nvarchar(100) not null,
	DonGia decimal check(DonGia >= 0) default(0)
)
go

drop table if exists dbo.PhieuPhong
go
create table dbo.PhieuPhong
(
	MaPP varchar(5) primary key,
	NgayGioNhan datetime not null default(getdate()),
	NgayGioTra datetime,
	TinhTrang int check (TinhTrang >= 0 and TinhTrang <= 2),
	MaPhong varchar(4) not null,
	MaKH varchar(5) not null,
	foreign key (MaPhong) references Phong(MaPhong),
	foreign key (MaKH) references KhachHang(MaKH)
)
go

drop table if exists dbo.SuDungDichVu
go
create table dbo.SuDungDichVu
(
  NgayGioDat date not null,
  Soluong int not null,
  MaPP varchar(5) not null,
  MaDV varchar(5) not null,
  primary key (MaDV, MaPP),
  foreign key (MaPP) references PhieuPhong(MaPP),
  foreign key (MaDV) references DichVu(MaDV)
);
go

drop table if exists dbo.HoaDon
go
create table dbo.HoaDon
(
	MaHD varchar(5) primary key,
	TienPhong decimal not null,
	TienDichVu decimal, 
	TongTien decimal check(TongTien > 0),
	MaPP varchar(5) not null,
	foreign key (MaPP) references PhieuPhong(MaPP)
)
go

/*------------------------FUNCTION------------------------*/

-- Tạo hàm để phát sinh mã cho bảng KhachHang
drop function if exists dbo.idMaKH
go
create function dbo.idMaKH()
returns varchar(5)
as
begin
    declare @maxMaKH varchar(5)
    select @maxMaKH = max(MaKH) from dbo.KhachHang
    if @maxMaKH is null
        set @maxMaKH = 'KH000'
    return 'KH' + right('000' + cast(cast(substring(@maxMaKH, 3, len(@maxMaKH) - 2) as int) + 1 as varchar(3)), 3)
end
go

-- Tạo hàm để phát sinh mã cho bảng LoaiPhong
drop function if exists dbo.idMaLP
go
create function dbo.idMaLP()
returns varchar(5)
as
begin
    declare @maxMaLP varchar(5)
    select @maxMaLP = max(MaLP) from dbo.LoaiPhong
    if @maxMaLP is null
        set @maxMaLP = 'LP000'
    return 'LP' + right('000' + cast(cast(substring(@maxMaLP, 3, len(@maxMaLP) - 2) as int) + 1 as varchar(3)), 3)
end
go

-- Tạo hàm để phát sinh mã cho bảng Phong
drop function if exists dbo.idMaPhong
go
create function dbo.idMaPhong()
returns varchar(4)
as
begin
    declare @maxMaPhong varchar(4)
    select @maxMaPhong = max(MaPhong) from dbo.Phong
    if @maxMaPhong is null
        set @maxMaPhong = 'P000'
    return 'P' + right('000' + cast(cast(substring(@maxMaPhong, 2, len(@maxMaPhong) - 1) as int) + 1 as varchar(3)), 3)
end
go

-- Tạo hàm để phát sinh mã cho bảng DichVu
drop function if exists dbo.idMaDV
go
create function dbo.idMaDV()
returns varchar(5)
as
begin
    declare @maxMaDV varchar(5)
    select @maxMaDV = max(MaDV) from dbo.DichVu
    if @maxMaDV is null
        set @maxMaDV = 'DV000'
    return 'DV' + right('000' + cast(cast(substring(@maxMaDV, 3, len(@maxMaDV) - 2) as int) + 1 as varchar(3)), 3)
end
go

-- Tạo hàm để phát sinh mã cho bảng PhieuPhong
drop function if exists dbo.idMaPP
go
create function dbo.idMaPP()
returns varchar(5)
as
begin
    declare @maxMaPP varchar(5)
    select @maxMaPP = max(MaPP) from dbo.PhieuPhong
    if @maxMaPP is null
        set @maxMaPP = 'PP000'
    return 'PP' + right('000' + cast(cast(substring(@maxMaPP, 3, len(@maxMaPP) - 2) as int) + 1 as varchar(3)), 3)
end
go

-- Tạo hàm để phát sinh mã cho bảng HoaDon
drop function if exists dbo.idMaHD
go
create function dbo.idMaHD()
returns varchar(5)
as
begin
    declare @maxMaHD varchar(5)
    select @maxMaHD = max(MaHD) from dbo.HoaDon
    
    if @maxMaHD is null
        set @maxMaHD = 'HD000'
    return 'HD' + right('000' + cast(cast(substring(@maxMaHD, 3, len(@maxMaHD) - 2) as int) + 1 as varchar(3)), 3)
end
go

insert into dbo.KhachHang values (dbo.idMaKH(), N'Ðinh Phuong My', '013682083414', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Nguyễn Ngọc Trâm Anh', '035338182963', N'Vietnam', 2);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Bùi Hải Lâm', '023374657479', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Dương Mỹ Dung', '012190890258', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Nguyễn Hữu Minh Hoàng', '094895487516', N'Vietnam', 5);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Phạm Phương Duy', '090995071488', N'Vietnam', 3);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Mai Ngô Thiên Phú', '072734850813', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Phạm Thị Hằng Nga', '096166080760', N'Vietnam', 2);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Nguyễn Mạnh Duy', '090873777212', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Lê Cao Thắng', '022808059969', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Dương Tất Thành', '063724036068', N'Vietnam', 1);
insert into dbo.KhachHang values (dbo.idMaKH(), N'Trịnh Xuân Minh', '035852201637', N'Vietnam', 5);
select * from KhachHang
go

insert into dbo.KhachHang_SDT values ('0189977442', 'KH001')
insert into dbo.KhachHang_SDT values ('0877896226', 'KH001')
insert into dbo.KhachHang_SDT values ('0374773039', 'KH002')
insert into dbo.KhachHang_SDT values ('0347117977', 'KH003')
insert into dbo.KhachHang_SDT values ('0973287768', 'KH002')
go
select * from KhachHang_SDT
go

insert into dbo.Vip values ('KH003', '2020-10-09')
go
select * from Vip
go

insert into dbo.Nomal values ('KH002')
go
select * from Nomal
go

insert into dbo.LoaiPhong values (dbo.idMaLP(), N'Phòng đơn', 20000)
insert into dbo.LoaiPhong values (dbo.idMaLP(), N'Phòng đôi', 50000)
go
select * from LoaiPhong
go

insert into dbo.Phong values (dbo.idMaPhong(), 2, 1, N'Tầng 1', 0, 'LP001')
insert into dbo.Phong values (dbo.idMaPhong(), 2, 1, N'Tầng 1', 1, 'LP001')
insert into dbo.Phong values (dbo.idMaPhong(), 4, 2, N'Tầng 1', 1, 'LP002')
insert into dbo.Phong values (dbo.idMaPhong(), 4, 2, N'Tầng 2', 0, 'LP002')
insert into dbo.Phong values (dbo.idMaPhong(), 2, 1, N'Tầng 2', 1, 'LP002')
insert into dbo.Phong values (dbo.idMaPhong(), 4, 2, N'Tầng 2', 1, 'LP001')
insert into dbo.Phong values (dbo.idMaPhong(), 2, 1, N'Tầng 2', 1, 'LP002')
insert into dbo.Phong values (dbo.idMaPhong(), 2, 1, N'Tầng 2', 0, 'LP002')
insert into dbo.Phong values (dbo.idMaPhong(), 2, 1, N'Tầng 2', 1, 'LP001')
go 
select * from Phong
go 

insert into dbo.DichVu values (dbo.idMaDV(), N'Bún bò Huế', 30000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Hũ tiếu gõ', 20000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Mì 2 trứng', 17000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Gửi xe', 5000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Rửa xe', 30000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Giặt, ủi là', 20000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Xe đưa đón sân bay', 100000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Cho thuê xe tự lái', 120000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Trông trẻ', 30000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Spa', 300000)
insert into dbo.DichVu values (dbo.idMaDV(), N'Đánh golf, tennis', 200000)
go 
select * from DichVu
go

insert into dbo.PhieuPhong values (dbo.idMaPP(), '2021-05-02', '2021-05-07', 1, 'P003', 'KH002')
insert into dbo.PhieuPhong values (dbo.idMaPP(), '2021-05-16', NULL, 2, 'P002', 'KH003')
insert into dbo.PhieuPhong values (dbo.idMaPP(), '2021-05-30', '2021-06-10', 0, 'P001', 'KH001')
insert into dbo.PhieuPhong values (dbo.idMaPP(), '2021-06-15', NULL, 0, 'P004', 'KH004')
go
select * from PhieuPhong
go

insert into dbo.SuDungDichVu values ('2023-11-18', 2, 'PP001', 'DV001')
insert into dbo.SuDungDichVu values ('2023-11-16', 2, 'PP003', 'DV001')
select * from SuDungDichVu
go
insert into dbo.HoaDon values (dbo.idMaHD(), 20000, 30000, 50000, 'PP002')
insert into dbo.HoaDon values (dbo.idMaHD(), 20000, 30000, 50000, 'PP003')
insert into dbo.HoaDon values (dbo.idMaHD(), 50000, null, 50000, 'PP001')
insert into dbo.HoaDon values (dbo.idMaHD(), 40000, 30000, 70000, 'PP002')
insert into dbo.HoaDon values (dbo.idMaHD(), 50000, null, 50000, 'PP002')
insert into dbo.HoaDon values (dbo.idMaHD(), 40000, null, 40000, 'PP004')
select * from HoaDon
go

-- Tạo trigger kiểm tra ràng buộc miền giá trị cho bảng PhieuPhong
drop trigger if exists dbo.CheckNgayGioTra
go
create trigger CheckNgayGioTra
on dbo.PhieuPhong
after update
as
begin
    if update(NgayGioTra) -- chỉ thực hiện trigger khi cột NgayGioTra được cập nhật
    begin
        if exists (
            select 1
            from inserted i
            where i.NgayGioTra is not null
                and i.NgayGioTra <= i.NgayGioNhan
        )
        begin
            print('Check constraint violation. NgayGioTra must be greater than NgayGioNhan.')
            rollback transaction
        end
    end
end
go

-- Tạo trigger kiểm tra ràng buộc miền giá trị cho bảng Phong
drop trigger if exists dbo.CheckPhongTinhTrang
go
create trigger CheckPhongTinhTrang
on dbo.Phong
after insert, update
as
begin
    if exists (
        select 1
        from inserted i
        where i.TinhTrang is not null
            and (i.TinhTrang < 0 or i.TinhTrang > 2)
    )
    begin
        print('Check constraint violation. TinhTrang must be between 0 and 2.')
        rollback transaction
    end
end
go