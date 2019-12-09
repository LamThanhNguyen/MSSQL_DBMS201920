use QUANLYNHANSU
go



-------------------------------------------------Function----------------------------------------------------------
create function [dbo].[LayMaTDHV]
(@matdhv varchar(50))
returns varchar(50)

as
begin
		declare @ret nvarchar(50)
		set @ret = (select MaTDHV from TrinhDoHV where MaTDHV = @matdhv)
		return @ret
		
	
end	
go


--------------------------------------------------------------View--------------------------------------------------------------
Create view NV 
as
	select MaNV,TenNV,GioiTinh,NgaySinh,CMND,DienThoai,DiaChi
	from NhanVien
go
------------------------------------------------------Trigger-------------------------------------------------------------------
Create Trigger XoaHD on HopDong
after insert 
as
  begin
			declare @manv nvarchar(20) = (select MaNV from inserted)
			declare @ngay date = getdate()					
			delete HopDong where NgayKTHD < @ngay and MaNV = @manv
			
					
  end
go

---------------------------------------------------Bảng Nhân Viên---------------------------------------------------------------------------
Create Proc [Dbo].[XoaHopDongTheoNV]
@manv varchar(50)
as
	
		delete HopDong where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaPhuCapTheoNV]
@manv varchar(50)
as
	
		delete PhuCap where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaThuongPhatTheoNV]
@manv varchar(50)
as
	
		delete ThuongPhat where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaBaoHiemTheoNV]
@manv varchar(50)
as
	
		delete BaoHiem where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaChamCongTheoNV]
@manv varchar(50)
as
	
		delete DiemDanh where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaTDHVTheoNV]
@manv varchar(50)
as
	
		delete NhanVien_TDHV where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go

Create Proc [Dbo].[SuaNhanVien]
@manv nvarchar(50),
@tennv nvarchar(20),
@gioitinh nvarchar(20),
@ngaysinh date,
@cmnd int,
@dienthoai int,
@diachi nvarchar(100)
as
	update NhanVien set MaNV=@manv,TenNV=@tennv,GioiTinh=@gioitinh,NgaySinh=@ngaysinh,CMND=@cmnd,DienThoai=@dienthoai,DiaChi=@diachi
	where MaNV=@manv

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[ThemNhanVien]
@manv nvarchar(50),
@tennv nvarchar(20),
@gioitinh nvarchar(20),
@ngaysinh date,
@cmnd int,
@dienthoai int,
@diachi nvarchar(100)

as
	if(not exists(select MaNV from NhanVien where MaNV = @manv))
	begin
		insert into NhanVien(MaNV,TenNV,GioiTinh,NgaySinh,CMND,DienThoai,DiaChi) values(@manv,@tennv,@gioitinh,@ngaysinh,@cmnd,@dienthoai,@diachi)
	end
	else
		select err = 1


create Proc [dbo].[LayMaNV1]
@manv varchar(50)
as
	
		select MaNV from NhanVien where MaNV = @manv
go

Create Proc [dbo].[LayThongTinNV]
@manhanvien varchar(50)
as
if(@manhanvien = 'NV')
begin
	select MaNV, TenNV, GioiTinh, NgaySinh,CMND,DienThoai,DiaChi
	from NV
end
else
	select MaNV, TenNV, GioiTinh, NgaySinh,CMND,DienThoai,DiaChi
	from NV
	where MaNV=@manhanvien

-------------------------------------------------------------------------------------------------
go
Create proc [Dbo].[ThongTinNhanVien]
@manhanvien varchar(5)

as
	select NhanVien.MaNV, TenNV, GioiTinh, NgaySinh, CMND, DienThoai, NhanVien.DiaChi, ChucVu.TenCV, PhongBan.TenPB, 
			HopDong.HSLuong,HopDong.NgayBDHD
	from ((NhanVien inner join HopDong on NhanVien.MaNV = HopDong.MaNV) inner join PhongBan on PhongBan.MaPB = HopDong.MaPB)
	inner join ChucVu on HopDong.MaCV = ChucVu.MaCV
	where NhanVien.MaNV = @manhanvien

