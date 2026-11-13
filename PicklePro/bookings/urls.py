from django.urls import path
from . import views

urlpatterns = [
    path("book/", views.book_court, name="book_court"),
    path("book/<int:court_id>/", views.book_court, name="book_court_specific"),
    path("booking/<str:booking_code>/", views.booking_detail, name="booking_detail"),
    path("booking/<str:booking_code>/cancel/", views.cancel_booking, name="cancel_booking"),
    path("my-bookings/", views.my_bookings, name="my_bookings"),
    path("manage-bookings/", views.manage_bookings, name="manage_bookings"),
    path("manage-bookings/<int:booking_id>/update/", views.update_booking_status, name="update_booking_status"),
    path("court/<int:court_id>/toggle-status/", views.toggle_court_status, name="toggle_court_status"),
    path("api/court-slots/", views.api_court_slots, name="api_court_slots"),
]
