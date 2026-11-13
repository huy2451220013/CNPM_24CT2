from django.contrib import admin
from .models import Booking


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = (
        "booking_code",
        "court",
        "customer_name",
        "customer_phone",
        "booking_date",
        "start_time",
        "end_time",
        "total_price",
        "status",
        "payment_status",
    )
    list_filter = (
        "status",
        "payment_status",
        "payment_method",
        "booking_date",
        "court",
    )
    search_fields = (
        "booking_code",
        "customer_name",
        "customer_phone",
        "customer_email",
    )
    date_hierarchy = "booking_date"