-----------------------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaNhanVien]
@manv varchar(50)
as
	
		delete NhanVien where MaNV = @manv

	

-------------------------------------------------------------------------------------------------
go



--------------------------------------------------------------Bảng Tài khoản------------------------------------------------------------------------


Create Proc [Dbo].[DoiMatKhau]
@manv varchar(50),
@taikhoan nvarchar(50),
@matkhaumoi nvarchar(50)
as
	update TaiKhoan set MaNV = @manv, UserName = @taikhoan, Pass = @matkhaumoi
	where UserName = @taikhoan

-------------------------------------------------------------------------------------------------
go

Create Proc [Dbo].[ThemTaiKhoan]
@manv varchar(5),
@taikhoan nvarchar(50),
@matkhau nvarchar(50),
@tenquyenhan nvarchar(20)
as
if(not exists(select UserName from Taikhoan where UserName = @taikhoan))
begin
	insert into Taikhoan(MaNV, UserName, Pass, QuyenHan)
			values(@manv, @taikhoan,@matkhau, @tenquyenhan)
	select err = '0'
end
else select err = '1'

-------------------------------------------------------------------------------------------------
go

Create Proc [Dbo].[XoaTK]
@manv varchar(50)
as
	delete Taikhoan where MaNV = @manv

----------------------------------------------------thống kê----------------------------------------------------------------------
go
Create proc [dbo].[tkccXemTheoTenVaPhongBan]
@manv nvarchar(50),
@tenpb nvarchar(50),
@ngaydau date,
@ngaycuoi date,
@khoa int
as
	if(@khoa = 1)
	begin
		select NhanVien.MaNV, TenNV, TinhTrang, Ngay
		from NhanVien inner join DiemDANH on NhanVien.MaNV = DiemDanh.MaNV
		where NhanVien.MaNV =@manv  and Ngay >= @ngaydau and Ngay <= @ngaycuoi
		order by NhanVien.MaNV
	end
	else
	begin
		select NhanVien.MaNV, TenNV, TinhTrang, Ngay
		from ((NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV) inner join HopDong
				on NhanVien.MaNV = HopDong.MaNV) inner join PhongBan on HopDong.MaPB = PhongBan.MaPB
		where PhongBan.TenPB = @tenpb and Ngay >= @ngaydau and Ngay <= @ngaycuoi
		order by NhanVien.MaNV
	end

-----------------------------------------------------------------------------------------------------
go


Create proc [dbo].[tkSoNgayDiLamCuaNhanVien]
@ngaydau date,
@ngaycuoi date,
@khoa int
as
	if(@khoa = 1)
	begin
		select distinct NhanVien.MaNV, TenNV, count(TinhTrang) as SoNN
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay >= @ngaydau and Ngay <= @ngaycuoi and TinhTrang = N'Đi Làm'
		group by NhanVien.MaNV, TenNV
	end
	else if(@khoa = 2)
	begin
		select distinct NhanVien.MaNV, TenNV, count(TinhTrang) as SoNN
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay >= @ngaydau and Ngay <= @ngaycuoi and TinhTrang = N'Nghỉ Có Phép'
		group by NhanVien.MaNV, TenNV
	end
	else
	begin
	select distinct NhanVien.MaNV, TenNV, count(TinhTrang) as SoNN
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay >= @ngaydau and Ngay <= @ngaycuoi and TinhTrang = N'Nghỉ Không Phép'
		group by NhanVien.MaNV, TenNV
	end
-----------------------------------------------------------------------------------------------------
go

