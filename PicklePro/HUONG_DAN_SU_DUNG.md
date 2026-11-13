# HƯỚNG DẪN SỬ DỤNG VÀ VẬN HÀNH DỰ ÁN PICKLEPRO

Hệ thống website quản lý và đặt sân **Pickleball PicklePro** được xây dựng trên nền tảng **Django 4.2 / 5.x**, hỗ trợ kết nối cơ sở dữ liệu **MySQL** (có fallback SQLite) và giao diện người dùng hiện đại, responsive.

---

## 1. CÁC LỖI ĐÃ ĐƯỢC KHẮC PHỤC
1. **Lỗi `ALLOWED_HOSTS = []`**: Khi mở web bằng `localhost`, IP mạng LAN hoặc môi trường dev thì bị chặn lỗi `DisallowedHost` (Status 400). Đã chuyển sang `ALLOWED_HOSTS = ['*']`.
2. **Lỗi hiển thị dữ liệu tĩnh (Hardcoded)**: Trước đây giao diện `dashboard.html` chỉ để 3 ô sân tĩnh không lấy từ Database và nút bấm vô tác dụng. Đã chuyển toàn bộ sang hệ thống nạp dữ liệu động từ database (`courts`, `bookings`).
3. **Lỗi thiếu hoàn toàn ứng dụng Đặt Sân (`bookings`) và Tài khoản (`accounts`)**:
   - Ứng dụng `bookings` trước đây là file trống, không có Model `Booking`, không có view tạo lịch, không có hệ thống kiểm tra trùng giờ.
   - Đã xây dựng hoàn thiện toàn bộ luồng đặt sân, kiểm tra trùng lịch (Collision Prevention), tính tiền tự động theo số giờ, xuất vé điện tử, tạo mã VietQR tự động.
4. **Lỗi `UnicodeEncodeError` tiếng Việt trên Windows**: Khi chạy lệnh hoặc in log tiếng Việt trên console Windows CP1252, Django bị crash mã ký tự `\u1edf`. Đã xử lý reconfigure UTF-8 trong `manage.py` và tối ưu bộ ký tự MySQL `utf8mb4`.

---

## 2. CÁC TÍNH NĂNG MỚI ĐƯỢC BỔ SUNG

### 🎯 Phía Khách Hàng (Customer):
- **Trang chủ & Tổng quan Dashboard**:
  - Banner Hero ấn tượng, thống kê trực quan số sân hoạt động, số sân bảo trì, tổng lượt đặt trong ngày.
  - Tìm kiếm sân theo từ khóa, lọc theo loại sân (Trong nhà, Ngoài trời, VIP Lounge), lọc theo trạng thái, sắp xếp theo giá thuê.
  - Thẻ thông tin từng sân hiển thị ảnh thật, loại sân, tiện ích (đèn LED 500 Lux, máy lạnh, mượn vợt...), giá thuê theo giờ.
- **Xem Lịch Sân Trống Theo Giờ (Court Timetable & Slots)**:
  - Chọn ngày bất kỳ để xem lịch 16 khung giờ trong ngày (06:00 đến 22:00).
  - Trực quan màu sắc: Màu xanh (Còn trống - bấm đặt ngay), Màu đỏ (Đã có người đặt), Màu cam (Đang bảo trì).
  - Bảng thời khóa biểu tổng hợp (`/schedule/`) xem toàn bộ cụm sân cùng lúc.
- **Đặt Sân Trực Tuyến & Chống Trùng Lịch (Double Booking Prevention)**:
  - Chọn sân, ngày và khung giờ (tự động tính thời lượng & tổng tiền theo giờ với Javascript realtime).
  - Hệ thống kiểm tra chặt chẽ, không cho phép đặt đè lên khung giờ đã có người đặt trước.
  - Hỗ trợ cả khách đăng nhập và khách vãng lai đặt nhanh (nhập Tên + Số điện thoại).
- **Vé Điện Tử & Thanh Toán VietQR Tự Động**:
  - Mỗi đơn đặt sân được cấp mã vé duy nhất: `PKB-XXXXXXXX`.
  - Tự động tạo ảnh mã QR VietQR (chuẩn ngân hàng MB Bank/Vietcombank) có sẵn số tiền và nội dung chuyển khoản để quét app ngân hàng trong 3 giây.
  - Nút in vé đặt sân / lưu vé, nút hủy vé trước giờ chơi.
- **Tra Cứu Lịch Đặt Nhanh Theo Số Điện Thoại (`/my-bookings/`)**:
  - Khách không cần nhớ tài khoản, chỉ cần nhập số điện thoại là xem được tất cả vé đặt sân của mình.
- **Hệ Thống Đăng Nhập / Đăng Ký / Hồ Sơ Thành Viên**:
  - Đăng ký thành viên, đăng nhập, đổi thông tin cá nhân và xem lịch sử các trận đấu đã đặt.

### 🛡️ Phía Quản Trị Viên & Nhân Viên Sân (Staff / Admin):
- **Bảng Điều Hành Đặt Sân (`/manage-bookings/`)**:
  - Thống kê doanh thu thực tế từ các đơn đã thanh toán.
  - Bộ lọc theo ngày chơi, trạng thái đơn, cụm sân.
  - Thao tác 1 chạm:
    - ✔️ **Duyệt đơn** (`pending` -> `confirmed`)
    - 💵 **Đánh dấu đã thanh toán** (`unpaid` -> `paid`)
    - 🏁 **Hoàn thành trận đấu**
    - ❌ **Hủy đơn**
  - Đổi trạng thái sân nhanh chóng giữa **Đang hoạt động** ⮀ **Đang bảo trì**.
- **Hệ thống Django Admin chuẩn hóa (`/admin/`)**:
  - Quản lý đầy đủ danh mục Sân (`Court`), Lịch đặt (`Booking`), Khách hàng (`UserProfile`).

---

## 3. THÔNG TIN TÀI KHOẢN MẪU & KHỞI CHẠY DỰ ÁN

### 🔑 Tài khoản mẫu:
1. **Quản trị viên (Admin / Staff)**:
   - Tên đăng nhập: `admin`
   - Mật khẩu: `admin123`
2. **Khách hàng mẫu (Customer)**:
   - Tên đăng nhập: `khachhang`
   - Mật khẩu: `123456`

---

### 🚀 Lệnh Khởi Chạy Server:
Mở terminal PowerShell trong thư mục `PicklePro`:

```powershell
.\venv\Scripts\python.exe manage.py runserver 127.0.0.1:8000
```
Truy cập trình duyệt:
- Trang chủ: [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
- Đặt sân ngay: [http://127.0.0.1:8000/book/](http://127.0.0.1:8000/book/)
- Thời khóa biểu: [http://127.0.0.1:8000/schedule/](http://127.0.0.1:8000/schedule/)
- Tra cứu vé: [http://127.0.0.1:8000/my-bookings/](http://127.0.0.1:8000/my-bookings/)
- Quản lý điều hành (Admin): [http://127.0.0.1:8000/manage-bookings/](http://127.0.0.1:8000/manage-bookings/)
- Django Admin: [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/)

---

### 🔄 Nạp lại dữ liệu mẫu (Nếu cần):
```powershell
.\venv\Scripts\python.exe manage.py seed_data
```
Lệnh này sẽ tự động khởi tạo 6 sân pickleball chuẩn thi đấu và một số lịch đặt sân mẫu có sẵn để trải nghiệm ngay.
