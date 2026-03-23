from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .services import get_forecast


class ForecastView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        try:
            lat = float(request.query_params.get("lat"))
            lon = float(request.query_params.get("lon"))
        except (TypeError, ValueError):
            return Response({"detail": "Paramètres lat et lon requis"}, status=400)

        data = get_forecast(lat, lon)
        return Response(data)

from django.shortcuts import render

# Create your views here.
