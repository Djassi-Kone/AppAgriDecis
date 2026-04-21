"""
Configuration de l'application IA
"""
from django.apps import AppConfig

class AiConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'ai'
    verbose_name = 'Intelligence Artificielle'
    
    def ready(self):
        """Initialisation de l'application"""
   
        try:
            import ai.signals
        except ImportError:
            pass
