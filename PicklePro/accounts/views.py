from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import UserProfile
from bookings.models import Booking


def login_view(request):
    """Đăng nhập tài khoản"""
    if request.user.is_authenticated:
        return redirect("dashboard")

    next_url = request.GET.get("next", "dashboard")

    if request.method == "POST":
        username = request.POST.get("username", "").strip()
        password = request.POST.get("password", "")

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            messages.success(request, f"Chào mừng {user.get_full_name() or user.username} quay trở lại!")
            return redirect(next_url if next_url != "dashboard" else "dashboard")
        else:
            messages.error(request, "Tên đăng nhập hoặc mật khẩu không chính xác!")

    return render(request, "accounts/login.html")


def register_view(request):
    """Đăng ký tài khoản khách hàng mới"""
    if request.user.is_authenticated:
        return redirect("dashboard")

    if request.method == "POST":
        username = request.POST.get("username", "").strip()
        first_name = request.POST.get("first_name", "").strip()
        last_name = request.POST.get("last_name", "").strip()
        email = request.POST.get("email", "").strip()
        phone_number = request.POST.get("phone_number", "").strip()
        password = request.POST.get("password", "")
        confirm_password = request.POST.get("confirm_password", "")

        if not username or not password or not phone_number:
            messages.error(request, "Vui lòng nhập đầy đủ tên đăng nhập, số điện thoại và mật khẩu!")
            return render(request, "accounts/register.html")

        if password != confirm_password:
            messages.error(request, "Mật khẩu xác nhận không khớp!")
            return render(request, "accounts/register.html")

        if len(password) < 6:
            messages.error(request, "Mật khẩu phải chứa ít nhất 6 ký tự!")
            return render(request, "accounts/register.html")

        if User.objects.filter(username=username).exists():
            messages.error(request, "Tên đăng nhập này đã được sử dụng. Vui lòng chọn tên khác!")
            return render(request, "accounts/register.html")

        if email and User.objects.filter(email=email).exists():
            messages.error(request, "Địa chỉ Email này đã được đăng ký tài khoản khác. Vui lòng sử dụng Email khác hoặc Đăng nhập!")
            return render(request, "accounts/register.html")

        # Tạo user
        user = User.objects.create_user(
            username=username,
            password=password,
            email=email,
            first_name=first_name,
            last_name=last_name
        )
        UserProfile.objects.create(
            user=user,
            phone_number=phone_number
        )

        # Tự động đăng nhập
        login(request, user)
        messages.success(request, f"Chúc mừng bạn đã tạo tài khoản thành công! Chào mừng {user.get_full_name() or user.username}.")
        return redirect("dashboard")

    return render(request, "accounts/register.html")


def logout_view(request):
    """Đăng xuất tài khoản"""
    logout(request)
    messages.info(request, "Bạn đã đăng xuất thành công.")
    return redirect("dashboard")


@login_required
def profile_view(request):
    """Xem và cập nhật thông tin cá nhân"""
    profile, _ = UserProfile.objects.get_or_create(user=request.user)

    if request.method == "POST":
        first_name = request.POST.get("first_name", "").strip()
        last_name = request.POST.get("last_name", "").strip()
        email = request.POST.get("email", "").strip()
        phone_number = request.POST.get("phone_number", "").strip()
        address = request.POST.get("address", "").strip()

        request.user.first_name = first_name
        request.user.last_name = last_name
        request.user.email = email
        request.user.save()

        profile.phone_number = phone_number
        profile.address = address
        profile.save()

        messages.success(request, "Đã lưu cập nhật thông tin cá nhân!")
        return redirect("profile")

    my_bookings_list = Booking.objects.filter(user=request.user).select_related("court").order_by("-booking_date")[:5]

    context = {
        "profile": profile,
        "my_bookings": my_bookings_list,
    }
    return render(request, "accounts/profile.html", context)
