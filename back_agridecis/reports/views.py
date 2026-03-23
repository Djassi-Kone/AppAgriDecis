from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from ai.models import DiagnosisRequest

from .models import ReportDocument
from .serializers import ReportDocumentSerializer


class GenerateReportView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Version 1: rapport JSON (export PDF/Excel = phase suivante)
        diagnostics = DiagnosisRequest.objects.filter(user=request.user).order_by("-created_at")[:50]
        payload = {
            "user": str(request.user),
            "diagnostics": [
                {"id": d.id, "created_at": d.created_at.isoformat(), "culture": d.culture, "result": d.result_json}
                for d in diagnostics
            ],
        }
        doc = ReportDocument.objects.create(user=request.user, payload_json=payload)
        return Response(ReportDocumentSerializer(doc).data)


class ListReportsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = ReportDocument.objects.filter(user=request.user).order_by("-created_at")
        return Response(ReportDocumentSerializer(qs, many=True).data)
