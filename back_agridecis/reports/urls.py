from django.urls import path

from .views import GenerateReportView, ListReportsView

urlpatterns = [
    path("reports/generate/", GenerateReportView.as_view(), name="reports-generate"),
    path("reports/", ListReportsView.as_view(), name="reports-list"),
]

