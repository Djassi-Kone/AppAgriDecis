"""
Configuration admin pour le module IA
"""
from django.contrib import admin
from .models import DiagnosisRequest, ChatMessage, ChatSession

@admin.register(DiagnosisRequest)
class DiagnosisRequestAdmin(admin.ModelAdmin):
    """
    Administration pour les requêtes de diagnostic
    """
    list_display = [
        'id', 'user', 'culture', 'status', 'detected_disease', 
        'confidence', 'created_at', 'processed_at'
    ]
    list_filter = [
        'status', 'culture', 'detected_disease', 'created_at'
    ]
    search_fields = [
        'user__email', 'user__nom', 'user__prenom', 'culture', 'detected_disease'
    ]
    readonly_fields = [
        'id', 'created_at', 'updated_at', 'processed_at', 'result_json'
    ]
    
    fieldsets = (
        ('Informations générales', {
            'fields': ('user', 'image', 'culture', 'status')
        }),
        ('Résultats IA', {
            'fields': ('detected_disease', 'confidence', 'result_json')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at', 'processed_at'),
            'classes': ('collapse',)
        })
    )
    
    def has_add_permission(self, request):
        return False  # Les diagnostics sont créés via l'API
    
    def has_change_permission(self, request, obj=None):
        # Permet de changer le statut manuellement si nécessaire
        return request.user.is_superuser

@admin.register(ChatSession)
class ChatSessionAdmin(admin.ModelAdmin):
    """
    Administration pour les sessions de chat
    """
    list_display = [
        'id', 'user', 'title', 'message_count', 'created_at', 'updated_at'
    ]
    list_filter = ['created_at', 'updated_at']
    search_fields = [
        'user__email', 'user__nom', 'user__prenom', 'title'
    ]
    readonly_fields = ['id', 'created_at', 'updated_at']
    
    def message_count(self, obj):
        return obj.messages.count()
    message_count.short_description = 'Nombre de messages'
    
    fieldsets = (
        ('Informations générales', {
            'fields': ('user', 'title')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )

@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    """
    Administration pour les messages de chat
    """
    list_display = [
        'id', 'user', 'role', 'message_type', 'content_preview', 
        'has_audio', 'created_at'
    ]
    list_filter = ['role', 'message_type', 'created_at']
    search_fields = [
        'user__email', 'user__nom', 'user__prenom', 'content'
    ]
    readonly_fields = [
        'id', 'created_at'
    ]
    
    fieldsets = (
        ('Informations générales', {
            'fields': ('user', 'role', 'message_type')
        }),
        ('Contenu', {
            'fields': ('content', 'audio_file', 'transcription')
        }),
        ('Timestamps', {
            'fields': ('created_at',),
            'classes': ('collapse',)
        })
    )
    
    def content_preview(self, obj):
        return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content
    content_preview.short_description = 'Aperçu du contenu'
    
    def has_audio(self, obj):
        return bool(obj.audio_file)
    has_audio.boolean = True
    has_audio.short_description = 'Audio'
    
    def has_add_permission(self, request):
        return False  # Les messages sont créés via l'API
