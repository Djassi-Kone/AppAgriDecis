"""
Utilitaires pour le projet AgriDecis
"""
import logging
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import exception_handler

logger = logging.getLogger(__name__)

def custom_exception_handler(exc, context):
    """
    Gestionnaire d'exceptions personnalisé pour l'API
    """
    # Call REST framework's default exception handler first
    response = exception_handler(exc, context)
    
    # Add custom handling
    if response is not None:
        custom_response_data = {
            'error': True,
            'status_code': response.status_code,
            'message': str(exc),
            'details': response.data if hasattr(response, 'data') else None
        }
        
        # Log l'erreur
        logger.error(f"API Error: {exc} - Context: {context}")
        
        response.data = custom_response_data
    
    return response

def validate_coordinates(lat, lon):
    """
    Valide les coordonnées GPS
    """
    try:
        latitude = float(lat)
        longitude = float(lon)
        
        if not (-90 <= latitude <= 90):
            raise ValueError("Latitude doit être entre -90 et 90")
        if not (-180 <= longitude <= 180):
            raise ValueError("Longitude doit être entre -180 et 180")
            
        return latitude, longitude
    except (ValueError, TypeError) as e:
        raise ValueError(f"Coordonnées invalides: {e}")

def format_api_response(data=None, message="Success", status_code=status.HTTP_200_OK):
    """
    Formate la réponse API de manière cohérente
    """
    response_data = {
        'success': True,
        'message': message,
        'data': data
    }
    
    return Response(response_data, status=status_code)

def format_api_error(message="Error", details=None, status_code=status.HTTP_400_BAD_REQUEST):
    """
    Formate une réponse d'erreur API de manière cohérente
    """
    response_data = {
        'success': False,
        'message': message,
        'error': details
    }
    
    return Response(response_data, status=status_code)
