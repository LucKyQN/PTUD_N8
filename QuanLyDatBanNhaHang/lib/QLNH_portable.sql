USE master
GO

IF DB_ID(N'QuanLyNhaHang') IS NULL
BEGIN
    CREATE DATABASE [QuanLyNhaHang];
END
GO

USE [QuanLyNhaHang]
GO

/****** Object:  Table [dbo].[HoaDon]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[maHD] [varchar](20) NOT NULL,
	[maNV] [varchar](20) NOT NULL,
	[maBan] [varchar](20) NOT NULL,
	[maKH] [varchar](20) NULL,
	[ngayGioLap] [datetime] NULL,
	[ngayGioThanhToan] [datetime] NULL,
	[trangThaiThanhToan] [nvarchar](50) NULL,
	[soLuongKhach] [int] NULL,
	[chietKhau] [float] NULL,
	[VAT] [float] NULL,
	[tongTien] [float] NULL,
	[ghiChu] [nvarchar](500) NULL,
	[tenKhachLe] [nvarchar](100) NULL,
	[sdtKhachLe] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[maHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_DoanhThuTheoNgay]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View doanh thu theo ngày
CREATE VIEW [dbo].[vw_DoanhThuTheoNgay] AS
SELECT 
    CAST(ngayGioThanhToan AS DATE) AS Ngay,
    COUNT(*) AS SoHoaDon,
    SUM(tongTien) AS DoanhThu
FROM HoaDon
WHERE trangThaiThanhToan = N'Đã thanh toán'
GROUP BY CAST(ngayGioThanhToan AS DATE);
GO
/****** Object:  Table [dbo].[MonAn]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonAn](
	[maMonAn] [varchar](20) NOT NULL,
	[maDM] [varchar](20) NOT NULL,
	[tenMonAn] [nvarchar](100) NOT NULL,
	[donVi] [nvarchar](20) NULL,
	[soLuongTon] [int] NULL,
	[giaBan] [float] NOT NULL,
	[moTa] [nvarchar](500) NULL,
	[ghiChu] [nvarchar](500) NULL,
	[anhMon] [nvarchar](200) NULL,
	[tinhTrang] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[maMonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietHoaDon]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHoaDon](
	[maHD] [varchar](20) NOT NULL,
	[maMonAn] [varchar](20) NOT NULL,
	[soLuong] [int] NOT NULL,
	[donGia] [float] NOT NULL,
	[thanhTien] [float] NOT NULL,
	[trangThaiPhucVu] [nvarchar](50) NULL,
	[ghiChu] [nvarchar](255) NULL,
	[ID_CTHD] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_CTHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_MonAnBanChay]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View món ăn bán chạy
CREATE VIEW [dbo].[vw_MonAnBanChay] AS
SELECT 
    m.maMonAn,
    m.tenMonAn,
    SUM(ct.soLuong) AS SoLuongBan,
    SUM(ct.thanhTien) AS DoanhThu
FROM ChiTietHoaDon ct
JOIN MonAn m ON ct.maMonAn = m.maMonAn
JOIN HoaDon h ON ct.maHD = h.maHD
WHERE h.trangThaiThanhToan = N'Đã thanh toán'
GROUP BY m.maMonAn, m.tenMonAn;
GO
/****** Object:  Table [dbo].[BanAn]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BanAn](
	[maBan] [varchar](20) NOT NULL,
	[maLB] [varchar](20) NOT NULL,
	[tenBan] [nvarchar](100) NULL,
	[viTri] [nvarchar](100) NULL,
	[sucChua] [int] NOT NULL,
	[trangThai] [nvarchar](50) NULL,
	[moTa] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[maBan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BangGia]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BangGia](
	[maBangGia] [varchar](20) NOT NULL,
	[tenBangGia] [nvarchar](100) NOT NULL,
	[ngayBatDau] [date] NOT NULL,
	[ngayKetThuc] [date] NULL,
	[moTa] [nvarchar](200) NULL,
	[trangThai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[maBangGia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietBangGia]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietBangGia](
	[maBangGia] [varchar](20) NOT NULL,
	[maMonAn] [varchar](20) NOT NULL,
	[giaBan] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[maBangGia] ASC,
	[maMonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietDonDatMon]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietDonDatMon](
	[maDon] [varchar](20) NOT NULL,
	[maMonAn] [varchar](20) NOT NULL,
	[soLuong] [int] NOT NULL,
	[donGia] [float] NOT NULL,
	[ghiChu] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[maDon] ASC,
	[maMonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DanhMucMonAn]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DanhMucMonAn](
	[maDM] [varchar](20) NOT NULL,
	[tenDM] [nvarchar](100) NOT NULL,
	[moTa] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[maDM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DonDatMon]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DonDatMon](
	[maDon] [varchar](20) NOT NULL,
	[maNV] [varchar](20) NOT NULL,
	[maBan] [varchar](20) NOT NULL,
	[thoiGianTao] [datetime] NULL,
	[trangThai] [nvarchar](50) NULL,
	[ghiChu] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[maDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoaDonKhuyenMai]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDonKhuyenMai](
	[maHD] [varchar](20) NOT NULL,
	[maKM] [varchar](20) NOT NULL,
	[giaTriGiam] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[maHD] ASC,
	[maKM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[maKH] [varchar](20) NOT NULL,
	[tenKH] [nvarchar](100) NOT NULL,
	[soDienThoai] [varchar](15) NULL,
	[email] [varchar](100) NULL,
	[ngayThamGia] [datetime] NULL,
	[diemTichLuy] [int] NULL,
	[trangThai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[maKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhuyenMai]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhuyenMai](
	[maKM] [varchar](20) NOT NULL,
	[tenKM] [nvarchar](100) NOT NULL,
	[moTaKM] [nvarchar](500) NULL,
	[loaiKM] [nvarchar](50) NOT NULL,
	[giaTriKM] [float] NOT NULL,
	[ngayBatDau] [datetime] NOT NULL,
	[ngayKetThuc] [datetime] NOT NULL,
	[dieuKienApDung] [nvarchar](500) NULL,
	[diemYeuCau] [int] NULL,
	[soLuongToiThieu] [int] NULL,
	[trangThai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[maKM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiBan]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiBan](
	[maLB] [varchar](20) NOT NULL,
	[tenLB] [nvarchar](100) NOT NULL,
	[soGhe] [int] NOT NULL,
	[moTa] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[maLB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MonAnKhuyenMai]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonAnKhuyenMai](
	[maKM] [varchar](20) NOT NULL,
	[maMonAn] [varchar](20) NOT NULL,
	[phanTramGiam] [float] NOT NULL,
	[soLuongToiThieu] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[maKM] ASC,
	[maMonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[maNV] [varchar](20) NOT NULL,
	[hoTenNV] [nvarchar](100) NOT NULL,
	[ngaySinh] [date] NULL,
	[gioiTinh] [nvarchar](10) NULL,
	[soDienThoai] [varchar](15) NULL,
	[diaChi] [nvarchar](200) NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](100) NOT NULL,
	[chucVu] [nvarchar](50) NOT NULL,
	[heSoLuong] [float] NULL,
	[caLam] [nvarchar](50) NULL,
	[khvuQuanLy] [nvarchar](100) NULL,
	[khvuPhucVu] [nvarchar](100) NULL,
	[khvuTiepTan] [nvarchar](100) NULL,
	[trangThai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[maNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuDatBan]    Script Date: 4/4/2026 4:32:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuDatBan](
	[maPhieu] [varchar](20) NOT NULL,
	[tenKhachHang] [nvarchar](100) NOT NULL,
	[soDienThoai] [varchar](15) NOT NULL,
	[thoiGianDen] [datetime] NOT NULL,
	[soLuongKhach] [int] NOT NULL,
	[ghiChu] [nvarchar](255) NULL,
	[maBan] [varchar](20) NULL,
	[trangThai] [nvarchar](50) NULL,
	[ngayTao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[maPhieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN01', N'LB001', N'Bàn 1', N'Tầng 1', 4, N'Trống', N'Gần cửa')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN02', N'LB001', N'Bàn 2', N'Tầng 1', 4, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN03', N'LB002', N'VIP 1', N'Tầng 2', 6, N'Trống', N'Phòng riêng')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN04', N'LB003', N'Gia đình 1', N'Tầng 1', 8, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN05', N'LB004', N'Đôi 1', N'Tầng 1', 2, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN06', N'LB005', N'Nhóm 1', N'Tầng 2', 10, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN07', N'LB006', N'Ngoài trời 1', N'Phòng VIP', 4, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN08', N'LB007', N'Trong nhà 1', N'Tầng 1', 4, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN09', N'LB008', N'Sinh nhật 1', N'Tầng 2', 12, N'Trống', N'')
INSERT [dbo].[BanAn] ([maBan], [maLB], [tenBan], [viTri], [sucChua], [trangThai], [moTa]) VALUES (N'BAN10', N'LB009', N'Hội họp 1', N'Tầng 2', 10, N'Trống', N'')
GO
INSERT [dbo].[BangGia] ([maBangGia], [tenBangGia], [ngayBatDau], [ngayKetThuc], [moTa], [trangThai]) VALUES (N'BG001', N'Bảng giá mặc định', CAST(N'2026-01-01' AS Date), NULL, N'Áp dụng toàn bộ menu', 1)
GO
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA001', 45000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA002', 55000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA003', 65000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA004', 70000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA005', 120000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA006', 15000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA007', 35000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA008', 30000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA009', 30000)
INSERT [dbo].[ChiTietBangGia] ([maBangGia], [maMonAn], [giaBan]) VALUES (N'BG001', N'MA010', 25000)
GO
INSERT [dbo].[ChiTietDonDatMon] ([maDon], [maMonAn], [soLuong], [donGia], [ghiChu]) VALUES (N'DDM1775236652622', N'MA001', 1, 45000, N'')
INSERT [dbo].[ChiTietDonDatMon] ([maDon], [maMonAn], [soLuong], [donGia], [ghiChu]) VALUES (N'DDM1775236652622', N'MA002', 1, 55000, N'')
INSERT [dbo].[ChiTietDonDatMon] ([maDon], [maMonAn], [soLuong], [donGia], [ghiChu]) VALUES (N'DDM1775236652622', N'MA003', 2, 65000, N'')
INSERT [dbo].[ChiTietDonDatMon] ([maDon], [maMonAn], [soLuong], [donGia], [ghiChu]) VALUES (N'DDM1775236652622', N'MA004', 1, 75000, N'')
GO
SET IDENTITY_INSERT [dbo].[ChiTietHoaDon] ON 

INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA001', 1, 45000, 45000, NULL, NULL, 1)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA002', 2, 55000, 110000, NULL, NULL, 2)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA004', 1, 70000, 70000, NULL, NULL, 3)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA005', 1, 120000, 120000, NULL, NULL, 4)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA006', 1, 15000, 15000, NULL, NULL, 5)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA008', 1, 30000, 30000, NULL, NULL, 6)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA009', 1, 30000, 30000, NULL, NULL, 7)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775118127382', N'MA010', 1, 25000, 25000, NULL, NULL, 8)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775121982901', N'MA003', 1, 65000, 65000, NULL, NULL, 9)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775121982901', N'MA004', 1, 70000, 70000, NULL, NULL, 10)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775121982901', N'MA007', 1, 35000, 35000, NULL, NULL, 11)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775121982901', N'MA008', 1, 30000, 30000, NULL, NULL, 12)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 13)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA003', 1, 65000, 65000, N'Chưa lên', NULL, 14)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA004', 1, 70000, 70000, N'Chưa lên', NULL, 15)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA005', 1, 120000, 120000, N'Chưa lên', NULL, 16)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA006', 1, 15000, 15000, N'Chưa lên', NULL, 17)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA007', 1, 35000, 35000, N'Chưa lên', NULL, 18)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA008', 1, 30000, 30000, N'Chưa lên', NULL, 19)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA009', 1, 30000, 30000, N'Chưa lên', NULL, 20)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775122405209', N'MA010', 1, 25000, 25000, N'Chưa lên', NULL, 21)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA001', 7, 45000, 270000, N'Đã lên', N'', 22)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA002', 1, 55000, 55000, N'Đã lên', NULL, 23)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA003', 1, 65000, 65000, N'Đã lên', NULL, 24)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA004', 1, 70000, 70000, N'Đã lên', NULL, 25)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA005', 3, 120000, 360000, N'Chưa lên', NULL, 26)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA006', 1, 15000, 15000, N'Đã lên', NULL, 27)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA007', 2, 35000, 35000, N'Chưa lên', N'', 28)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA008', 1, 30000, 30000, N'Chưa lên', NULL, 29)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA009', 1, 30000, 30000, N'Chưa lên', NULL, 30)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA010', 1, 25000, 25000, N'Chưa lên', NULL, 31)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA001', 1, 45000, 45000, N'Chưa lên', N'', 32)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775125320455', N'MA003', 1, 65000, 65000, N'Chưa lên', N'', 33)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775121331695', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 34)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775121331695', N'MA003', 10, 65000, 650000, N'Chưa lên', N'', 35)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149545855', N'MA001', 1, 45000, 45000, N'Chưa lên', NULL, 36)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149545855', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 37)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149545855', N'MA003', 1, 65000, 65000, N'Chưa lên', NULL, 38)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149545855', N'MA004', 1, 70000, 70000, N'Chưa lên', NULL, 39)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149551848', N'MA001', 1, 45000, 45000, N'Chưa lên', NULL, 40)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149551848', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 41)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149551848', N'MA003', 1, 65000, 65000, N'Chưa lên', NULL, 42)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149551848', N'MA004', 1, 70000, 70000, N'Chưa lên', NULL, 43)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149551848', N'MA008', 1, 30000, 30000, N'Chưa lên', NULL, 44)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149557487', N'MA001', 1, 45000, 45000, N'Chưa lên', NULL, 45)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149557487', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 46)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149557487', N'MA003', 1, 65000, 65000, N'Chưa lên', NULL, 47)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149557487', N'MA007', 1, 35000, 35000, N'Chưa lên', NULL, 48)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149563239', N'MA001', 1, 45000, 45000, N'Chưa lên', NULL, 49)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149563239', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 50)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775149563239', N'MA006', 3, 15000, 45000, N'Chưa lên', NULL, 51)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA001', 1, 45000, 45000, N'Đã lên', NULL, 52)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA002', 1, 55000, 55000, N'Đã lên', NULL, 53)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA003', 1, 65000, 65000, N'Đã lên', NULL, 54)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA004', 1, 70000, 70000, N'Đã lên', NULL, 55)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA008', 1, 30000, 30000, N'Đã lên', NULL, 56)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA007', 1, 35000, 35000, N'Đã lên', NULL, 57)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA006', 1, 15000, 15000, N'Đã lên', NULL, 58)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA005', 1, 120000, 120000, N'Đã lên', NULL, 59)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA010', 1, 25000, 25000, N'Đã lên', NULL, 60)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775150327663', N'MA009', 1, 30000, 30000, N'Đã lên', NULL, 61)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA002', 1, 55000, 55000, N'Đã lên', NULL, 62)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA003', 1, 65000, 65000, N'Đã lên', NULL, 63)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA004', 1, 70000, 70000, N'Đã lên', NULL, 64)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA008', 1, 30000, 30000, N'Hủy', NULL, 65)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA007', 1, 35000, 35000, N'Đã lên', NULL, 66)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185129552', N'MA004', 10, 70000, 700000, N'Đã lên', N'', 67)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA003', 3, 65000, 195000, N'Đã lên', N'', 68)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775185139193', N'MA006', 4, 15000, 60000, N'Hủy', N'', 69)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186446443', N'MA004', 3, 70000, 210000, N'Đã lên', N'', 70)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186446443', N'MA008', 1, 30000, 30000, N'Đã lên', N'', 71)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186449731', N'MA007', 4, 35000, 140000, N'Đã lên', N'', 72)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186449731', N'MA003', 6, 65000, 390000, N'Đã lên', N'', 73)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186453066', N'MA004', 6, 70000, 420000, N'Đã lên', N'', 74)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186623171', N'MA001', 1, 45000, 45000, N'Đã lên', NULL, 75)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186623171', N'MA002', 1, 55000, 55000, N'Đã lên', NULL, 76)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186623171', N'MA003', 1, 65000, 65000, N'Đã lên', NULL, 77)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775186623171', N'MA004', 1, 70000, 70000, N'Đã lên', NULL, 78)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187290992', N'MA005', 4, 120000, 480000, N'Đã lên', N'', 79)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187431937', N'MA003', 1, 65000, 65000, N'Chưa lên', NULL, 80)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187431937', N'MA002', 1, 55000, 55000, N'Chưa lên', NULL, 81)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187431937', N'MA004', 1, 70000, 70000, N'Chưa lên', NULL, 82)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187431937', N'MA008', 1, 30000, 30000, N'Chưa lên', NULL, 83)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187431937', N'MA007', 1, 35000, 35000, N'Chưa lên', NULL, 84)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187544868', N'MA001', 4, 45000, 180000, N'Đã lên', N'', 85)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775187683753', N'MA004', 3, 70000, 210000, N'Đã lên', N'', 86)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775196378324', N'MA004', 4, 70000, 280000, N'Đã lên', N'', 87)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775196561531', N'MA005', 7, 120000, 840000, N'Đã lên', N'', 88)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775196845059', N'MA003', 4, 65000, 260000, N'Đã lên', N'', 89)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775197854724', N'MA001', 1, 45000, 45000, N'Mang về', N'', 90)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775197963582', N'MA001', 1, 45000, 45000, N'Đã lên', N'', 91)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775198591132', N'MA003', 5, 65000, 325000, N'Đã lên', N'', 92)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775198882579', N'MA001', 4, 45000, 180000, N'Đã lên', N'', 93)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775198893826', N'MA005', 5, 120000, 600000, N'Đã lên', N'', 94)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775199535986', N'MA001', 1, 45000, 45000, N'Đã lên', N'', 96)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775200783579', N'MA004', 4, 75000, 300000, N'Đã lên', N'', 97)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775202377549', N'MA004', 4, 75000, 300000, N'Đã lên', N'', 98)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775202380768', N'MA001', 1, 45000, 45000, N'Đã lên', N'', 99)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775202883214', N'MA004', 5, 75000, 375000, N'Đã lên', N'', 100)
GO
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775203501340', N'MA001', 4, 45000, 180000, N'Đã lên', N'', 101)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775233294529', N'MA001', 4, 45000, 180000, N'Đã lên', N'', 102)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775231830027', N'MA001', 1, 45000, 45000, N'Đã lên', N'', 103)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775236667860', N'MA001', 1, 45000, 45000, N'Đã lên', N'', 104)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775236667860', N'MA002', 1, 55000, 55000, N'Đã lên', N'', 105)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775236667860', N'MA003', 2, 65000, 130000, N'Đã lên', N'', 106)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775236667860', N'MA004', 1, 75000, 75000, N'Đã lên', N'', 107)
INSERT [dbo].[ChiTietHoaDon] ([maHD], [maMonAn], [soLuong], [donGia], [thanhTien], [trangThaiPhucVu], [ghiChu], [ID_CTHD]) VALUES (N'HD1775236667860', N'MA008', 1, 30000, 30000, N'Đã lên', N'', 108)
SET IDENTITY_INSERT [dbo].[ChiTietHoaDon] OFF
GO
INSERT [dbo].[DanhMucMonAn] ([maDM], [tenDM], [moTa]) VALUES (N'DM001', N'Món khai vị', N'')
INSERT [dbo].[DanhMucMonAn] ([maDM], [tenDM], [moTa]) VALUES (N'DM002', N'Món chính', N'')
INSERT [dbo].[DanhMucMonAn] ([maDM], [tenDM], [moTa]) VALUES (N'DM003', N'Đồ uống', N'')
INSERT [dbo].[DanhMucMonAn] ([maDM], [tenDM], [moTa]) VALUES (N'DM004', N'Tráng miệng', N'')
GO
INSERT [dbo].[DonDatMon] ([maDon], [maNV], [maBan], [thoiGianTao], [trangThai], [ghiChu]) VALUES (N'DDM1775236652622', N'NV001', N'BAN03', CAST(N'2026-04-04T00:17:32.637' AS DateTime), N'Chờ khách', N'làm trước')
GO
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775105351327', N'NV001', N'BAN03', NULL, CAST(N'2026-04-02T11:49:11.333' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775105353495', N'NV001', N'BAN03', NULL, CAST(N'2026-04-02T11:49:13.497' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775105355706', N'NV001', N'BAN03', NULL, CAST(N'2026-04-02T11:49:15.707' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775117878841', N'NV001', N'BAN03', NULL, CAST(N'2026-04-02T15:17:59.053' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775118115960', N'NV001', N'BAN03', NULL, CAST(N'2026-04-02T15:21:56.173' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775118119995', N'NV001', N'BAN03', NULL, CAST(N'2026-04-02T15:21:59.997' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775118127382', N'NV001', N'BAN01', NULL, CAST(N'2026-04-02T15:22:07.387' AS DateTime), CAST(N'2026-04-02T16:53:02.927' AS DateTime), N'Đã thanh toán', 1, 0, 10, 445000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775120146305', N'NV001', N'BAN06', NULL, CAST(N'2026-04-02T15:55:46.330' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775121331695', N'NV001', N'BAN02', NULL, CAST(N'2026-04-02T16:15:31.707' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 55000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775121982901', N'NV001', N'BAN08', NULL, CAST(N'2026-04-02T16:26:22.950' AS DateTime), CAST(N'2026-04-02T16:26:43.143' AS DateTime), N'Đã thanh toán', 1, 0, 10, 200000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775122405209', N'NV001', N'BAN01', NULL, CAST(N'2026-04-02T16:33:25.367' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 445000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775124065668', N'NV001', N'BAN01', NULL, CAST(N'2026-04-02T17:01:05.700' AS DateTime), CAST(N'2026-04-02T17:19:32.570' AS DateTime), N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775125320455', N'NV001', N'BAN01', NULL, CAST(N'2026-04-02T17:22:00.467' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 955000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775147221302', N'NV001', N'BAN02', NULL, CAST(N'2026-04-02T23:27:01.310' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775147238455', N'NV001', N'BAN04', NULL, CAST(N'2026-04-02T23:27:18.453' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775149545855', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T00:05:45.860' AS DateTime), CAST(N'2026-04-03T00:07:44.553' AS DateTime), N'Đã thanh toán', 1, 0, 10, 235000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775149551848', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T00:05:51.850' AS DateTime), CAST(N'2026-04-03T00:07:48.843' AS DateTime), N'Đã thanh toán', 1, 0, 10, 265000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775149557487', N'NV001', N'BAN04', NULL, CAST(N'2026-04-03T00:05:57.487' AS DateTime), CAST(N'2026-04-03T00:07:53.107' AS DateTime), N'Đã thanh toán', 1, 0, 10, 200000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775149563239', N'NV001', N'BAN03', NULL, CAST(N'2026-04-03T00:06:03.237' AS DateTime), CAST(N'2026-04-03T00:07:57.500' AS DateTime), N'Đã thanh toán', 1, 0, 10, 145000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775150327663', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T00:18:47.667' AS DateTime), CAST(N'2026-04-03T09:48:26.500' AS DateTime), N'Đã thanh toán', 1, 0, 10, 490000, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775183313492', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T09:28:33.507' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775183338792', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T09:28:58.793' AS DateTime), NULL, N'Đã thanh toán', 1, 0, 10, 0, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775185129552', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T09:58:49.560' AS DateTime), CAST(N'2026-04-03T10:13:48.960' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775185139193', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T09:58:59.190' AS DateTime), CAST(N'2026-04-03T10:13:53.563' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775186446443', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T10:20:46.447' AS DateTime), CAST(N'2026-04-03T10:22:13.190' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775186449731', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T10:20:49.733' AS DateTime), CAST(N'2026-04-03T10:22:16.317' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775186453066', N'NV001', N'BAN08', NULL, CAST(N'2026-04-03T10:20:53.070' AS DateTime), CAST(N'2026-04-03T10:22:19.070' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775186623171', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T10:23:43.173' AS DateTime), CAST(N'2026-04-03T12:55:45.147' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775187290992', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T10:34:50.993' AS DateTime), CAST(N'2026-04-03T12:55:47.910' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775187431937', N'NV001', N'BAN04', NULL, CAST(N'2026-04-03T10:37:11.940' AS DateTime), CAST(N'2026-04-03T12:55:50.593' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775187544868', N'NV001', N'BAN05', NULL, CAST(N'2026-04-03T10:39:04.870' AS DateTime), CAST(N'2026-04-03T12:56:57.513' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775187683753', N'NV001', N'BAN08', NULL, CAST(N'2026-04-03T10:41:23.757' AS DateTime), CAST(N'2026-04-03T12:56:54.653' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775196378324', N'NV005', N'BAN01', NULL, CAST(N'2026-04-03T13:06:18.330' AS DateTime), CAST(N'2026-04-03T13:10:24.610' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Nam', N'0867504178')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775196561531', N'NV005', N'BAN02', NULL, CAST(N'2026-04-03T13:09:21.537' AS DateTime), CAST(N'2026-04-03T13:10:29.120' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Hưng', N'0935183265')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775196845059', N'NV005', N'BAN01', NULL, CAST(N'2026-04-03T13:14:05.063' AS DateTime), CAST(N'2026-04-03T13:27:03.423' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Nam', N'0938101689')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775197854724', N'NV005', N'BAN01', NULL, CAST(N'2026-04-03T13:30:54.730' AS DateTime), CAST(N'2026-04-03T13:31:53.310' AS DateTime), N'Đã thanh toán', 1, 0, 10, NULL, NULL, N'Nam', N'0938101689')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775197963582', N'NV001', N'BAN03', NULL, CAST(N'2026-04-03T13:32:43.583' AS DateTime), CAST(N'2026-04-03T13:35:59.140' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Nam', N'0949717373')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775198591132', N'NV005', N'BAN01', NULL, CAST(N'2026-04-03T13:43:11.137' AS DateTime), CAST(N'2026-04-03T13:46:23.690' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Ngà', N'0949717373')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775198882579', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T13:48:02.583' AS DateTime), CAST(N'2026-04-03T13:57:36.017' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Nam', N'0867504178')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775198893826', N'NV005', N'BAN02', NULL, CAST(N'2026-04-03T13:48:13.827' AS DateTime), CAST(N'2026-04-03T13:57:41.597' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Hưng', N'0935183265')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775199535986', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T13:58:55.990' AS DateTime), CAST(N'2026-04-03T14:34:58.147' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Nam', N'0867504178')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775200783579', N'NV005', N'BAN02', NULL, CAST(N'2026-04-03T14:19:43.580' AS DateTime), CAST(N'2026-04-03T14:44:51.440' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Hưng', N'0935183265')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775202377549', N'NV005', N'BAN02', NULL, CAST(N'2026-04-03T14:46:17.550' AS DateTime), CAST(N'2026-04-03T14:47:31.247' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Quang Nam', N'0867504178')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775202380768', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T14:46:20.767' AS DateTime), CAST(N'2026-04-03T14:53:12.503' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Nam', N'0949717373')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775202883214', N'NV005', N'BAN01', NULL, CAST(N'2026-04-03T14:54:43.220' AS DateTime), CAST(N'2026-04-03T22:10:00.373' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Nam', N'0938101689')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775203501340', N'NV001', N'BAN02', NULL, CAST(N'2026-04-03T15:05:01.350' AS DateTime), CAST(N'2026-04-03T22:10:13.557' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Nam', N'0949717372')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775231830027', N'NV001', N'BAN03', NULL, CAST(N'2026-04-03T22:57:10.033' AS DateTime), CAST(N'2026-04-04T00:15:07.697' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Nam', N'0867504178')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775233294529', N'NV001', N'BAN01', NULL, CAST(N'2026-04-03T23:21:34.607' AS DateTime), CAST(N'2026-04-04T00:15:28.937' AS DateTime), N'Đã thanh toán', 4, 0, 10, NULL, NULL, N'Quang Nam', N'0913641286')
INSERT [dbo].[HoaDon] ([maHD], [maNV], [maBan], [maKH], [ngayGioLap], [ngayGioThanhToan], [trangThaiThanhToan], [soLuongKhach], [chietKhau], [VAT], [tongTien], [ghiChu], [tenKhachLe], [sdtKhachLe]) VALUES (N'HD1775236667860', N'NV001', N'BAN03', NULL, CAST(N'2026-04-04T00:17:47.867' AS DateTime), CAST(N'2026-04-04T00:23:37.797' AS DateTime), N'Đã thanh toán', 2, 0, 10, NULL, NULL, N'Nam', N'0867504178')
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH001', N'Nguyễn Minh', N'0910000001', N'kh1@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 100, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH002', N'Trần Anh', N'0910000002', N'kh2@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 50, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH003', N'Lê Bình', N'0910000003', N'kh3@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 70, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH004', N'Phạm Duy', N'0910000004', N'kh4@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 30, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH005', N'Hoàng Nam', N'0910000005', N'kh5@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 0, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH006', N'Nguyễn Hải', N'0910000006', N'kh6@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 120, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH007', N'Trần Phúc', N'0910000007', N'kh7@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 90, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH008', N'Lê Tuấn', N'0910000008', N'kh8@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 20, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH009', N'Phạm Long', N'0910000009', N'kh9@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 60, 1)
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [soDienThoai], [email], [ngayThamGia], [diemTichLuy], [trangThai]) VALUES (N'KH010', N'Hoàng Khánh', N'0910000010', N'kh10@gmail.com', CAST(N'2026-04-02T11:16:39.567' AS DateTime), 10, 1)
GO
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM001', N'Giảm 10%', N'', N'Phần trăm', 10, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM002', N'Giảm 20%', N'', N'Phần trăm', 20, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM003', N'Tặng món', N'', N'Sản phẩm', 1, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 1, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM004', N'Khách VIP', N'', N'Tiền mặt', 50000, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 100, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM005', N'Cuối tuần', N'', N'Phần trăm', 15, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM006', N'Sinh nhật', N'', N'Phần trăm', 25, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM007', N'Nhóm đông', N'', N'Phần trăm', 12, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 4, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM008', N'Lễ', N'', N'Phần trăm', 18, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM009', N'Hè', N'', N'Phần trăm', 10, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
INSERT [dbo].[KhuyenMai] ([maKM], [tenKM], [moTaKM], [loaiKM], [giaTriKM], [ngayBatDau], [ngayKetThuc], [dieuKienApDung], [diemYeuCau], [soLuongToiThieu], [trangThai]) VALUES (N'KM010', N'Đặc biệt', N'', N'Tiền mặt', 100000, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2026-12-31T00:00:00.000' AS DateTime), N'', 0, 0, 1)
GO
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB001', N'Bàn thường', 4, N'Bàn tiêu chuẩn')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB002', N'Bàn VIP', 6, N'Phòng riêng')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB003', N'Bàn gia đình', 8, N'Cho gia đình')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB004', N'Bàn đôi', 2, N'Cho cặp đôi')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB005', N'Bàn nhóm', 10, N'Nhóm đông')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB006', N'Bàn ngoài trời', 4, N'Khu sân vườn')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB007', N'Bàn trong nhà', 4, N'Máy lạnh')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB008', N'Bàn sinh nhật', 12, N'Trang trí sinh nhật')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB009', N'Bàn hội họp', 10, N'Tiếp khách')
INSERT [dbo].[LoaiBan] ([maLB], [tenLB], [soGhe], [moTa]) VALUES (N'LB010', N'Bàn sự kiện', 15, N'Tổ chức sự kiện')
GO
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA001', N'DM001', N'Gỏi cuốn', N'Phần', 68, 45000, N'', N'', N'goicuon.jpeg', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA002', N'DM001', N'Chả giò', N'Phần', 86, 55000, N'', N'', N'chagio.jpg', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA003', N'DM002', N'Cơm chiên Dương Châu', N'Đĩa', 59, 65000, N'', N'', N'comchienduongchau.jpg', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA004', N'DM002', N'Phở bò', N'Tô', 50, 75000, N'', N'', N'phobo.jpg', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA005', N'DM002', N'Bò lúc lắc', N'Đĩa', 60, 120000, N'', N'', N'', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA006', N'DM003', N'Nước ngọt', N'Chai', 189, 15000, N'', N'', N'', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA007', N'DM003', N'Trà đào', N'Ly', 139, 35000, N'', N'', N'', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA008', N'DM003', N'Cà phê sữa', N'Ly', 110, 30000, N'', N'', N'', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA009', N'DM004', N'Kem vani', N'Ly', 96, 30000, N'', N'', N'', 1)
INSERT [dbo].[MonAn] ([maMonAn], [maDM], [tenMonAn], [donVi], [soLuongTon], [giaBan], [moTa], [ghiChu], [anhMon], [tinhTrang]) VALUES (N'MA010', N'DM004', N'Bánh flan', N'Phần', 86, 25000, N'', N'', N'', 1)
GO
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV001', N'Nguyễn Văn An', CAST(N'1990-01-10' AS Date), N'Nam', N'0900000001', N'HCM', N'quanly1', N'123456', N'Quản lý', 2.5, N'Sáng', N'Tầng 1', NULL, NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV002', N'Trần Thị Bình', CAST(N'1992-03-15' AS Date), N'Nữ', N'0900000002', N'HCM', N'quanly2', N'123456', N'Quản lý', 2.5, N'Tối', N'Tầng 2', NULL, NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV003', N'Lê Văn Cường', CAST(N'1995-07-20' AS Date), N'Nam', N'0900000003', N'HCM', N'thungan1', N'123456', N'Thu ngân', 1.8, N'Sáng', NULL, NULL, NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV004', N'Phạm Thị Dung', CAST(N'1996-09-12' AS Date), N'Nữ', N'0900000004', N'HCM', N'thungan2', N'123456', N'Thu ngân', 1.8, N'Tối', NULL, NULL, NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV005', N'Hoàng Minh Đức', CAST(N'1998-02-11' AS Date), N'Nam', N'0900000005', N'HCM', N'letan1', N'123456', N'Lễ Tân', 1.6, N'Sáng', NULL, NULL, N'Quầy lễ tân', 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV006', N'Nguyễn Thị Hạnh', CAST(N'1999-04-18' AS Date), N'Nữ', N'0900000006', N'HCM', N'letan2', N'123456', N'Lễ Tân', 1.6, N'Tối', NULL, NULL, N'Quầy lễ tân', 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV007', N'Võ Văn Hùng', CAST(N'2000-05-10' AS Date), N'Nam', N'0900000007', N'HCM', N'phucvu1', N'123456', N'Phục vụ', 1.4, N'Sáng', NULL, N'Tầng 1', NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV008', N'Trần Thị Lan', CAST(N'2001-06-21' AS Date), N'Nữ', N'0900000008', N'HCM', N'phucvu2', N'123456', N'Phục vụ', 1.4, N'Tối', NULL, N'Tầng 2', NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV009', N'Phan Văn Minh', CAST(N'2000-08-09' AS Date), N'Nam', N'0900000009', N'HCM', N'phucvu3', N'123456', N'Phục vụ', 1.4, N'Sáng', NULL, N'Tầng 1', NULL, 1)
INSERT [dbo].[NhanVien] ([maNV], [hoTenNV], [ngaySinh], [gioiTinh], [soDienThoai], [diaChi], [username], [password], [chucVu], [heSoLuong], [caLam], [khvuQuanLy], [khvuPhucVu], [khvuTiepTan], [trangThai]) VALUES (N'NV010', N'Lê Thị Ngọc', CAST(N'2001-11-30' AS Date), N'Nữ', N'0900000010', N'HCM', N'phucvu4', N'123456', N'Phục vụ', 1.4, N'Tối', NULL, N'Tầng 2', NULL, 1)
GO
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775120115164', N'Nam', N'0867504178', CAST(N'2026-04-02T19:30:00.000' AS DateTime), 4, N'', N'BAN04', N'Đã đến', CAST(N'2026-04-02T15:55:15.193' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775186434774', N'Nam', N'0949717373', CAST(N'2026-04-03T12:30:00.000' AS DateTime), 8, N'Lên món trước', N'BAN08', N'Đã đến', CAST(N'2026-04-03T10:20:34.780' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775186674053', N'Nga', N'0938101689', CAST(N'2026-04-03T12:00:00.000' AS DateTime), 2, N'1234', N'BAN02', N'Đã đến', CAST(N'2026-04-03T10:24:34.057' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775197957813', N'Nam', N'0949717373', CAST(N'2026-04-04T14:00:00.000' AS DateTime), 2, N'', N'BAN03', N'Đã đến', CAST(N'2026-04-03T13:32:37.820' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775198877987', N'Nam', N'0867504178', CAST(N'2026-04-03T14:00:00.000' AS DateTime), 4, N'', N'BAN01', N'Đã đến', CAST(N'2026-04-03T13:47:57.990' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775199531145', N'Nam', N'0867504178', CAST(N'2026-04-03T14:10:00.000' AS DateTime), 2, N'', N'BAN01', N'Đã đến', CAST(N'2026-04-03T13:58:51.150' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775202360494', N'Nam', N'0949717373', CAST(N'2026-04-03T15:00:00.000' AS DateTime), 2, N'', N'BAN01', N'Đã đến', CAST(N'2026-04-03T14:46:00.497' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775203498659', N'Nam', N'0949717372', CAST(N'2620-04-03T15:10:00.000' AS DateTime), 2, N'', N'BAN02', N'Đã đến', CAST(N'2026-04-03T15:04:58.670' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775231826452', N'Nam', N'0867504178', CAST(N'2026-04-03T23:00:00.000' AS DateTime), 2, N'', N'BAN03', N'Đã đến', CAST(N'2026-04-03T22:57:06.460' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775233287862', N'Quang Nam', N'0913641286', CAST(N'2026-04-03T23:30:00.000' AS DateTime), 4, N'', N'BAN01', N'Đã đến', CAST(N'2026-04-03T23:21:27.867' AS DateTime))
INSERT [dbo].[PhieuDatBan] ([maPhieu], [tenKhachHang], [soDienThoai], [thoiGianDen], [soLuongKhach], [ghiChu], [maBan], [trangThai], [ngayTao]) VALUES (N'PDB1775236652620', N'Nam', N'0867504178', CAST(N'2026-04-04T12:30:00.000' AS DateTime), 2, N'làm trước', N'BAN03', N'Đã đến', CAST(N'2026-04-04T00:17:32.630' AS DateTime))
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__NhanVien__06ACB9A29847C95F]    Script Date: 4/4/2026 4:32:35 PM ******/
ALTER TABLE [dbo].[NhanVien] ADD UNIQUE NONCLUSTERED 
(
	[soDienThoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__NhanVien__F3DBC5722F159A60]    Script Date: 4/4/2026 4:32:35 PM ******/
ALTER TABLE [dbo].[NhanVien] ADD UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BanAn] ADD  DEFAULT (N'Trống') FOR [trangThai]
GO
ALTER TABLE [dbo].[BangGia] ADD  DEFAULT ((1)) FOR [trangThai]
GO
ALTER TABLE [dbo].[ChiTietHoaDon] ADD  DEFAULT (N'Chưa lên') FOR [trangThaiPhucVu]
GO
ALTER TABLE [dbo].[DonDatMon] ADD  DEFAULT (getdate()) FOR [thoiGianTao]
GO
ALTER TABLE [dbo].[DonDatMon] ADD  DEFAULT (N'Chưa phục vụ') FOR [trangThai]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT (getdate()) FOR [ngayGioLap]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT (N'Chưa thanh toán') FOR [trangThaiThanhToan]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT ((1)) FOR [soLuongKhach]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT ((0)) FOR [chietKhau]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT ((10)) FOR [VAT]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT ((0)) FOR [tongTien]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT (getdate()) FOR [ngayThamGia]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT ((0)) FOR [diemTichLuy]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT ((1)) FOR [trangThai]
GO
ALTER TABLE [dbo].[KhuyenMai] ADD  DEFAULT ((0)) FOR [diemYeuCau]
GO
ALTER TABLE [dbo].[KhuyenMai] ADD  DEFAULT ((0)) FOR [soLuongToiThieu]
GO
ALTER TABLE [dbo].[KhuyenMai] ADD  DEFAULT ((1)) FOR [trangThai]
GO
ALTER TABLE [dbo].[MonAn] ADD  DEFAULT ((0)) FOR [soLuongTon]
GO
ALTER TABLE [dbo].[MonAn] ADD  DEFAULT ((1)) FOR [tinhTrang]
GO
ALTER TABLE [dbo].[MonAnKhuyenMai] ADD  DEFAULT ((1)) FOR [soLuongToiThieu]
GO
ALTER TABLE [dbo].[NhanVien] ADD  DEFAULT ((1.0)) FOR [heSoLuong]
GO
ALTER TABLE [dbo].[NhanVien] ADD  DEFAULT ((1)) FOR [trangThai]
GO
ALTER TABLE [dbo].[PhieuDatBan] ADD  DEFAULT (N'Chờ khách') FOR [trangThai]
GO
ALTER TABLE [dbo].[PhieuDatBan] ADD  DEFAULT (getdate()) FOR [ngayTao]
GO
ALTER TABLE [dbo].[BanAn]  WITH CHECK ADD FOREIGN KEY([maLB])
REFERENCES [dbo].[LoaiBan] ([maLB])
GO
ALTER TABLE [dbo].[ChiTietBangGia]  WITH CHECK ADD FOREIGN KEY([maBangGia])
REFERENCES [dbo].[BangGia] ([maBangGia])
GO
ALTER TABLE [dbo].[ChiTietBangGia]  WITH CHECK ADD FOREIGN KEY([maMonAn])
REFERENCES [dbo].[MonAn] ([maMonAn])
GO
ALTER TABLE [dbo].[ChiTietDonDatMon]  WITH CHECK ADD FOREIGN KEY([maDon])
REFERENCES [dbo].[DonDatMon] ([maDon])
GO
ALTER TABLE [dbo].[ChiTietDonDatMon]  WITH CHECK ADD FOREIGN KEY([maMonAn])
REFERENCES [dbo].[MonAn] ([maMonAn])
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD FOREIGN KEY([maMonAn])
REFERENCES [dbo].[MonAn] ([maMonAn])
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD FOREIGN KEY([maHD])
REFERENCES [dbo].[HoaDon] ([maHD])
GO
ALTER TABLE [dbo].[DonDatMon]  WITH CHECK ADD FOREIGN KEY([maBan])
REFERENCES [dbo].[BanAn] ([maBan])
GO
ALTER TABLE [dbo].[DonDatMon]  WITH CHECK ADD FOREIGN KEY([maNV])
REFERENCES [dbo].[NhanVien] ([maNV])
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD FOREIGN KEY([maBan])
REFERENCES [dbo].[BanAn] ([maBan])
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD FOREIGN KEY([maKH])
REFERENCES [dbo].[KhachHang] ([maKH])
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD FOREIGN KEY([maNV])
REFERENCES [dbo].[NhanVien] ([maNV])
GO
ALTER TABLE [dbo].[HoaDonKhuyenMai]  WITH CHECK ADD FOREIGN KEY([maHD])
REFERENCES [dbo].[HoaDon] ([maHD])
GO
ALTER TABLE [dbo].[HoaDonKhuyenMai]  WITH CHECK ADD FOREIGN KEY([maKM])
REFERENCES [dbo].[KhuyenMai] ([maKM])
GO
ALTER TABLE [dbo].[MonAn]  WITH CHECK ADD FOREIGN KEY([maDM])
REFERENCES [dbo].[DanhMucMonAn] ([maDM])
GO
ALTER TABLE [dbo].[MonAnKhuyenMai]  WITH CHECK ADD FOREIGN KEY([maMonAn])
REFERENCES [dbo].[MonAn] ([maMonAn])
GO
ALTER TABLE [dbo].[MonAnKhuyenMai]  WITH CHECK ADD FOREIGN KEY([maKM])
REFERENCES [dbo].[KhuyenMai] ([maKM])
GO
ALTER TABLE [dbo].[PhieuDatBan]  WITH CHECK ADD FOREIGN KEY([maBan])
REFERENCES [dbo].[BanAn] ([maBan])
GO
/****** Object:  StoredProcedure [dbo].[sp_DangNhap]    Script Date: 4/4/2026 4:32:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP đăng nhập
CREATE PROC [dbo].[sp_DangNhap]
    @username VARCHAR(50),
    @password VARCHAR(100)
AS
BEGIN
    SELECT maNV, hoTenNV, chucVu, trangThai
    FROM NhanVien
    WHERE username = @username AND password = @password AND trangThai = 1
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoHoaDon]    Script Date: 4/4/2026 4:32:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP tạo hóa đơn
CREATE PROC [dbo].[sp_TaoHoaDon]
    @maHD VARCHAR(20),
    @maNV VARCHAR(20),
    @maBan VARCHAR(20),
    @maKH VARCHAR(20) = NULL,
    @soLuongKhach INT = 1,
    @ghiChu NVARCHAR(500) = NULL
AS
BEGIN
    INSERT INTO HoaDon (maHD, maNV, maBan, maKH, soLuongKhach, ghiChu)
    VALUES (@maHD, @maNV, @maBan, @maKH, @soLuongKhach, @ghiChu)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ThanhToanHoaDon]    Script Date: 4/4/2026 4:32:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP thanh toán hóa đơn
CREATE PROC [dbo].[sp_ThanhToanHoaDon]
    @maHD VARCHAR(20),
    @chietKhau FLOAT = 0,
    @maKM VARCHAR(20) = NULL
AS
BEGIN
    DECLARE @tongTien FLOAT
    SELECT @tongTien = tongTien FROM HoaDon WHERE maHD = @maHD
    
    DECLARE @giaTriGiam FLOAT = 0
    
    IF @maKM IS NOT NULL
    BEGIN
        SELECT @giaTriGiam = giaTriKM FROM KhuyenMai WHERE maKM = @maKM
        
        -- Thêm vào bảng HoaDonKhuyenMai
        INSERT INTO HoaDonKhuyenMai (maHD, maKM, giaTriGiam)
        VALUES (@maHD, @maKM, @giaTriGiam)
    END
    
    UPDATE HoaDon
    SET 
        ngayGioThanhToan = GETDATE(),
        trangThaiThanhToan = N'Đã thanh toán',
        chietKhau = @chietKhau,
        tongTien = @tongTien - @chietKhau - @giaTriGiam
    WHERE maHD = @maHD
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemChiTietHoaDon]    Script Date: 4/4/2026 4:32:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP thêm chi tiết hóa đơn
CREATE PROC [dbo].[sp_ThemChiTietHoaDon]
    @maHD VARCHAR(20),
    @maMonAn VARCHAR(20),
    @soLuong INT
AS
BEGIN
    DECLARE @donGia FLOAT
    SELECT @donGia = giaBan FROM MonAn WHERE maMonAn = @maMonAn
    
    DECLARE @thanhTien FLOAT = @soLuong * @donGia
    
    INSERT INTO ChiTietHoaDon (maHD, maMonAn, soLuong, donGia, thanhTien)
    VALUES (@maHD, @maMonAn, @soLuong, @donGia, @thanhTien)
    
    -- Cập nhật tổng tiền hóa đơn
    UPDATE HoaDon 
    SET tongTien = (SELECT SUM(thanhTien) FROM ChiTietHoaDon WHERE maHD = @maHD)
    WHERE maHD = @maHD
END
GO
USE [master]
GO
ALTER DATABASE [QuanLyNhaHang] SET  READ_WRITE 
GO
