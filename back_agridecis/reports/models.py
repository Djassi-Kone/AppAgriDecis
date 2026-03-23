from django.conf import settings
from django.db import models


class ReportDocument(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="report_documents"
    )
    created_at = models.DateTimeField(auto_now_add=True)
    payload_json = models.JSONField(blank=True, null=True)
    file = models.FileField(upload_to="reports/", blank=True, null=True)

