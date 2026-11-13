from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required, user_passes_test
from django.http import JsonResponse
from django.utils import timezone
from courts.models import Court
from .models import Booking
import datetime
from decimal import Decimal


def book_court(request, court_id=None):
    """Đặt sân Pickleball với kiểm tra trùng lịch thông minh"""
    selected_court = None
    if court_id:
        selected_court = get_object_or_404(Court, id=court_id)

    courts = Court.objects.filter(status="available").order_by("name")
    today = timezone.localdate()

    # Nhận các tham số truyền qua URL (nếu có)
    param_date = request.GET.get("date", today.isoformat())
    param_start = request.GET.get("start", "08:00")
    param_end = request.GET.get("end", "09:00")

    if request.method == "POST":
        c_id = request.POST.get("court_id")
        court = get_object_or_404(Court, id=c_id)

        customer_name = request.POST.get("customer_name", "").strip()
        customer_phone = request.POST.get("customer_phone", "").strip()
        customer_email = request.POST.get("customer_email", "").strip()
        date_str = request.POST.get("booking_date", "").strip()
        start_str = request.POST.get("start_time", "").strip()
        end_str = request.POST.get("end_time", "").strip()
        payment_method = request.POST.get("payment_method", "cash")
        notes = request.POST.get("notes", "").strip()

        # Validation cơ bản
        if not customer_name or not customer_phone or not date_str or not start_str or not end_str:
            messages.error(request, "Vui lòng điền đầy đủ các thông tin bắt buộc!")
            return render(request, "bookings/book.html", {
                "courts": courts,
                "selected_court": court,
                "param_date": date_str or param_date,
                "param_start": start_str or param_start,
                "param_end": end_str or param_end,
                "today": today,
            })

        try:
            booking_date = datetime.date.fromisoformat(date_str)
            start_time = datetime.time.fromisoformat(start_str)
            end_time = datetime.time.fromisoformat(end_str)
        except ValueError:
            messages.error(request, "Định dạng ngày hoặc giờ không hợp lệ!")
            return redirect("book_court")

        # Kiểm tra ngày trong quá khứ
        if booking_date < today:
            messages.error(request, "Không thể đặt sân trong quá khứ!")
            return render(request, "bookings/book.html", {
                "courts": courts,
                "selected_court": court,
                "param_date": date_str,
                "param_start": start_str,
                "param_end": end_str,
                "today": today,
            })

        # Kiểm tra giờ bắt đầu phải nhỏ hơn giờ kết thúc
        if start_time >= end_time:
            messages.error(request, "Giờ kết thúc phải sau giờ bắt đầu ít nhất 30 phút!")
            return render(request, "bookings/book.html", {
                "courts": courts,
                "selected_court": court,
                "param_date": date_str,
                "param_start": start_str,
                "param_end": end_str,
                "today": today,
            })

        # Kiểm tra trùng lịch đặt sân (Double Booking Prevention)
        conflicts = Booking.objects.filter(
            court=court,
            booking_date=booking_date,
            start_time__lt=end_time,
            end_time__gt=start_time
        ).exclude(status="cancelled")

        if conflicts.exists():
            conflict = conflicts.first()
            messages.error(
                request,
                f"Sân {court.name} đã có người đặt trong khung giờ {conflict.start_time.strftime('%H:%M')} - {conflict.end_time.strftime('%H:%M')} ngày {booking_date.strftime('%d/%m/%Y')}. Vui lòng chọn khung giờ khác!"
            )
            return render(request, "bookings/book.html", {
                "courts": courts,
                "selected_court": court,
                "param_date": date_str,
                "param_start": start_str,
                "param_end": end_str,
                "today": today,
            })

        # Tính tổng tiền theo số giờ
        dt_start = datetime.datetime.combine(booking_date, start_time)
        dt_end = datetime.datetime.combine(booking_date, end_time)
        duration_hours = (dt_end - dt_start).total_seconds() / 3600.0
        total_price = int(Decimal(duration_hours) * court.price_per_hour)

        # Lưu lượt đặt sân
        booking = Booking(
            court=court,
            user=request.user if request.user.is_authenticated else None,
            customer_name=customer_name,
            customer_phone=customer_phone,
            customer_email=customer_email,
            booking_date=booking_date,
            start_time=start_time,
            end_time=end_time,
            total_price=total_price,
            status="pending",
            payment_status="unpaid",
            payment_method=payment_method,
            notes=notes,
        )
        booking.save()

        messages.success(request, f"Đặt sân thành công! Mã đặt sân của bạn là: {booking.booking_code}")
        return redirect("booking_detail", booking_code=booking.booking_code)

    # Điền sẵn thông tin nếu người dùng đã đăng nhập
    initial_user = {}
    if request.user.is_authenticated:
        initial_user["name"] = request.user.get_full_name() or request.user.username
        initial_user["email"] = request.user.email
        if hasattr(request.user, "profile"):
            initial_user["phone"] = request.user.profile.phone_number

    context = {
        "courts": courts,
        "selected_court": selected_court,
        "param_date": param_date,
        "param_start": param_start,
        "param_end": param_end,
        "initial_user": initial_user,
        "today": today,
    }
    return render(request, "bookings/book.html", context)


