from django.contrib import admin
from .models import Court


@admin.register(Court)
class CourtAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "code",
        "court_type",
        "location",
        "price_per_hour",
        "status",
    )

    list_filter = (
        "status",
        "court_type",
    )

    search_fields = (
        "name",
        "code",
        "location",
    )