"""
Validateurs personnalisés pour le projet AgriDecis
"""
import re
from django.core.exceptions import ValidationError
from django.core.validators import RegexValidator
from django.utils.translation import gettext_lazy as _

def validate_phone_number(value):
    """
    Valide un numéro de téléphone (format international ou local)
    """
    if not value:
        return
    
    # Formats acceptés:
    # +221 77 123 45 67 (Sénégal)
    # 00221 77 123 45 67
    # 771234567 (local Sénégal)
    phone_pattern = re.compile(
        r'^(\+?[0-9]{1,3}[-.\s]?)?\(?[0-9]{1,4}\)?[-.\s]?[0-9]{1,4}[-.\s]?[0-9]{1,9}$'
    )
    
    if not phone_pattern.match(value):
        raise ValidationError(
            _('Numéro de téléphone invalide. Format attendu: +221 77 123 45 67 ou 771234567')
        )

def validate_role(value):
    """
    Valide le rôle d'utilisateur
    """
    valid_roles = ['admin', 'agronome', 'agriculteur']
    if value not in valid_roles:
        raise ValidationError(
            _('Rôle invalide. Les rôles valides sont: %(roles)s') % 
            {'roles': ', '.join(valid_roles)}
        )

def validate_culture_type(value):
    """
    Valide le type de culture
    """
    if not value or len(value.strip()) < 2:
        raise ValidationError(_('Le type de culture est requis et doit contenir au moins 2 caractères'))
    
    # Liste des cultures communes au Sénégal (peut être étendue)
    common_cultures = [
        'mil', 'maïs', 'sorgho', 'riz', 'arachide', 'niébé', 'tomate', 'oignon',
        'piment', 'carotte', 'chou', 'pastèque', 'mangue', 'orange', 'banane',
        'coton', 'sésame', 'gombo', 'aubergine', 'courge', 'patate douce'
    ]
    
    culture_lower = value.lower().strip()
    if culture_lower not in common_cultures:
        # Ne pas bloquer si ce n'est pas une culture commune, mais avertir
        pass  # Pourrait logger un avertissement ici

def validate_coordinates(lat, lon):
    """
    Valide les coordonnées GPS
    """
    try:
        latitude = float(lat)
        longitude = float(lon)
        
        if not (-90 <= latitude <= 90):
            raise ValidationError(_('La latitude doit être entre -90 et 90 degrés'))
        if not (-180 <= longitude <= 180):
            raise ValidationError(_('La longitude doit être entre -180 et 180 degrés'))
            
        # Vérifier si les coordonnées sont dans une zone plausible (Sénégal/Afrique de l'Ouest)
        if not (10 <= latitude <= 30) or not (-20 <= longitude <= 20):
            # Avertissement mais pas d'erreur bloquante
            pass
            
        return True
    except (ValueError, TypeError):
        raise ValidationError(_('Coordonnées GPS invalides'))

def validate_image_file(file):
    """
    Valide un fichier image
    """
    # Vérifier la taille (max 10MB)
    max_size = 10 * 1024 * 1024  # 10MB
    if file.size > max_size:
        raise ValidationError(_('L\'image ne doit pas dépasser 10MB'))
    
    # Vérifier le type MIME
    allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
    if file.content_type not in allowed_types:
        raise ValidationError(
            _('Format d\'image non supporté. Utilisez JPEG, PNG ou WebP')
        )
    
    # Vérifier l'extension
    allowed_extensions = ['.jpg', '.jpeg', '.png', '.webp']
    file_extension = file.name.lower().split('.')[-1]
    if f'.{file_extension}' not in allowed_extensions:
        raise ValidationError(
            _('Extension de fichier non supportée. Utilisez .jpg, .jpeg, .png ou .webp')
        )

def validate_audio_file(file):
    """
    Valide un fichier audio
    """
    # Vérifier la taille (max 25MB)
    max_size = 25 * 1024 * 1024  # 25MB
    if file.size > max_size:
        raise ValidationError(_('Le fichier audio ne doit pas dépasser 25MB'))
    
    # Vérifier le type MIME
    allowed_types = [
        'audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/ogg', 
        'audio/m4a', 'audio/mp4', 'audio/x-m4a'
    ]
    if file.content_type not in allowed_types:
        raise ValidationError(
            _('Format audio non supporté. Utilisez MP3, WAV, OGG ou M4A')
        )
    
    # Vérifier l'extension
    allowed_extensions = ['.mp3', '.wav', '.ogg', '.m4a', '.mp4']
    file_extension = file.name.lower().split('.')[-1]
    if f'.{file_extension}' not in allowed_extensions:
        raise ValidationError(
            _('Extension de fichier non supportée. Utilisez .mp3, .wav, .ogg ou .m4a')
        )

# Validateurs regex pour les modèles Django
phone_validator = RegexValidator(
    regex=r'^(\+?[0-9]{1,3}[-.\s]?)?\(?[0-9]{1,4}\)?[-.\s]?[0-9]{1,4}[-.\s]?[0-9]{1,9}$',
    message=_('Numéro de téléphone invalide'),
    code='invalid_phone'
)

role_validator = RegexValidator(
    regex=r'^(admin|agronome|agriculteur)$',
    message=_('Rôle invalide. Choisissez parmi: admin, agronome, agriculteur'),
    code='invalid_role'
)
