# CNPM_24CT2 — Hệ thống Quản lý & Đặt sân Pickleball (PicklePro)

- **Sinh viên thực hiện:** Trần Quốc Huy
- **Lớp:** 24CT2
- **MSSV:** 2451220013
- **Môn học:** Công nghệ Phần mềm

---

## Cấu trúc dự án chính (`PicklePro/`)

Toàn bộ mã nguồn Django, giao diện và script Cơ sở dữ liệu SQL nằm trong thư mục [`PicklePro/`](./PicklePro):

- `accounts/` — Đăng ký, đăng nhập, quản lý hồ sơ thành viên & phân quyền
- `courts/` — Trang chủ Dashboard, tìm kiếm/lọc sân, chi tiết sân & Bảng thời khóa biểu 16 khung giờ
- `bookings/` — Đặt sân trực tuyến, thuật toán chống trùng lịch, vé điện tử VietQR & Bảng điều hành Quản trị viên
- `templates/` — Giao diện Tailwind CSS responsive
- `config/` — Cấu hình Django project (`settings.py`, `urls.py`)
- `picklepro_sql_server.sql`, `picklepro_database.sql`, `cac_cau_lenh_truy_van_picklepro.sql` — Script khởi tạo CSDL & truy vấn SQL
- `HUONG_DAN_SU_DUNG.md` — Hướng dẫn cài đặt, tài khoản mẫu và vận hành hệ thống

## Khởi chạy nhanh

Xem chi tiết tại [`PicklePro/HUONG_DAN_SU_DUNG.md`](./PicklePro/HUONG_DAN_SU_DUNG.md).

```powershell
cd PicklePro
python manage.py runserver 127.0.0.1:8000
```