def booking_detail(request, booking_code):
    """Chi tiết vé đặt sân, mã QR thanh toán VietQR và thông tin hướng dẫn"""
    booking = get_object_or_404(Booking.objects.select_related("court", "user"), booking_code=booking_code)

    # Tạo link mã QR chuyển khoản VietQR tự động
    qr_bank_id = "MB"
    qr_account_no = "934567897"
    qr_account_name = "TRAN QUOC HUY"
    qr_content = f"THANH TOAN {booking.booking_code}"
    
    qr_url = (
        f"https://img.vietqr.io/image/{qr_bank_id}-{qr_account_no}-compact2.png"
        f"?amount={booking.total_price}&addInfo={qr_content}&accountName={qr_account_name.replace(' ', '%20')}"
    )

    context = {
        "booking": booking,
        "qr_url": qr_url,
        "bank_name": "Ngân hàng Quân Đội (MB Bank)",
        "account_no": qr_account_no,
        "account_name": qr_account_name,
        "transfer_content": qr_content,
    }
    return render(request, "bookings/booking_detail.html", context)


def my_bookings(request):
    """Danh sách các lịch đặt sân (dành cho người dùng đăng nhập hoặc tra cứu theo SĐT)"""
    phone_query = request.GET.get("phone", "").strip()
    bookings = Booking.objects.none()

    if request.user.is_authenticated:
        # Nếu đã đăng nhập, lấy theo user hoặc phone nếu tìm
        if phone_query:
            bookings = Booking.objects.filter(customer_phone=phone_query).select_related("court")
        else:
            bookings = Booking.objects.filter(user=request.user).select_related("court")
    else:
        # Nếu là khách vãng lai, hiển thị nếu đã nhập số điện thoại
        if phone_query:
            bookings = Booking.objects.filter(customer_phone=phone_query).select_related("court")

    context = {
        "bookings": bookings,
        "phone_query": phone_query,
    }
    return render(request, "bookings/my_bookings.html", context)


def cancel_booking(request, booking_code):
    """Hủy lịch đặt sân"""
    booking = get_object_or_404(Booking, booking_code=booking_code)

    if request.method == "POST":
        if booking.status in ["completed"]:
            messages.error(request, "Không thể hủy lượt đặt sân đã hoàn thành!")
        else:
            booking.status = "cancelled"
            booking.save()
            messages.success(request, f"Đã hủy thành công lượt đặt sân {booking.booking_code}!")
        return redirect("booking_detail", booking_code=booking.booking_code)

    return redirect("booking_detail", booking_code=booking.booking_code)