Create proc [dbo].[tkNhanVienNghiCoPhep]
@ngaydau date,
@ngaycuoi date,
@khoa int
as
	if(@khoa = 1)
	begin
		select NhanVien.MaNV, TenNV, Ngay
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay = @ngaydau and TinhTrang = N'Nghỉ Có Phép'
	end
	else
	begin
		select NhanVien.MaNV, TenNV, Ngay
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay >= @ngaydau and Ngay <= @ngaycuoi and TinhTrang = N'Nghỉ Có Phép'
	end
-----------------------------------------------------------------------------------------------------
go
Create proc [dbo].[tkNhanVienNghi]
@ngaydau date,
@ngaycuoi date,
@khoa int
as
	if(@khoa = 1)
	begin
		select NhanVien.MaNV, TenNV, Ngay
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay = @ngaydau and TinhTrang = N'Nghỉ Không Phép'
	end
	else
	begin
		select NhanVien.MaNV, TenNV, Ngay
		from NhanVien inner join DiemDanh on NhanVien.MaNV = DiemDanh.MaNV
		where Ngay >= @ngaydau and Ngay <= @ngaycuoi and TinhTrang = N'Nghỉ Không Phép'
	end

------------------------------------------------------------------------------------------------------------
go


-------------------------------------------------------------Bảng thưởng phạt--------------------------------------------------

Create Proc [Dbo].[SuaThuongPhat]
@manv nvarchar(50),
@matp nvarchar(20),
@loai nvarchar(20),
@tien int,
@lydo nvarchar(50),
@ngay date


as
	update ThuongPhat set MaNV = @manv, MaTP = @matp, Loai=@loai,Tien=@tien,LyDo=@lydo,Ngay=@ngay
	where MaTP = @matp

-----------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaThuongPhat]
@matp varchar(50)
as
	
		delete ThuongPhat where MaTP = @matp

	

-------------------------------------------------------------------------------------------------
go

create Proc [dbo].[LayMaTP]
@matp varchar(50)
as
	
		select MaTP from ThuongPhat where MaTP = @matp
go

Create Proc [Dbo].[ThemThuongPhat]
@manv nvarchar(50),
@matp nvarchar(20),
@loai nvarchar(20),
@tien int,
@lydo nvarchar(50),
@ngay date

as
	if(not exists(select MaTP from ThuongPhat where MaTP = @matp))
	begin
		insert into ThuongPhat(MaNV,MaTP,Loai,Tien,LyDo,Ngay) values(@manv,@matp,@loai,@tien,@lydo,@ngay)
	end
	else
		select err = 1


-------------------------------------------------------------------------------------------------
go
Create proc [dbo].[LayThuongPhat]
@ma nvarchar(5)
as
	if(@ma = '0')
	begin
		select NhanVien.MaNV,TenNV,MaTP,Loai,Tien,LyDo,Ngay from ThuongPhat inner join NhanVien on ThuongPhat.MaNV = NhanVien.MaNV
	end
	else
	begin
		select  NhanVien.MaNV,TenNV,MaTP,Loai,Tien,LyDo,Ngay from ThuongPhat inner join NhanVien on ThuongPhat.MaNV = NhanVien.MaNV where ThuongPhat.MaNV = @ma
	end

-----------------------------------------------------------Bảng Phụ Cấp-----------------------------------------------------------
go

Create proc [dbo].[LayPhuCap]
@ma nvarchar(50)
as
	if(@ma = '0')
	begin
		select PhuCap.MaNV, TenNV,MaPC, LoaiPC, Tien, TuNgay, DenNgay from PhuCap left join NhanVien on PhuCap.MaNV = NhanVien.MaNV
		order by TuNgay Desc
	end
	else
	begin
		select PhuCap.MaNV, TenNV,MaPC, LoaiPC, Tien, TuNgay, DenNgay from PhuCap left join NhanVien on PhuCap.MaNV = NhanVien.MaNV
		where TenNV = @ma
		order by TuNgay Desc
	end

---------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaPhuCap]
@mapc varchar(50)
as
	
		delete PhuCap where MaPC = @mapc	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[SuaPhuCap]
