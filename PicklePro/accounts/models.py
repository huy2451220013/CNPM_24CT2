from django.db import models
from django.contrib.auth.models import User


class UserProfile(models.Model):
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="profile",
        verbose_name="Tài khoản"
    )
    phone_number = models.CharField(
        max_length=20,
        blank=True,
        verbose_name="Số điện thoại"
    )
    address = models.CharField(
        max_length=255,
        blank=True,
        verbose_name="Địa chỉ"
    )

    class Meta:
        verbose_name = "Hồ sơ người dùng"
        verbose_name_plural = "Hồ sơ người dùng"

    def __str__(self):
        return f"{self.user.username} ({self.phone_number})"
