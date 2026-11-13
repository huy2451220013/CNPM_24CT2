-- ===========================================================================
-- CƠ SỞ DỮ LIỆU PICKLEPRO DÀNH RIÊNG CHO MICROSOFT SQL SERVER (SSMS)
-- Đề tài: Website Đặt sân Pickleball PicklePro
-- Sinh viên: Trần Quốc Huy - Lớp: 24CT2 - MSSV: 2451220013
-- Giảng viên hướng dẫn: ThS. Phạm Thị Dung
-- ===========================================================================

USE master;
GO

-- 1. Tạo Database nếu chưa có
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'picklepro')
BEGIN
    CREATE DATABASE [picklepro];
END
GO

USE [picklepro];
GO

IF OBJECT_ID(N'dbo.bookings_booking', N'U') IS NOT NULL DROP TABLE [dbo].[bookings_booking];
IF OBJECT_ID(N'dbo.accounts_userprofile', N'U') IS NOT NULL DROP TABLE [dbo].[accounts_userprofile];
IF OBJECT_ID(N'dbo.courts_court', N'U') IS NOT NULL DROP TABLE [dbo].[courts_court];
IF OBJECT_ID(N'dbo.auth_user', N'U') IS NOT NULL DROP TABLE [dbo].[auth_user];
GO

-- ---------------------------------------------------------------------------
-- 1. Bảng [auth_user]: Lưu tài khoản đăng nhập (Admin, Khách hàng)
-- ---------------------------------------------------------------------------
CREATE TABLE [dbo].[auth_user] (
    [id] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [password] nvarchar(128) NOT NULL,
    [last_login] datetime2(6) NULL,
    [is_superuser] bit NOT NULL DEFAULT 0,
    [username] nvarchar(150) NOT NULL UNIQUE,
    [first_name] nvarchar(150) NOT NULL DEFAULT '',
    [last_name] nvarchar(150) NOT NULL DEFAULT '',
    [email] nvarchar(254) NOT NULL DEFAULT '',
    [is_staff] bit NOT NULL DEFAULT 0,
    [is_active] bit NOT NULL DEFAULT 1,
    [date_joined] datetime2(6) NOT NULL DEFAULT GETDATE()
);
GO

