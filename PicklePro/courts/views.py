from django.shortcuts import render, get_object_or_404, redirect
from django.db.models import Q, Count
from django.utils import timezone
from .models import Court
from bookings.models import Booking
import datetime


def dashboard(request):
    """Trang chủ và tổng quan sân Pickleball"""
    today = timezone.localdate()
    
    # Lấy tham số tìm kiếm và bộ lọc
    query = request.GET.get("q", "").strip()
    status_filter = request.GET.get("status", "")
    type_filter = request.GET.get("type", "")
    sort_by = request.GET.get("sort", "name")

    courts = Court.objects.all()

    # Thống kê tổng quan
    total_courts = courts.count()
    available_courts = courts.filter(status="available").count()
    maintenance_courts = courts.filter(status="maintenance").count()
    closed_courts = courts.filter(status="closed").count()

    # Thống kê lượt đặt
    today_bookings_count = Booking.objects.filter(booking_date=today).exclude(status="cancelled").count()
    total_bookings_count = Booking.objects.exclude(status="cancelled").count()

    # Áp dụng tìm kiếm
    if query:
        courts = courts.filter(
            Q(name__icontains=query) |
            Q(code__icontains=query) |
            Q(location__icontains=query) |
            Q(description__icontains=query)
        )

    # Áp dụng bộ lọc
    if status_filter:
        courts = courts.filter(status=status_filter)
    if type_filter:
        courts = courts.filter(court_type=type_filter)

    # Sắp xếp
    if sort_by == "price_asc":
        courts = courts.order_by("price_per_hour")
    elif sort_by == "price_desc":
        courts = courts.order_by("-price_per_hour")
    else:
        courts = courts.order_by("name")

    # Danh sách đặt sân hôm nay sắp tới
    upcoming_bookings = Booking.objects.filter(
        booking_date=today,
        status__in=["pending", "confirmed"]
    ).select_related("court").order_by("start_time")[:6]

    context = {
        "courts": courts,
        "total_courts": total_courts,
        "available_courts": available_courts,
        "maintenance_courts": maintenance_courts,
        "closed_courts": closed_courts,
        "today_bookings_count": today_bookings_count,
        "total_bookings_count": total_bookings_count,
        "upcoming_bookings": upcoming_bookings,
        "today": today,
        "query": query,
        "status_filter": status_filter,
        "type_filter": type_filter,
        "sort_by": sort_by,
    }

    return render(request, "dashboard.html", context)


def court_detail(request, court_id):
    """Trang chi tiết một sân Pickleball kèm lịch trống trong ngày"""
    court = get_object_or_404(Court, id=court_id)
    
    date_str = request.GET.get("date")
    if date_str:
        try:
            selected_date = datetime.date.fromisoformat(date_str)
        except ValueError:
            selected_date = timezone.localdate()
    else:
        selected_date = timezone.localdate()

    # Lấy các booking của sân trong ngày được chọn
    day_bookings = Booking.objects.filter(
        court=court,
        booking_date=selected_date
    ).exclude(status="cancelled").order_by("start_time")

    # Tạo bảng khung giờ (06:00 đến 22:00)
    slots = []
    for hour in range(6, 22):
        start_t = datetime.time(hour, 0)
        end_t = datetime.time(hour + 1, 0)
        
        # Kiểm tra slot có bị trùng với booking nào không
        matched_booking = None
        for b in day_bookings:
            if not (end_t <= b.start_time or start_t >= b.end_time):
                matched_booking = b
                break

        slots.append({
            "start": f"{hour:02d}:00",
            "end": f"{hour + 1:02d}:00",
            "is_booked": matched_booking is not None,
            "booking": matched_booking,
        })

    # Tiện ích tách thành danh sách
    features_list = [f.strip() for f in court.features.split(",") if f.strip()]

    context = {
        "court": court,
        "selected_date": selected_date,
        "slots": slots,
        "features_list": features_list,
        "today": timezone.localdate(),
    }
    return render(request, "courts/court_detail.html", context)


def court_schedule(request):
    """Xem thời khóa biểu tổng quát toàn bộ các sân theo ngày"""
    date_str = request.GET.get("date")
    if date_str:
        try:
            selected_date = datetime.date.fromisoformat(date_str)
        except ValueError:
            selected_date = timezone.localdate()
    else:
        selected_date = timezone.localdate()

    courts = Court.objects.filter(status__in=["available", "maintenance"]).order_by("code")
    bookings = Booking.objects.filter(
        booking_date=selected_date
    ).exclude(status="cancelled")

    # Giờ từ 6h đến 22h
    hours = list(range(6, 22))
    
    # Xây dựng ma trận lịch: court_id -> hour -> status
    timetable = []
    for court in courts:
        court_slots = []
        court_bookings = [b for b in bookings if b.court_id == court.id]
        
        for h in hours:
            st = datetime.time(h, 0)
            et = datetime.time(h + 1, 0)
            is_booked = False
            b_info = None

            if court.status == "maintenance":
                slot_status = "maintenance"
            else:
                for b in court_bookings:
                    if not (et <= b.start_time or st >= b.end_time):
                        is_booked = True
                        b_info = b
                        break
                slot_status = "booked" if is_booked else "free"

            court_slots.append({
                "hour": h,
                "label": f"{h:02d}:00",
                "status": slot_status,
                "booking": b_info,
            })

        timetable.append({
            "court": court,
            "slots": court_slots,
        })

    context = {
        "selected_date": selected_date,
        "hours": hours,
        "timetable": timetable,
        "today": timezone.localdate(),
    }
    return render(request, "courts/schedule.html", context)