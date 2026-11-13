from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.utils import timezone
from courts.models import Court
from bookings.models import Booking
from accounts.models import UserProfile
import datetime


class Command(BaseCommand):
    help = "Seed initial data for PicklePro courts and sample bookings"

    def handle(self, *args, **options):
        self.stdout.write("Khởi tạo dữ liệu mẫu cho PicklePro...")

        # 1. Tạo hoặc cập nhật tài khoản admin và khách hàng mẫu
        admin_user, _ = User.objects.get_or_create(
            username="admin",
            defaults={"email": "admin@picklepro.vn", "is_staff": True, "is_superuser": True}
        )
        admin_user.set_password("admin123")
        admin_user.save()
        UserProfile.objects.get_or_create(
            user=admin_user,
            defaults={"phone_number": "0901234567", "address": "Quận 1, TP. Hồ Chí Minh"}
        )

        customer_user, _ = User.objects.get_or_create(
            username="khachhang",
            defaults={"first_name": "Nguyễn", "last_name": "Văn An", "email": "an.nguyen@gmail.com"}
        )
        customer_user.set_password("123456")
        customer_user.save()
        UserProfile.objects.get_or_create(
            user=customer_user,
            defaults={"phone_number": "0987654321", "address": "Quận 7, TP. Hồ Chí Minh"}
        )

        # 2. Tạo danh sách các sân Pickleball đẹp mắt
        courts_data = [
            {
                "code": "PK-01",
                "name": "Sân PicklePro 01 (Tiêu Chuẩn)",
                "court_type": "indoor",
                "location": "Khu A - Tầng 1 (Sân trung tâm)",
                "price_per_hour": 120000,
                "status": "available",
                "features": "Mặt sân USAPA, Đèn LED 500 Lux, Điều hòa trung tâm, Ghế nghỉ cao cấp, Nước uống miễn phí",
                "image_url": "https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=800&auto=format&fit=crop&q=80",
                "description": "Sân Pickleball trong nhà tiêu chuẩn thi đấu quốc tế, mặt sân sơn acrylic 5 lớp giảm chấn thương, trang bị hệ thống chiếu sáng không chói mắt."
            },
            {
                "code": "PK-02",
                "name": "Sân PicklePro 02 (VIP Máy Lạnh)",
                "court_type": "vip",
                "location": "Khu VIP - Tầng 2 (View toàn cảnh)",
                "price_per_hour": 180000,
                "status": "available",
                "features": "Không gian riêng tư, Điều hòa 22°C, Thảm đệm giảm chấn, Tủ locker bảo mật, Khăn lạnh & Nước khoáng",
                "image_url": "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80",
                "description": "Sân VIP đẳng cấp sang trọng, dành riêng cho người chơi yêu cầu sự riêng tư tuyệt đối, dịch vụ phục vụ đồ uống và khăn lạnh tận nơi."
            },
            {
                "code": "PK-03",
                "name": "Sân PicklePro 03 (Ngoài Trời Xanh)",
                "court_type": "outdoor",
                "location": "Khu B - Sân trời mở (Khuôn viên công viên)",
                "price_per_hour": 90000,
                "status": "available",
                "features": "Không khí tự nhiên thoáng đãng, Đèn cao áp ban đêm, Lưới thi đấu USAPA, Bãi đỗ xe ô tô rộng",
                "image_url": "https://images.unsplash.com/photo-1622163642998-1ea32b0bbc67?w=800&auto=format&fit=crop&q=80",
                "description": "Sân ngoài trời thoáng đãng, lý tưởng cho những trận đấu buổi sáng sớm hoặc chiều tối đầy năng lượng cùng bạn bè và câu lạc bộ."
            },
            {
                "code": "PK-04",
                "name": "Sân PicklePro 04 (Khán Đài Thi Đấu)",
                "court_type": "indoor",
                "location": "Khu A - Sân Khán đài trung tâm",
                "price_per_hour": 150000,
                "status": "available",
                "features": "Khán đài 100 chỗ ngồi, Camera quay chậm VAR, Bảng điểm điện tử LED, Hệ thống âm thanh sôi động",
                "image_url": "https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=800&auto=format&fit=crop&q=80",
                "description": "Sân chuyên dụng cho các trận chung kết, giải đấu phong trào và giao lưu mở rộng với khán đài cho cổ động viên theo dõi."
            },
            {
                "code": "PK-05",
                "name": "Sân PicklePro 05 (Sân Đôi Chuyên Nghiệp)",
                "court_type": "outdoor",
                "location": "Khu B - Sân đôi 2",
                "price_per_hour": 100000,
                "status": "maintenance",
                "features": "Mặt sân chống trượt, Lưới chống gió, Hệ thống thoát nước nhanh",
                "image_url": "https://images.unsplash.com/photo-1587280501635-68a0e82cd5ff?w=800&auto=format&fit=crop&q=80",
                "description": "Sân đang trong lịch bảo dưỡng định kỳ thay lưới và kẻ lại vạch thi đấu. Dự kiến mở lại vào đầu tuần tới."
            },
            {
                "code": "PK-06",
                "name": "Sân PicklePro 06 (Lounge Club VIP)",
                "court_type": "vip",
                "location": "Khu VIP - Tầng 2 Cạnh Coffee Lounge",
                "price_per_hour": 200000,
                "status": "available",
                "features": "Liền kề quầy Lounge phục vụ nước ép sinh tố, Ghế massage thư giãn, HLV tư vấn kỹ thuật",
                "image_url": "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=800&auto=format&fit=crop&q=80",
                "description": "Trải nghiệm thể thao phong cách sống thời thượng kết hợp giữa thể thao rèn luyện sức khỏe và thư giãn giao lưu tại khu Lounge."
            },
        ]

        # Xóa các sân cũ để đồng bộ chuẩn xác
        Court.objects.all().delete()

        created_courts = []
        for c in courts_data:
            court = Court.objects.create(
                code=c["code"],
                name=c["name"],
                court_type=c["court_type"],
                location=c["location"],
                price_per_hour=c["price_per_hour"],
                status=c["status"],
                features=c["features"],
                image_url=c["image_url"],
                description=c["description"]
            )
            created_courts.append(court)
            self.stdout.write(f" - Đã tạo sân: {court.name}")

        # 3. Tạo một số lịch đặt sân mẫu
        today = timezone.localdate()
        tomorrow = today + datetime.timedelta(days=1)

        sample_bookings = [
            {
                "court": created_courts[0],
                "user": customer_user,
                "customer_name": "Nguyễn Văn An",
                "customer_phone": "0987654321",
                "customer_email": "an.nguyen@gmail.com",
                "booking_date": today,
                "start_time": datetime.time(7, 0),
                "end_time": datetime.time(9, 0),
                "total_price": 240000,
                "status": "confirmed",
                "payment_status": "paid",
                "payment_method": "banking",
                "notes": "Cần chuẩn bị thêm 2 vợt cho người mới chơi"
            },
            {
                "court": created_courts[1],
                "user": None,
                "customer_name": "Trần Thị Mai",
                "customer_phone": "0912345678",
                "customer_email": "mai.tran@gmail.com",
                "booking_date": today,
                "start_time": datetime.time(17, 0),
                "end_time": datetime.time(19, 0),
                "total_price": 360000,
                "status": "confirmed",
                "payment_status": "paid",
                "payment_method": "banking",
                "notes": "Đặt sân VIP công ty giao lưu"
            },
            {
                "court": created_courts[2],
                "user": None,
                "customer_name": "Lê Hoàng Quân",
                "customer_phone": "0933221100",
                "customer_email": "quan.le@gmail.com",
                "booking_date": today,
                "start_time": datetime.time(19, 0),
                "end_time": datetime.time(21, 0),
                "total_price": 180000,
                "status": "pending",
                "payment_status": "unpaid",
                "payment_method": "cash",
                "notes": "Thanh toán tiền mặt khi tới nhận sân"
            },
            {
                "court": created_courts[3],
                "user": customer_user,
                "customer_name": "Nguyễn Văn An",
                "customer_phone": "0987654321",
                "customer_email": "an.nguyen@gmail.com",
                "booking_date": tomorrow,
                "start_time": datetime.time(8, 0),
                "end_time": datetime.time(10, 0),
                "total_price": 300000,
                "status": "confirmed",
                "payment_status": "paid",
                "payment_method": "banking",
                "notes": "Trận đấu giao lưu nội bộ câu lạc bộ"
            },
        ]

        Booking.objects.all().delete()
        for b in sample_bookings:
            booking = Booking.objects.create(**b)
            self.stdout.write(f" - Đã tạo lượt đặt sân mẫu: {booking.booking_code} ({booking.customer_name})")

        self.stdout.write(self.style.SUCCESS("Đã hoàn tất khởi tạo dữ liệu mẫu thành công!"))
