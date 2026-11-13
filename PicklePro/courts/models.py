from django.db import models


class Court(models.Model):
    COURT_TYPE_CHOICES = [
        ("indoor", "Trong nhà"),
        ("outdoor", "Ngoài trời"),
        ("vip", "VIP Trong nhà"),
    ]

    STATUS_CHOICES = [
        ("available", "Đang hoạt động"),
        ("maintenance", "Đang bảo trì"),
        ("closed", "Đã đóng"),
    ]

    name = models.CharField(
        max_length=100,
        verbose_name="Tên sân"
    )

    code = models.CharField(
        max_length=20,
        unique=True,
        verbose_name="Mã sân"
    )

    location = models.CharField(
        max_length=255,
        verbose_name="Địa chỉ"
    )

    price_per_hour = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        verbose_name="Giá thuê / giờ"
    )

    court_type = models.CharField(
        max_length=20,
        choices=COURT_TYPE_CHOICES,
        default="indoor",
        verbose_name="Loại sân"
    )

    image_url = models.CharField(
        max_length=500,
        blank=True,
        default="",
        verbose_name="URL hình ảnh"
    )

    features = models.CharField(
        max_length=255,
        blank=True,
        default="Mặt sân tiêu chuẩn USAPA, Đèn LED cao cấp, Ghế nghỉ",
        verbose_name="Tiện ích đi kèm"
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="available",
        verbose_name="Trạng thái"
    )

    description = models.TextField(
        blank=True,
        verbose_name="Mô tả"
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    updated_at = models.DateTimeField(
        auto_now=True
    )

    class Meta:
        verbose_name = "Sân"
        verbose_name_plural = "Các sân"
        ordering = ["name"]

    def __str__(self):
        return f"{self.name} ({self.code})"

    @property
    def is_available(self):
        return self.status == "available"