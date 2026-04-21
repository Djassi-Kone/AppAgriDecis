"""
Configuration de l'application contents
"""
from django.apps import AppConfig

class ContentsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'contents'
    verbose_name = 'Gestion des Contenus'
    
    def ready(self):
        """Initialisation de l'application"""
        try:
            import contents.signals
        except ImportError:
            pass
