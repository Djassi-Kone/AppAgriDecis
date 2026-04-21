"""
Modèles pour le module IA
"""
from django.db import models
from django.conf import settings
from back_agridecis.validators import validate_image_file, validate_audio_file, validate_culture_type

class DiagnosisRequest(models.Model):
    """
    Requête de diagnostic IA pour les plantes
    """
    STATUS_CHOICES = [
        ('pending', 'En attente'),
        ('processing', 'En cours'),
        ('completed', 'Terminé'),
        ('failed', 'Échoué'),
    ]
    
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='diagnosis_requests'
    )
    image = models.ImageField(
        upload_to='diagnosis_images/',
        validators=[validate_image_file]
    )
    culture = models.CharField(
        max_length=255, 
        help_text="Type de culture (ex: tomate, maïs)",
        validators=[validate_culture_type]
    )
    
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending'
    )
    
    # Résultats de l'IA
    result_json = models.JSONField(default=dict, blank=True, null=True)
    confidence = models.FloatField(null=True, blank=True)
    detected_disease = models.CharField(max_length=255, blank=True, null=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    processed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = "Requête de diagnostic"
        verbose_name_plural = "Requêtes de diagnostic"
    
    def __str__(self):
        return f"Diagnostic {self.id} - {self.user.email} - {self.culture}"

class ChatMessage(models.Model):
    """
    Messages du chat IA pour conseils agricoles
    """
    ROLE_CHOICES = [
        ('user', 'Utilisateur'),
        ('assistant', 'Assistant IA'),
    ]
    
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='chat_messages'
    )
    
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    content = models.TextField()
    
    # Pour les messages vocaux
    audio_file = models.FileField(
        upload_to='chat_audio/',
        blank=True,
        null=True,
        validators=[validate_audio_file],
        help_text="Fichier audio pour les messages vocaux"
    )
    transcription = models.TextField(
        blank=True,
        null=True,
        help_text="Transcription du message audio"
    )
    
    # Métadonnées
    message_type = models.CharField(
        max_length=20,
        default='text',
        help_text="Type de message: text, audio"
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['created_at']
        verbose_name = "Message de chat"
        verbose_name_plural = "Messages de chat"
    
    def __str__(self):
        return f"{self.role}: {self.content[:50]}..."

class ChatSession(models.Model):
    """
    Session de chat pour regrouper les conversations
    """
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='chat_sessions'
    )
    
    title = models.CharField(max_length=255, default="Nouvelle conversation")
    messages = models.ManyToManyField(ChatMessage, related_name='sessions')
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
        verbose_name = "Session de chat"
        verbose_name_plural = "Sessions de chat"
    
    def __str__(self):
        return f"Session {self.id} - {self.user.email} - {self.title}"