-- ---------------------------------------------------------------------------
-- 2. Bảng [accounts_userprofile]: Hồ sơ mở rộng người dùng (SĐT, Địa chỉ)
-- ---------------------------------------------------------------------------
CREATE TABLE [dbo].[accounts_userprofile] (
    [id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [phone_number] nvarchar(20) NOT NULL DEFAULT '',
    [address] nvarchar(255) NOT NULL DEFAULT '',
    [user_id] int NOT NULL UNIQUE,
    CONSTRAINT [FK_userprofile_auth_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[auth_user]([id]) ON DELETE CASCADE
);
GO

-- ---------------------------------------------------------------------------
-- 3. Bảng [courts_court]: Danh mục 6 cụm sân Pickleball
-- ---------------------------------------------------------------------------
CREATE TABLE [dbo].[courts_court] (
    [id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [name] nvarchar(100) NOT NULL,
    [code] nvarchar(20) NOT NULL UNIQUE,
    [location] nvarchar(255) NOT NULL,
    [price_per_hour] decimal(10,0) NOT NULL,
    [status] nvarchar(20) NOT NULL DEFAULT 'available',
    [description] nvarchar(max) NOT NULL,
    [created_at] datetime2(6) NOT NULL DEFAULT GETDATE(),
    [updated_at] datetime2(6) NOT NULL DEFAULT GETDATE(),
    [court_type] nvarchar(20) NOT NULL DEFAULT 'indoor',
    [features] nvarchar(255) NOT NULL DEFAULT '',
    [image_url] nvarchar(500) NOT NULL DEFAULT ''
);
GO

-- ---------------------------------------------------------------------------
-- 4. Bảng [bookings_booking]: Lịch đặt sân & Thanh toán VietQR
-- ---------------------------------------------------------------------------
CREATE TABLE [dbo].[bookings_booking] (
    [id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [booking_code] nvarchar(30) NOT NULL UNIQUE,
    [customer_name] nvarchar(100) NOT NULL,
    [customer_phone] nvarchar(20) NOT NULL,
    [customer_email] nvarchar(254) NOT NULL DEFAULT '',
    [booking_date] date NOT NULL,
    [start_time] time(7) NOT NULL,
    [end_time] time(7) NOT NULL,
    [total_price] decimal(12,0) NOT NULL,
    [status] nvarchar(20) NOT NULL DEFAULT 'pending',
    [payment_status] nvarchar(20) NOT NULL DEFAULT 'unpaid',
    [payment_method] nvarchar(20) NOT NULL DEFAULT 'banking',
    [notes] nvarchar(max) NOT NULL DEFAULT '',
    [created_at] datetime2(6) NOT NULL DEFAULT GETDATE(),
    [updated_at] datetime2(6) NOT NULL DEFAULT GETDATE(),
    [court_id] bigint NOT NULL,
    [user_id] int NULL,
    CONSTRAINT [FK_bookings_court] FOREIGN KEY ([court_id]) REFERENCES [dbo].[courts_court]([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_bookings_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[auth_user]([id]) ON DELETE SET NULL
);
GO

-- ===========================================================================
-- CHÈN DỮ LIỆU MẪU CHUẨN (SEED DATA)
-- ===========================================================================

SET IDENTITY_INSERT [dbo].[auth_user] ON;
INSERT INTO [dbo].[auth_user] ([id], [password], [last_login], [is_superuser], [username], [first_name], [last_name], [email], [is_staff], [is_active], [date_joined]) VALUES (1, N'pbkdf2_sha256$600000$yAfJaUf2o4TEIB1UKi04GL$Wi2OqR/M3qE7y0pOrpon5qTZEBGDLQ+PfjQAyajdZsc=', '2026-11-06 00:54:30.150090', 1, N'admin', N'', N'', N'admin@gmail.com', 1, 1, '2026-10-09 01:16:44.875385');
INSERT INTO [dbo].[auth_user] ([id], [password], [last_login], [is_superuser], [username], [first_name], [last_name], [email], [is_staff], [is_active], [date_joined]) VALUES (2, N'pbkdf2_sha256$600000$2G3KXO7U9swr2UXyDKmHRG$UmR0CGW45Bw+8sZmLcvvSqTJKJU+Rd0z6nldCwDu23U=', NULL, 0, N'khachhang', N'Nguyễn', N'Văn An', N'an.nguyen@gmail.com', 0, 1, '2026-10-09 01:37:38.167624');
INSERT INTO [dbo].[auth_user] ([id], [password], [last_login], [is_superuser], [username], [first_name], [last_name], [email], [is_staff], [is_active], [date_joined]) VALUES (3, N'pbkdf2_sha256$600000$odtvIb2WkyBOQP2dEwpuPF$I8QXV+bD8PehzUWSXJdHIw5q2m4QzUf843OFPawmCRs=', '2026-10-09 02:24:47', 0, N'Huy132', N'Trần', N'Huy', N'tranquochuy1322006@gmail.com', 0, 1, '2026-10-09 02:07:18');
INSERT INTO [dbo].[auth_user] ([id], [password], [last_login], [is_superuser], [username], [first_name], [last_name], [email], [is_staff], [is_active], [date_joined]) VALUES (4, N'pbkdf2_sha256$600000$zyCw9Ow1Rzx8RR3fTOntxr$BNedA+jVAoTn9lJu+GRyKy2loUk1KRSDt1mYxN4We54=', NULL, 0, N'Hin132', N'', N'', N'', 0, 1, '2026-10-09 02:32:53.567084');
SET IDENTITY_INSERT [dbo].[auth_user] OFF;
GO

SET IDENTITY_INSERT [dbo].[accounts_userprofile] ON;
INSERT INTO [dbo].[accounts_userprofile] ([id], [phone_number], [address], [user_id]) VALUES (1, N'0901234567', N'Quận 1, TP. Hồ Chí Minh', 1);
INSERT INTO [dbo].[accounts_userprofile] ([id], [phone_number], [address], [user_id]) VALUES (2, N'0987654321', N'Quận 7, TP. Hồ Chí Minh', 2);
INSERT INTO [dbo].[accounts_userprofile] ([id], [phone_number], [address], [user_id]) VALUES (3, N'0948262522', N'', 3);
SET IDENTITY_INSERT [dbo].[accounts_userprofile] OFF;
GO

SET IDENTITY_INSERT [dbo].[courts_court] ON;
INSERT INTO [dbo].[courts_court] ([id], [name], [code], [location], [price_per_hour], [status], [description], [created_at], [updated_at], [court_type], [features], [image_url]) VALUES (2, N'Sân PicklePro 01 (Tiêu Chuẩn)', N'PK-01', N'Khu A - Tầng 1 (Sân trung tâm)', 120000, N'available', N'Sân Pickleball trong nhà tiêu chuẩn thi đấu quốc tế, mặt sân sơn acrylic 5 lớp giảm chấn thương, trang bị hệ thống chiếu sáng không chói mắt.', '2026-10-09 01:37:38.421593', '2026-10-09 01:37:38.421593', N'indoor', N'Mặt sân USAPA, Đèn LED 500 Lux, Điều hòa trung tâm, Ghế nghỉ cao cấp, Nước uống miễn phí', N'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=800&auto=format&fit=crop&q=80');
INSERT INTO [dbo].[courts_court] ([id], [name], [code], [location], [price_per_hour], [status], [description], [created_at], [updated_at], [court_type], [features], [image_url]) VALUES (3, N'Sân PicklePro 02 (VIP Máy Lạnh)', N'PK-02', N'Khu VIP - Tầng 2 (View toàn cảnh)', 180000, N'available', N'Sân VIP đẳng cấp sang trọng, dành riêng cho người chơi yêu cầu sự riêng tư tuyệt đối, dịch vụ phục vụ đồ uống và khăn lạnh tận nơi.', '2026-10-09 01:37:38.423366', '2026-10-09 01:37:38.423366', N'vip', N'Không gian riêng tư, Điều hòa 22°C, Thảm đệm giảm chấn, Tủ locker bảo mật, Khăn lạnh & Nước khoáng', N'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80');
INSERT INTO [dbo].[courts_court] ([id], [name], [code], [location], [price_per_hour], [status], [description], [created_at], [updated_at], [court_type], [features], [image_url]) VALUES (4, N'Sân PicklePro 03 (Ngoài Trời Xanh)', N'PK-03', N'Khu B - Sân trời mở (Khuôn viên công viên)', 90000, N'available', N'Sân ngoài trời thoáng đãng, lý tưởng cho những trận đấu buổi sáng sớm hoặc chiều tối đầy năng lượng cùng bạn bè và câu lạc bộ.', '2026-10-09 01:37:38.428851', '2026-10-09 01:37:38.428851', N'outdoor', N'Không khí tự nhiên thoáng đãng, Đèn cao áp ban đêm, Lưới thi đấu USAPA, Bãi đỗ xe ô tô rộng', N'https://images.unsplash.com/photo-1622163642998-1ea32b0bbc67?w=800&auto=format&fit=crop&q=80');
INSERT INTO [dbo].[courts_court] ([id], [name], [code], [location], [price_per_hour], [status], [description], [created_at], [updated_at], [court_type], [features], [image_url]) VALUES (5, N'Sân PicklePro 04 (Khán Đài Thi Đấu)', N'PK-04', N'Khu A - Sân Khán đài trung tâm', 150000, N'available', N'Sân chuyên dụng cho các trận chung kết, giải đấu phong trào và giao lưu mở rộng với khán đài cho cổ động viên theo dõi.', '2026-10-09 01:37:38.431862', '2026-10-09 01:37:38.431862', N'indoor', N'Khán đài 100 chỗ ngồi, Camera quay chậm VAR, Bảng điểm điện tử LED, Hệ thống âm thanh sôi động', N'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&auto=format&fit=crop&q=80');
INSERT INTO [dbo].[courts_court] ([id], [name], [code], [location], [price_per_hour], [status], [description], [created_at], [updated_at], [court_type], [features], [image_url]) VALUES (6, N'Sân PicklePro 05 (Sân Đôi Chuyên Nghiệp)', N'PK-05', N'Khu B - Sân đôi 2', 100000, N'maintenance', N'Sân đang trong lịch bảo dưỡng định kỳ thay lưới và kẻ lại vạch thi đấu. Dự kiến mở lại vào đầu tuần tới.', '2026-10-09 01:37:38.433520', '2026-10-09 01:37:38.433520', N'outdoor', N'Mặt sân chống trượt, Lưới chống gió, Hệ thống thoát nước nhanh', N'https://images.unsplash.com/photo-1587280501635-68a0e82cd5ff?w=800&auto=format&fit=crop&q=80');
INSERT INTO [dbo].[courts_court] ([id], [name], [code], [location], [price_per_hour], [status], [description], [created_at], [updated_at], [court_type], [features], [image_url]) VALUES (7, N'Sân PicklePro 06 (Lounge Club VIP)', N'PK-06', N'Khu VIP - Tầng 2 Cạnh Coffee Lounge', 200000, N'available', N'Trải nghiệm thể thao phong cách sống thời thượng kết hợp giữa thể thao rèn luyện sức khỏe và thư giãn giao lưu tại khu Lounge.', '2026-10-09 01:37:38.435532', '2026-10-09 01:37:38.435532', N'vip', N'Liền kề quầy Lounge phục vụ nước ép sinh tố, Ghế massage thư giãn, HLV tư vấn kỹ thuật', N'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=800&auto=format&fit=crop&q=80');
SET IDENTITY_INSERT [dbo].[courts_court] OFF;
GO

SET IDENTITY_INSERT [dbo].[bookings_booking] ON;
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (1, N'PKB-753C82F9', N'Nguyễn Văn An', N'0987654321', N'an.nguyen@gmail.com', '2026-10-09', '7:00:00', '9:00:00', 240000, N'confirmed', N'paid', N'banking', N'Cần chuẩn bị thêm 2 vợt cho người mới chơi', '2026-10-09 01:37:38.446817', '2026-10-09 01:37:38.446817', 2, 2);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (2, N'PKB-316C9F52', N'Trần Thị Mai', N'0912345678', N'mai.tran@gmail.com', '2026-10-09', '17:00:00', '19:00:00', 360000, N'confirmed', N'paid', N'banking', N'Đặt sân VIP công ty giao lưu', '2026-10-09 01:37:38.449825', '2026-10-09 01:37:38.449825', 3, NULL);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (3, N'PKB-08609F00', N'Lê Hoàng Quân', N'0933221100', N'quan.le@gmail.com', '2026-10-09', '19:00:00', '21:00:00', 180000, N'confirmed', N'unpaid', N'cash', N'Thanh toán tiền mặt khi tới nhận sân', '2026-10-09 01:37:38.451788', '2026-10-09 02:12:22.143944', 4, NULL);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (4, N'PKB-24B41796', N'Nguyễn Văn An', N'0987654321', N'an.nguyen@gmail.com', '2026-10-10', '8:00:00', '10:00:00', 300000, N'confirmed', N'paid', N'banking', N'Trận đấu giao lưu nội bộ câu lạc bộ', '2026-10-09 01:37:38.453066', '2026-10-09 01:37:38.453066', 5, 2);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (6, N'PKB-6461A8AA', N'Trần Huy', N'0948262522', N'tranquochuy1322006@gmail.com', '2026-10-09', '12:00:00', '22:00:00', 1200000, N'confirmed', N'paid', N'banking', N'', '2026-10-09 02:07:50.640877', '2026-10-09 02:12:36.078543', 2, 3);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (7, N'PKB-B7FA0473', N'admin', N'0901234567', N'admin@gmail.com', '2026-10-11', '15:00:00', '21:00:00', 1080000, N'pending', N'unpaid', N'banking', N'a huy', '2026-10-09 02:19:25.134125', '2026-10-09 02:19:25.134125', 3, 1);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (8, N'PKB-DBD0E662', N'huy', N'0901234568', N'huy@gmail.com', '2026-10-16', '7:00:00', '14:00:00', 840000, N'completed', N'unpaid', N'cash', N'', '2026-10-16 00:43:14.079291', '2026-10-16 00:43:47.906170', 2, 1);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (9, N'PKB-313614E6', N'admin', N'0901234567', N'admin@gmail.com', '2026-10-16', '8:00:00', '12:00:00', 720000, N'pending', N'unpaid', N'banking', N'', '2026-10-16 00:55:36.322959', '2026-10-16 00:55:36.322959', 3, 1);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (10, N'PKB-051A8579', N'huy', N'0948262522', N'huy@gmail.com', '2026-10-16', '18:00:00', '21:00:00', 360000, N'pending', N'unpaid', N'banking', N'', '2026-10-16 01:11:21.838918', '2026-10-16 01:11:21.838918', 2, NULL);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (11, N'PKB-25DDFE28', N'Trần Quốc Huy', N'123123', N'tranquochuy1322006@gmail.com', '2026-10-23', '19:00:00', '22:00:00', 360000, N'pending', N'unpaid', N'banking', N'', '2026-10-16 15:26:04.871945', '2026-10-16 15:26:04.871945', 2, NULL);
INSERT INTO [dbo].[bookings_booking] ([id], [booking_code], [customer_name], [customer_phone], [customer_email], [booking_date], [start_time], [end_time], [total_price], [status], [payment_status], [payment_method], [notes], [created_at], [updated_at], [court_id], [user_id]) VALUES (12, N'PKB-354F75C5', N'Trần Quốc Huy', N'123123', N'tranquochuy1322006@gmail.com', '2026-11-04', '6:00:00', '7:00:00', 90000, N'pending', N'unpaid', N'banking', N'', '2026-11-04 07:30:06.385665', '2026-11-04 07:30:06.385665', 4, NULL);
SET IDENTITY_INSERT [dbo].[bookings_booking] OFF;
GO

-- ===========================================================================
-- TRUY VẤN KIỂM TRA NHANH KẾT QUẢ
-- ===========================================================================
SELECT 'courts_court' AS [Table_Name], COUNT(*) AS [Total_Rows] FROM [dbo].[courts_court]
UNION ALL
SELECT 'bookings_booking', COUNT(*) FROM [dbo].[bookings_booking]
UNION ALL
SELECT 'auth_user', COUNT(*) FROM [dbo].[auth_user]
UNION ALL
SELECT 'accounts_userprofile', COUNT(*) FROM [dbo].[accounts_userprofile];
GO