def manage_bookings(request):
    """Trang quản trị / điều hành đặt sân dành cho nhân viên & chủ sân"""
    if not (request.user.is_authenticated and request.user.is_staff):
        messages.warning(request, "Bạn cần đăng nhập tài khoản Quản trị viên (Admin) để truy cập trang này!")
        return redirect("login")

    today = timezone.localdate()
    status_filter = request.GET.get("status", "")
    date_filter = request.GET.get("date", "")
    court_filter = request.GET.get("court", "")

    bookings = Booking.objects.all().select_related("court", "user")

    if status_filter:
        bookings = bookings.filter(status=status_filter)
    if date_filter:
        bookings = bookings.filter(booking_date=date_filter)
    if court_filter:
        bookings = bookings.filter(court_id=court_filter)

    courts = Court.objects.all()

    # Thống kê nhanh
    pending_count = Booking.objects.filter(status="pending").count()
    confirmed_count = Booking.objects.filter(status="confirmed").count()
    today_count = Booking.objects.filter(booking_date=today).exclude(status="cancelled").count()
    
    # Tính doanh thu đã thanh toán
    paid_bookings = Booking.objects.filter(payment_status="paid")
    total_revenue = sum(b.total_price for b in paid_bookings)

    context = {
        "bookings": bookings,
        "courts": courts,
        "status_filter": status_filter,
        "date_filter": date_filter,
        "court_filter": court_filter,
        "pending_count": pending_count,
        "confirmed_count": confirmed_count,
        "today_count": today_count,
        "total_revenue": total_revenue,
        "today": today,
    }
    return render(request, "bookings/manage_bookings.html", context)


def update_booking_status(request, booking_id):
    """Cập nhật trạng thái đặt sân & thanh toán (Admin/Staff)"""
    if not (request.user.is_authenticated and request.user.is_staff):
        return JsonResponse({"error": "Unauthorized"}, status=403)

    if request.method == "POST":
        booking = get_object_or_404(Booking, id=booking_id)
        new_status = request.POST.get("status")
        new_payment = request.POST.get("payment_status")

        if new_status in ["pending", "confirmed", "completed", "cancelled"]:
            booking.status = new_status
        if new_payment in ["unpaid", "paid"]:
            booking.payment_status = new_payment

        booking.save()
        messages.success(request, f"Đã cập nhật lịch đặt {booking.booking_code} thành công!")
        return redirect("manage_bookings")

    return redirect("manage_bookings")


def toggle_court_status(request, court_id):
    """Chuyển đổi trạng thái sân Hoạt động <-> Bảo trì (Admin)"""
    if not (request.user.is_authenticated and request.user.is_staff):
        messages.error(request, "Bạn không có quyền thực hiện thao tác này!")
        return redirect("dashboard")

    court = get_object_or_404(Court, id=court_id)
    if court.status == "available":
        court.status = "maintenance"
    elif court.status == "maintenance":
        court.status = "available"
    court.save()
    messages.success(request, f"Đã cập nhật trạng thái sân {court.name} thành: {court.get_status_display()}!")
    return redirect(request.META.get("HTTP_REFERER", "dashboard"))


def api_court_slots(request):
    """API lấy các khung giờ của sân vào 1 ngày để giao diện hiển thị realtime"""
    court_id = request.GET.get("court_id")
    date_str = request.GET.get("date")

    if not court_id or not date_str:
        return JsonResponse({"error": "Missing parameters"}, status=400)

    try:
        booking_date = datetime.date.fromisoformat(date_str)
    except ValueError:
        return JsonResponse({"error": "Invalid date"}, status=400)

    court = get_object_or_404(Court, id=court_id)
    booked_ranges = Booking.objects.filter(
        court=court,
        booking_date=booking_date
    ).exclude(status="cancelled").values("start_time", "end_time", "customer_name", "status")

    slots = []
    for h in range(6, 22):
        st = datetime.time(h, 0)
        et = datetime.time(h + 1, 0)
        
        is_taken = False
        status_name = "free"
        for b in booked_ranges:
            if not (et <= b["start_time"] or st >= b["end_time"]):
                is_taken = True
                status_name = b["status"]
                break

        slots.append({
            "hour": h,
            "label": f"{h:02d}:00 - {h+1:02d}:00",
            "is_booked": is_taken,
            "status": status_name,
        })

    return JsonResponse({
        "court_name": court.name,
        "court_price": court.price_per_hour,
        "slots": slots,
    })
