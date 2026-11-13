from django.db import models
from django.contrib.auth.models import User
from courts.models import Court
import uuid


class Booking(models.Model):
    STATUS_CHOICES = [
        ("pending", "Chờ xác nhận"),
        ("confirmed", "Đã xác nhận"),
        ("completed", "Hoàn thành"),
        ("cancelled", "Đã hủy"),
    ]

    PAYMENT_STATUS_CHOICES = [
        ("unpaid", "Chưa thanh toán"),
        ("paid", "Đã thanh toán"),
    ]

    PAYMENT_METHOD_CHOICES = [
        ("cash", "Tiền mặt tại sân"),
        ("banking", "Chuyển khoản VietQR"),
    ]

    booking_code = models.CharField(
        max_length=30,
        unique=True,
        verbose_name="Mã đặt sân"
    )

    court = models.ForeignKey(
        Court,
        on_delete=models.CASCADE,
        related_name="bookings",
        verbose_name="Sân bóng"
    )

    user = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="bookings",
        verbose_name="Tài khoản khách hàng"
    )

    customer_name = models.CharField(
        max_length=100,
        verbose_name="Họ và tên khách"
    )

    customer_phone = models.CharField(
        max_length=20,
        verbose_name="Số điện thoại"
    )

    customer_email = models.EmailField(
        blank=True,
        verbose_name="Email"
    )

    booking_date = models.DateField(
        verbose_name="Ngày đặt"
    )

    start_time = models.TimeField(
        verbose_name="Giờ bắt đầu"
    )

    end_time = models.TimeField(
        verbose_name="Giờ kết thúc"
    )

    total_price = models.DecimalField(
        max_digits=12,
        decimal_places=0,
        default=0,
        verbose_name="Tổng tiền (VNĐ)"
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="pending",
        verbose_name="Trạng thái"
    )

    payment_status = models.CharField(
        max_length=20,
        choices=PAYMENT_STATUS_CHOICES,
        default="unpaid",
        verbose_name="Trạng thái thanh toán"
    )

    payment_method = models.CharField(
        max_length=20,
        choices=PAYMENT_METHOD_CHOICES,
        default="cash",
        verbose_name="Phương thức thanh toán"
    )

    notes = models.TextField(
        blank=True,
        verbose_name="Ghi chú"
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name="Ngày tạo"
    )

    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name="Cập nhật cuối"
    )

    class Meta:
        verbose_name = "Lịch đặt sân"
        verbose_name_plural = "Danh sách đặt sân"
        ordering = ["-booking_date", "-start_time"]

    def __str__(self):
        return f"[{self.booking_code}] {self.court.name} - {self.booking_date} ({self.start_time.strftime('%H:%M')} - {self.end_time.strftime('%H:%M')})"

    def save(self, *args, **kwargs):
        if not self.booking_code:
            self.booking_code = f"PKB-{uuid.uuid4().hex[:8].upper()}"
        super().save(*args, **kwargs)
