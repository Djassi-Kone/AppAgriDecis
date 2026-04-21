"""
Exceptions personnalisées pour le projet AgriDecis
"""
import logging
from rest_framework import status
from rest_framework.response import Response

logger = logging.getLogger(__name__)

class AgriDecisException(Exception):
    """
    Exception de base pour le projet AgriDecis
    """
    def __init__(self, message, status_code=status.HTTP_400_BAD_REQUEST, details=None):
        self.message = message
        self.status_code = status_code
        self.details = details
        super().__init__(message)

class ValidationException(AgriDecisException):
    """
    Exception pour les erreurs de validation
    """
    def __init__(self, message, field=None, details=None):
        super().__init__(
            message=message,
            status_code=status.HTTP_400_BAD_REQUEST,
            details=details
        )
        self.field = field

class AuthenticationException(AgriDecisException):
    """
    Exception pour les erreurs d'authentification
    """
    def __init__(self, message="Erreur d'authentification", details=None):
        super().__init__(
            message=message,
            status_code=status.HTTP_401_UNAUTHORIZED,
            details=details
        )

class AuthorizationException(AgriDecisException):
    """
    Exception pour les erreurs d'autorisation
    """
    def __init__(self, message="Accès non autorisé", details=None):
        super().__init__(
            message=message,
            status_code=status.HTTP_403_FORBIDDEN,
            details=details
        )

class ResourceNotFoundException(AgriDecisException):
    """
    Exception pour les ressources non trouvées
    """
    def __init__(self, resource="Ressource", details=None):
        super().__init__(
            message=f"{resource} non trouvée",
            status_code=status.HTTP_404_NOT_FOUND,
            details=details
        )
        self.resource = resource

class ExternalServiceException(AgriDecisException):
    """
    Exception pour les erreurs des services externes (API Oxlo, etc.)
    """
    def __init__(self, service_name, message="Erreur du service externe", details=None):
        super().__init__(
            message=f"{service_name}: {message}",
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            details=details
        )
        self.service_name = service_name

class FileUploadException(AgriDecisException):
    """
    Exception pour les erreurs d'upload de fichiers
    """
    def __init__(self, message="Erreur lors de l'upload du fichier", details=None):
        super().__init__(
            message=message,
            status_code=status.HTTP_400_BAD_REQUEST,
            details=details
        )

class RateLimitException(AgriDecisException):
    """
    Exception pour les limites de taux
    """
    def __init__(self, message="Limite de taux dépassée", retry_after=None, details=None):
        super().__init__(
            message=message,
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            details=details
        )
        self.retry_after = retry_after

def handle_exception(exc, context=None):
    """
    Gestionnaire d'exceptions centralisé
    """
    if isinstance(exc, AgriDecisException):
        logger.error(f"AgriDecisException: {exc.message} - Details: {exc.details}")
        
        response_data = {
            'success': False,
            'error': True,
            'message': exc.message,
            'status_code': exc.status_code,
        }
        
        if exc.details:
            response_data['details'] = exc.details
        
        # Ajouter des informations spécifiques selon le type d'exception
        if isinstance(exc, ValidationException) and exc.field:
            response_data['field'] = exc.field
        elif isinstance(exc, RateLimitException) and exc.retry_after:
            response_data['retry_after'] = exc.retry_after
        elif isinstance(exc, ExternalServiceException):
            response_data['service'] = exc.service_name
        
        return Response(response_data, status=exc.status_code)
    
    # Pour les autres exceptions, logger et retourner une erreur générique
    logger.error(f"Unhandled exception: {type(exc).__name__}: {str(exc)} - Context: {context}")
    
    return Response({
        'success': False,
        'error': True,
        'message': 'Erreur interne du serveur',
        'status_code': status.HTTP_500_INTERNAL_SERVER_ERROR,
    }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
