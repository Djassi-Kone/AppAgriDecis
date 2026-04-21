"""
Middleware personnalisés pour le projet AgriDecis
"""
import time
import logging
from django.utils.deprecation import MiddlewareMixin
from django.http import JsonResponse
from django.conf import settings
from django.core.cache import cache

logger = logging.getLogger(__name__)

class SecurityHeadersMiddleware(MiddlewareMixin):
    """
    Ajoute des en-têtes de sécurité aux réponses
    """
    def process_response(self, request, response):
        # En-têtes de sécurité
        response['X-Content-Type-Options'] = 'nosniff'
        response['X-Frame-Options'] = 'DENY'
        response['X-XSS-Protection'] = '1; mode=block'
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        
        # En production
        if not settings.DEBUG:
            response['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
            response['Content-Security-Policy'] = (
                "default-src 'self'; "
                "script-src 'self' 'unsafe-inline' 'unsafe-eval'; "
                "style-src 'self' 'unsafe-inline'; "
                "img-src 'self' data: https:; "
                "font-src 'self'; "
                "connect-src 'self' https://api.open-meteo.com https://api.oxlo.ai;"
            )
        
        return response

class RateLimitMiddleware(MiddlewareMixin):
    """
    Middleware de limitation de taux par IP
    """
    def process_request(self, request):
        if settings.DEBUG:
            return None  # Désactiver en développement
        
        # Clé de cache basée sur l'IP
        client_ip = self.get_client_ip(request)
        cache_key = f"rate_limit:{client_ip}"
        
        # Récupérer le compteur actuel
        count = cache.get(cache_key, 0)
        
        # Limites par endpoint
        limits = {
            '/api/auth/login/': 5,  # 5 tentatives par minute
            '/api/auth/register/': 3,  # 3 inscriptions par minute
            '/api/ai/diagnosis/': 10,  # 10 diagnostics par minute
            '/api/ai/chat/': 20,  # 20 messages par minute
            'default': 100  # 100 requêtes par minute par défaut
        }
        
        # Trouver la limite appropriée
        path = request.path
        rate_limit = limits.get(path, limits['default'])
        
        if count >= rate_limit:
            logger.warning(f"Rate limit exceeded for IP {client_ip} on {path}")
            return JsonResponse({
                'success': False,
                'error': True,
                'message': 'Limite de taux dépassée',
                'retry_after': 60,
                'status_code': 429
            }, status=429)
        
        # Incrémenter le compteur
        cache.set(cache_key, count + 1, timeout=60)  # 1 minute
        return None
    
    def get_client_ip(self, request):
        """
        Récupère l'IP réelle du client
        """
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0].strip()
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip

class RequestLoggingMiddleware(MiddlewareMixin):
    """
    Middleware pour logger les requêtes
    """
    def process_request(self, request):
        request.start_time = time.time()
        return None
    
    def process_response(self, request, response):
        if hasattr(request, 'start_time'):
            duration = time.time() - request.start_time
            
            # Logger les informations de la requête
            logger.info(
                f"{request.method} {request.path} - "
                f"Status: {response.status_code} - "
                f"Duration: {duration:.3f}s - "
                f"IP: {self.get_client_ip(request)} - "
                f"User: {getattr(request.user, 'email', 'anonymous')}"
            )
            
            # Logger les erreurs
            if response.status_code >= 400:
                logger.warning(
                    f"Error response - {request.method} {request.path} - "
                    f"Status: {response.status_code} - "
                    f"User: {getattr(request.user, 'email', 'anonymous')}"
                )
        
        return response
    
    def get_client_ip(self, request):
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0].strip()
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip

class APIKeyValidationMiddleware(MiddlewareMixin):
    """
    Middleware pour valider les clés API (optionnel)
    """
    def process_request(self, request):
        # Ne s'applique qu'aux endpoints d'IA
        if '/api/ai/' not in request.path:
            return None
        
        # Vérifier si une clé API est requise
        api_key = request.headers.get('X-API-Key')
        if not api_key:
            api_key = request.GET.get('api_key')
        
        # Si on est en mode authentification JWT, bypasser
        if request.headers.get('Authorization'):
            return None
        
        # Valider la clé API
        if api_key and api_key == settings.OXLO_API_KEY:
            return None
        
        # Rejeter si pas de clé valide
        return JsonResponse({
            'success': False,
            'error': True,
            'message': 'Clé API requise',
            'status_code': 401
        }, status=401)
