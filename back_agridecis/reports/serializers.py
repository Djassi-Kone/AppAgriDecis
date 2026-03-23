from rest_framework import serializers

from .models import ReportDocument


class ReportDocumentSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReportDocument
        fields = ["id", "created_at", "payload_json", "file"]
        read_only_fields = ["id", "created_at", "file"]