@manv nvarchar(50),
@mapc nvarchar(20),
@loaipc nvarchar(50),
@tien int,
@tungay date,
@denngay date

as
	update PhuCap set MaNV = @manv, MaPC = @mapc,LoaiPC=@loaiPC,Tien=@tien,TuNgay=@tungay,DenNgay=@denngay
	where MaPC = @mapc

-----------------------------------------------------------------------------------------------
go


create Proc [dbo].[LayMaPC]
@mapc varchar(50)
as
	
		select MaPC from PhuCap where MaPC = @mapc
go
Create Proc [Dbo].[ThemPhuCap]
@manv nvarchar(50),
@mapc nvarchar(20),
@loaipc nvarchar(50),
@tien int,
@tungay date,
@denngay date

as
	if(not exists(select MaPC from PhuCap where MaPC = @mapc))
	begin
		insert into PhuCap(MaNV,MaPC,LoaiPC,Tien,TuNgay,DenNgay) values(@manv,@mapc,@loaipc,@tien,@tungay,@denngay)
	end
	else
		select err = 1


-----------------------------------------------------Bảng Bảo hiểm---------------------------------------------------------------------
go
Create Proc [Dbo].[SuaBaoHiem]
@manv varchar(10),
@mabh varchar(20),
@loaibh nvarchar(30),
@ngaycap date,
@ngayhh date,
@noicap nvarchar(30)
as
	update BaoHiem set MaNV = @manv, MaBH = @mabh,LoaiBH=@loaibh,NgayCap=@ngaycap,NgayHetHan=@ngayhh,NoiCap=@noicap
	where MaBH = @mabh

-----------------------------------------------------------------------------------------------
go


Create proc [dbo].[LayBaoHiem]
@ma varchar(50)
as
	if(@ma = '0')
	begin
		select MaBH, LoaiBH,NgayCap,NgayHetHan, NoiCap from BaoHiem
	end
	else
	begin
		select  MaBH, LoaiBH,NgayCap,NgayHetHan, NoiCap from BaoHiem where LoaiBH = @ma
	end

----------------------------------------------------------------------------------------------------------------------
go

Create Proc [Dbo].[XoaBaoHiem]
@mabh varchar(50)
as
	if((not exists(select MaBH from BaoHiem where MaBH = @mabh)))
	begin
		delete BaoHiem where MaBH = @mabh
	end
	else
		select err = 1

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[ThemBaoHiem]
@mabh nvarchar(5),
@loaibh nvarchar(20),
@ngaycap date,
@ngayhh date,
@noicap nvarchar(50)


as
	if(not exists(select MaBH from BaoHiem where MaBH = @mabh))
	begin
		insert into BaoHiem(MaBH,LoaiBH,NgayCap,NgayHetHan,NoiCap) values(@mabh,@loaibh,@ngaycap,@ngayhh,@noicap)
	end
	else
		select err = 1

create Proc [dbo].[LayMaBH]
@mabh varchar(50)
as
	
		select MaBH from BaoHiem where MaBH = @mabh
go
-------------------------------------------------Bảng Chức Vụ----------------------------------------------------------------
go
Create proc [dbo].[LayChucVu]
@ma varchar(5)
as
	if(@ma = '0')
	begin
		select MaCV, TenCv from ChucVu
	end
	else
	begin
		select MaCV, TenCv from ChucVu where MaCV = @ma
	end

----------------------------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaChucVu]
@macv varchar(50)
as
	if((not exists (Select MaCV from HopDong where MaCV = @macv)))
	begin
		delete ChucVu where MaCV = @macv
	end
	else
		select err = 1

-------------------------------------------------------------------------------------------------
go

create Proc [dbo].[LayMaCV]
@macv varchar(50)
as
	
		select MaCV from ChucVu where MaCV = @macv
go

Create Proc [Dbo].[ThemChucVu]
@macv varchar(50),
@tencv nvarchar(20)


