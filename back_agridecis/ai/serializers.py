from rest_framework import serializers

from .models import DiagnosisRequest


class DiagnosisRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiagnosisRequest
        fields = ["id", "image", "culture", "created_at", "result_json", "status", "error_message"]
        read_only_fields = ["id", "created_at", "result_json", "status", "error_message"]
