-- ===========================================================================
-- BỘ 6 DẠNG TRUY VẤN SQL ĐỀ TÀI PICKLEPRO (MICROSOFT SQL SERVER)
-- Sinh viên: Trần Quốc Huy | MSSV: 2451220013 | Lớp: 24CT2
-- Giảng viên hướng dẫn: ThS. Phạm Thị Dung
-- ===========================================================================

USE [picklepro];
GO

-- ===========================================================================
-- DẠNG 1: TRUY VẤN SELECT - LẤY DANH SÁCH DỮ LIỆU TỪ BẢNG
-- ===========================================================================

-- Ví dụ 1.1: Lấy danh sách toàn bộ 6 cụm sân Pickleball đang quản lý
SELECT id, code, name, court_type, price_per_hour, status, location
FROM courts_court;
GO

-- Ví dụ 1.2: Lấy danh sách toàn bộ tài khoản người dùng
SELECT id, username, first_name, last_name, email, is_staff, is_active, date_joined
FROM auth_user;
GO

-- Ví dụ 1.3: Lấy danh sách các đơn đặt sân gần nhất
SELECT id, booking_code, customer_name, customer_phone, booking_date, start_time, end_time, total_price, status, payment_status
FROM bookings_booking;
GO


-- ===========================================================================
-- DẠNG 2: TRUY VẤN CÓ ĐIỀU KIỆN (WHERE) - TÌM KIẾM DỮ LIỆU THEO YÊU CẦU
-- ===========================================================================

-- Ví dụ 2.1: Lọc các cụm sân trong nhà (indoor) có giá thuê <= 150.000đ/giờ và đang hoạt động
SELECT code, name, court_type, price_per_hour, location
FROM courts_court
WHERE status = 'available' 
  AND court_type = 'indoor' 
  AND price_per_hour <= 150000;
GO

-- Ví dụ 2.2: Tìm kiếm các đơn đặt sân của sinh viên Trần Quốc Huy
SELECT booking_code, customer_name, customer_phone, booking_date, start_time, total_price, payment_status
FROM bookings_booking
WHERE customer_name LIKE N'%Huy%' 
   OR customer_email = 'tranquochuy1322006@gmail.com';
GO

-- Ví dụ 2.3: Thuật toán kiểm tra chống trùng giờ đặt sân (Double Booking Conflict)
SELECT booking_code, customer_name, start_time, end_time, status
FROM bookings_booking
WHERE court_id = 2 
  AND booking_date = '2026-10-09'
  AND start_time < '09:00:00' 
  AND end_time > '07:00:00'
  AND status != 'cancelled';
GO


-- ===========================================================================
-- DẠNG 3: TRUY VẤN JOIN - KẾT HỢP DỮ LIỆU TỪ NHIỀU BẢNG
-- ===========================================================================

-- Ví dụ 3.1: Kết hợp bảng bookings_booking và courts_court (INNER JOIN hiển thị tên sân)
SELECT b.booking_code, b.customer_name, c.name AS TenSan, c.court_type,
       b.booking_date, b.start_time, b.end_time, b.total_price, b.payment_status
FROM bookings_booking b
INNER JOIN courts_court c ON b.court_id = c.id;
GO

-- Ví dụ 3.2: Kết hợp 3 bảng bookings_booking, courts_court và auth_user
SELECT u.username, b.booking_code, b.customer_name, c.name AS TenSan,
       b.booking_date, b.start_time, b.total_price, b.payment_status
FROM bookings_booking b
JOIN courts_court c ON b.court_id = c.id
LEFT JOIN auth_user u ON b.user_id = u.id
WHERE u.username = 'Huy132' OR b.customer_name LIKE N'%Huy%';
GO

-- Ví dụ 3.3: Kết hợp bảng auth_user và accounts_userprofile (Quan hệ 1 - 1)
SELECT u.id, u.username, u.email, p.phone_number, p.address, u.date_joined
FROM auth_user u
INNER JOIN accounts_userprofile p ON u.id = p.user_id;
GO


-- ===========================================================================
-- DẠNG 4: TRUY VẤN GROUP BY - THỐNG KÊ, TỔNG HỢP DỮ LIỆU
-- ===========================================================================

-- Ví dụ 4.1: Thống kê số lượng sân và giá thuê theo từng loại sân
SELECT court_type AS LoaiSan,
       COUNT(*) AS SoLuongSan,
       AVG(price_per_hour) AS GiaTrungBinh,
       MIN(price_per_hour) AS GiaThapNhat,
       MAX(price_per_hour) AS GiaCaoNhat
FROM courts_court
GROUP BY court_type;
GO

-- Ví dụ 4.2: Thống kê tổng doanh thu và số đơn theo trạng thái thanh toán
SELECT payment_status AS TrangThaiThanhToan,
       COUNT(*) AS SoLuongDon,
       SUM(total_price) AS TongDoanhThu
FROM bookings_booking
GROUP BY payment_status;
GO

-- Ví dụ 4.3: Thống kê doanh thu và lượt đặt theo từng cụm sân (JOIN + GROUP BY)
SELECT c.name AS TenSan,
       COUNT(b.id) AS TongLuotDat,
       ISNULL(SUM(b.total_price), 0) AS TongDoanhThu
FROM courts_court c
LEFT JOIN bookings_booking b ON c.id = b.court_id
GROUP BY c.id, c.name
ORDER BY TongDoanhThu DESC;
GO


-- ===========================================================================
-- DẠNG 5: TRUY VẤN UPDATE - CẬP NHẬT DỮ LIỆU
-- ===========================================================================

-- Ví dụ 5.1: Cập nhật trạng thái thanh toán VietQR tự động
UPDATE bookings_booking
SET payment_status = 'paid',
    status = 'confirmed',
    updated_at = GETDATE()
WHERE booking_code = 'PKB-25DDFE28';
GO

-- Ví dụ 5.2: Mở lại Sân PicklePro 05 sau khi bảo trì xong
UPDATE courts_court
SET status = 'available',
    updated_at = GETDATE()
WHERE code = 'PK-05';
GO


-- ===========================================================================
-- DẠNG 6: TRUY VẤN DELETE - XÓA DỮ LIỆU
-- ===========================================================================

-- Ví dụ 6.1: Xóa cứng các đơn hủy chưa thanh toán (Hard Delete)
DELETE FROM bookings_booking
WHERE status = 'cancelled' AND payment_status = 'unpaid';
GO

-- Ví dụ 6.2: Cơ chế Xóa mềm giải phóng khung giờ đặt sân (Soft Delete - Khuyên dùng)
UPDATE bookings_booking
SET status = 'cancelled',
    notes = notes + N' [Khách hàng yêu cầu hủy đơn]'
WHERE id = 12;
GO