as
	if(not exists(select MaCV from ChucVu where MaCV = @macv))
	begin
		insert into ChucVu(MaCV,TenCV) values(@macv,@tencv)
	end
	else
		select err = 1


------------------------------------------------Bảng phòng ban-------------------------------------------------
go

create Proc [dbo].[LayMaPB]
@mapb varchar(50)
as
	
		select MaPB from HopDong where MaPB = @mapb
go
Create proc [Dbo].[HienPhongBan]
@maphong varchar(5)
as
	
	if(@maphong = '0')
	begin
		select PhongBan.MaPB, TenPB,SDTPB,PhongBan.DIACHI, count(HopDong.MaPB) as SoNV
		from PhongBan left join HopDong on PhongBan.MaPB = HopDong.MaPB
		GROUP BY PhongBan.MaPB, TenPB,SDTPB,PhongBan.DIACHI
	end
	else
	begin
		select PhongBan.MaPB, TenPB,SDTPB,PhongBan.DIACHI, count(HopDong.MaPB) as SoNV
		from PhongBan left join HopDong on PhongBan.MaPB = HopDong.MaPB
		where PhongBan.MaPB = @maphong
		GROUP BY PhongBan.MaPB, TenPB,SDTPB,PhongBan.DIACHI
	end	

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[XoaPhongBan]
@maphong varchar(5)
as
	if((not exists (Select MaPB from HopDong where MaPB = @maphong)))
	begin
		delete PhongBan where MaPB = @maphong
	end
	else
		select err = 1

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[CapNhatPhongBan]
@maphong varchar(5),
@tenphong nvarchar(20),
@diachi nvarchar(30),
@sdt int
as
	update PhongBan set MaPB = @maphong, TenPB = @tenphong,SDTPB=@sdt,DIACHI=@diachi
	where MaPB = @maphong

-----------------------------------------------------------------------------------------------
go





Create Proc [Dbo].[ThemPhongBan]
@maphong varchar(50),
@tenphong nvarchar(20),
@diachi nvarchar(30),
@sdt int


as
	if(not exists(select MaPB from PhongBan where MaPB = @maphong))
	begin
		insert into PhongBan(MaPB, TenPB,SDTPB,DIACHI) values(@maphong, @tenphong,@sdt,@diachi)
	end
	else
		select err = 1


--------------------------------------------------------------------------------------------------------------------------
go
	
Create proc [dbo].[LayChucVuTuMaNV]
@manv varchar(5)
as
	select TenCV from (NhanVien inner join HopDong on NhanVien.MaNV = HopDong.MaNV) inner join ChucVu on HopDong.MaCV = ChucVu.MaCV
	where NhanVien.MaNV = @manv

----------------------------------------------------tính lương------------------------------------------------------------------
go

Create proc [dbo].[LayLuongCB]
@hesoluong int
as
	select LuongCB From HopDong where HSLuong = @hesoluong

-------------------------------------------------------------------------------------------------------------------------------
go


create proc [dbo].[LayTienThuong]
@manv varchar(5),
@ngaydau date,
@ngaycuoi date
as
	select Tien, Loai from ThuongPhat
	where MaNV = @manv and (Ngay >= @ngaydau and Ngay <= @ngaycuoi)

-------------------------------------------------------------------------------------------------
go
Create proc [dbo].[DemSoNgayNghiKhongPhep]
@manv varchar(50),
@ngaydau date,
@ngaycuoi date
as
	select MaNV, COUNT(Ngay)as NgayLam from DiemDanh
	where MaNV = @manv and (Ngay >= @ngaydau and Ngay <= @ngaycuoi) and TinhTrang = N'Nghỉ Không Phép'
	Group By MaNV

-------------------------------------------------------------------------------------------------
go
Create proc [dbo].[DemSoNgaynghiCoPhep]
@manv varchar(50),
@ngaydau date,
@ngaycuoi date
as
	select MaNV, COUNT(Ngay)as NgayLam from DiemDanh
	where MaNV = @manv and (Ngay >= @ngaydau and Ngay <= @ngaycuoi) and TinhTrang = N'Nghỉ Có Phép'
	Group By MaNV

