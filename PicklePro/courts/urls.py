from django.urls import path
from . import views

urlpatterns = [
    path("", views.dashboard, name="dashboard"),
    path("courts/<int:court_id>/", views.court_detail, name="court_detail"),
    path("schedule/", views.court_schedule, name="court_schedule"),
]