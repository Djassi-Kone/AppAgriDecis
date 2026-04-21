from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from back_agridecis.utils import format_api_response, format_api_error, validate_coordinates
from back_agridecis.exceptions import ValidationException, ExternalServiceException

from .services import get_forecast, get_weather_alerts


class ForecastView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        try:
            lat = request.query_params.get("lat")
            lon = request.query_params.get("lon")
            
            if not lat or not lon:
                raise ValidationException("Les paramètres lat et lon sont requis")
            
            # Valider les coordonnées
            latitude, longitude = validate_coordinates(lat, lon)

            data = get_forecast(latitude, longitude)
            return format_api_response(data, "Prévisions météo récupérées avec succès")
            
        except ValidationException as e:
            return format_api_error(e.message, e.details, e.status_code)
        except Exception as e:
            raise ExternalServiceException("Open-Meteo", f"Erreur lors de la récupération des prévisions: {str(e)}")


class AlertsView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        try:
            lat = request.query_params.get("lat")
            lon = request.query_params.get("lon")
            
            if not lat or not lon:
                raise ValidationException("Les paramètres lat et lon sont requis")
            
            # Valider les coordonnées
            latitude, longitude = validate_coordinates(lat, lon)

            data = get_weather_alerts(latitude, longitude)
            return format_api_response(data, "Alertes météo récupérées avec succès")
            
        except ValidationException as e:
            return format_api_error(e.message, e.details, e.status_code)
        except Exception as e:
            raise ExternalServiceException("Open-Meteo", f"Erreur lors de la récupération des alertes: {str(e)}")


class CurrentWeatherView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        try:
            lat = request.query_params.get("lat")
            lon = request.query_params.get("lon")
            
            if not lat or not lon:
                raise ValidationException("Les paramètres lat et lon sont requis")
            
            # Valider les coordonnées
            latitude, longitude = validate_coordinates(lat, lon)

            # Récupérer les prévisions complètes
            forecast_data = get_forecast(latitude, longitude)
            
            # Extraire uniquement les données actuelles
            current_data = {
                'current': forecast_data.get('current', {}),
                'current_units': forecast_data.get('current_units', {}),
                'location': {
                    'latitude': latitude,
                    'longitude': longitude
                },
                'timezone': forecast_data.get('timezone', 'UTC')
            }
            
            return format_api_response(current_data, "Météo actuelle récupérée avec succès")
            
        except ValidationException as e:
            return format_api_error(e.message, e.details, e.status_code)
        except Exception as e:
            raise ExternalServiceException("Open-Meteo", f"Erreur lors de la récupération de la météo actuelle: {str(e)}")

from django.shortcuts import render

# Create your views here.