-------------------------------------------------------------------------------------------------
go

Create proc [dbo].[LayTienPhuCap]
@manv varchar(50),
@ngay date
as
	select MaNV, Sum(Tien) as Tien From PhuCap 
	where MaNV = @manv and (TuNgay <= @ngay and DenNgay >= @ngay)
	group by MaNV

------------------------------------------------------------------------------------------------------------------------------------------------------
go

Create proc [dbo].[DemSoNgayLam]
@manv varchar(5),
@ngaydau date,
@ngaycuoi date
as
	select MaNV, COUNT(Ngay)as NgayLam from DiemDanh 
	where MaNV = @manv and (Ngay >= @ngaydau and Ngay <= @ngaycuoi) and TinhTrang = N'Đi Làm'
	Group By MaNV

-------------------------------------------------------------------------------------------------
go
Create proc [dbo].[LayNgayVaoLam]
@manv varchar(5)
as
	select NgayBDHD from NhanVien inner join HopDong on NhanVien.MaNV = HopDong.MaNV where HopDong.MaNV = @manv

-------------------------------------------------------------------------------------------------
go

Create proc [dbo].[TongLuongNVTheoPB]
@ma nvarchar(50)
as

begin
	select NhanVien.MaNV, TenNV, HSLuong, '0' as NL, '0' as T, '0' as P, '0' as Tien, '0' as TL
	From (NhanVien inner join HopDong on NhanVien.MaNV = HopDong.MaNV) inner join PhongBan on HopDong.MaPB = PhongBan.MaPB
	where TenPB=@ma

end
go


Create proc [dbo].[TongLuongNV]
@ma varchar(5)
as
if(@ma = '0')
begin
	select NhanVien.MaNV, TenNV, HSLuong, '0' as NL, '0' as T, '0' as P, '0' as Tien, '0' as TL
	From NhanVien inner join HopDong on NhanVien.MaNV = HopDong.MaNV
end
else 
begin
	select LuongCB,HSLuong from NhanVien inner join HopDong on NhanVien.MaNV = HopDong.MaNV
	where NhanVien.MaNV = @ma
end
go


----------------------------------------chấm công---------------------------------------------------------


Create Proc [Dbo].[XoaChamCongTheoNgay]
@ngay date
as
	delete DiemDanh where Ngay = @ngay

-------------------------------------------------------------------------------------------------
go

create Proc [Dbo].[XoaChamCong]
@manv varchar(5)
as
	delete DiemDanh where MaNV = @manv

-------------------------------------------------------------------------------------------------
go

Create Proc [Dbo].[LayChamCong]
@ma varchar(5),
@ngay date
as
if(@ma = '0')
begin
	select DiemDanh.MaNV, NhanVien.TenNV, TinhTrang 
	from DiemDanh inner join NhanVien on DiemDanh.MaNV = NhanVien.MaNV
	where Ngay = @ngay
end
else
begin
	select ngay from DiemDanh where Ngay = @ngay
end

-------------------------------------------------------------------------------------------------
go
Create Proc [Dbo].[ThemChamCong]
@manv varchar(5),
@ngay date,
@tinhtrang Nvarchar(20)
as
	insert into DiemDanh(MaNV, Ngay, TinhTrang) values (@manv, @ngay, @tinhtrang)
	
-------------------------------------------------------------------------------------------------
go
---------------------------------------------------------------TDHV----------------------------------------------------
Create Proc [Dbo].[SuaTDHV]
@matdhv nvarchar(10),
@tentdhv nvarchar(50),
@cnganh nvarchar(50)
as
	update TrinhDoHV set MaTDHV = @matdhv, TenTDHV = @tentdhv,CNganh = @cnganh
	where MaTDHV = @matdhv

-----------------------------------------------------------------------------------------------
go
Create proc [dbo].[LayTDHV]
@ma varchar(5)
as
	if(@ma = '0')
	begin
		select MaTDHV,TenTDHV,CNganh from TrinhDoHV
	end
	else
	begin
		select   MaTDHV,TenTDHV,CNganh from TrinhDoHV where MaTDHV = @ma
	end

----------------------------------------------------------------------------------------------------------------------
go

------------------------------------------------------------Bảng Hợp đồng------------------------------------------------

create Proc [dbo].[SuaHopDong]
@mahd nvarchar(50),
@loaihd nvarchar(50),
@ngaybdhd date,
@ngaykt date,
@hsluong int,
@luongcb int,
@manv varchar(10),
@macv varchar(10),
@mapb varchar(10)

as
	update HopDong set MaHD=@mahd, LoaiHD = @loaihd, NgayBDHD = @ngaybdhd,NgayKTHD=@ngaykt,HSLuong=@hsluong,LuongCB=@luongcb,MaNV=@manv,MaCV=@macv,MaPB=@mapb
	where MaHD=@mahd

go
Create Proc [Dbo].[ThemHopDong]
@mahd nvarchar(50),
@loaihd nvarchar(50),
@ngaybdhd date,
@ngaykthd date,
@hsluong int,
@luongcb int,
@manv nvarchar(20),
@macv nvarchar(20),
@mapb nvarchar(20)



as
	if(not exists(select MaHD from HopDong where MaHD = @mahd))
	begin
		insert into HopDong(MaHD,LoaiHD,NgayBDHD,NgayKTHD,HSLuong,LuongCB,MaNV,MaCV,MaPB) values(@mahd,@loaihd,@ngaybdhd,@ngaykthd,@hsluong,@luongcb,@manv,@macv,@mapb)
	end
	else
		select err = 1
go

Create Proc [dbo].[XoaHopDong]
@manv varchar(10)
as
	
	begin
		delete HopDong where MaNV = @manv
	end
GO

Create proc [dbo].[LayHopDong]
@ma varchar(5)
as
	if(@ma = '0')
	begin
		select MaNV,MaHD, LoaiHD,NgayBDHD,NgayKTHD,HSLuong,LuongCB,MaCV,MaPB from HopDong
	end
	else
	begin
		select MaNV,MaHD, LoaiHD,NgayBDHD,NgayKTHD,HSLuong,LuongCB,MaCV,MaPB from HopDong where MaHD = @ma
	end

----------------------------------------------------------------------------------------------------------------------
go

create Proc [dbo].[LayMaHD]
@mahd varchar(50)
as
	
		select MaHD from HopDong where MaHD = @mahd
go



----------------------------------------Đăng nhập------------------------------------------------------
Create Proc [dbo].[DangNhap]
@taikhoan nvarchar(50),
@matkhau nvarchar(50)
as
if(exists(select UserName from TaiKhoan where  UserName = @taikhoan and Pass = @matkhau))
begin
	select err = 0
end
else
	select err = 1
-------------------------------------------------------------------------------------------------
go  

Create proc [dbo].[LayQuyenHanNV]
@taikhoan nvarchar(50),
@matkhau nvarchar(50)
as
	select QuyenHan from Taikhoan where UserName = @taikhoan and Pass = @matkhau

go


Create Proc [dbo].[LayMaNV]
@tendangnhap nvarchar(50)
as
if(@tendangnhap = '0')
begin
	select MaNV from NhanVien
end
else 
begin
	select MaNV from Taikhoan where UserName = @tendangnhap

end
-------------------------------------------------------------------------------------------------
go


Create Proc [Dbo].[layTenNhanVien]
@manhanvien varchar(5)
as
if(@manhanvien = '0')
begin
	Select MaNV, TenNV from NhanVien
end
else
begin
	select TenNV from NhanVien where MaNV= @manhanvien
end

-------------------------------------------------------------------------------------------------
go

