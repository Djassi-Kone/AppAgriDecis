"""
Configuration admin pour le module de gestion des contenus
"""
from django.contrib import admin
from .models import Content, ContentLike, ContentComment, ContentView


@admin.register(Content)
class ContentAdmin(admin.ModelAdmin):
    """
    Administration pour les contenus
    """
    list_display = [
        'title', 'author', 'content_type', 'status', 'category',
        'likes_count', 'comments_count', 'views_count', 'created_at'
    ]
    list_filter = [
        'content_type', 'status', 'category', 'created_at', 'author__role'
    ]
    search_fields = [
        'title', 'description', 'tags', 'author__email', 'author__nom', 'author__prenom'
    ]
    readonly_fields = [
        'created_at', 'updated_at', 'published_at', 'likes_count', 
        'comments_count', 'views_count'
    ]
    
    fieldsets = (
        ('Informations générales', {
            'fields': ('title', 'description', 'content_type', 'status', 'category')
        }),
        ('Fichiers média', {
            'fields': ('image_file', 'video_file', 'audio_file')
        }),
        ('Métadonnées', {
            'fields': ('author', 'tags')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at', 'published_at'),
            'classes': ('collapse',)
        }),
        ('Statistiques', {
            'fields': ('likes_count', 'comments_count', 'views_count'),
            'classes': ('collapse',)
        })
    )
    
    def likes_count(self, obj):
        return obj.likes_count
    likes_count.short_description = 'Likes'
    
    def comments_count(self, obj):
        return obj.comments_count
    comments_count.short_description = 'Commentaires'
    
    def views_count(self, obj):
        return obj.views.count()
    views_count.short_description = 'Vues'
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('author').prefetch_related('likes', 'comments')


@admin.register(ContentLike)
class ContentLikeAdmin(admin.ModelAdmin):
    """
    Administration pour les likes
    """
    list_display = ['content', 'user', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = [
        'content__title', 'user__email', 'user__nom', 'user__prenom'
    ]
    readonly_fields = ['created_at']
    
    fieldsets = (
        ('Informations', {
            'fields': ('content', 'user', 'is_active')
        }),
        ('Timestamps', {
            'fields': ('created_at',),
            'classes': ('collapse',)
        })
    )


@admin.register(ContentComment)
class ContentCommentAdmin(admin.ModelAdmin):
    """
    Administration pour les commentaires
    """
    list_display = [
        'content', 'user', 'parent', 'text_preview', 'is_active', 'created_at'
    ]
    list_filter = ['is_active', 'created_at']
    search_fields = [
        'content__title', 'user__email', 'user__nom', 'user__prenom', 'text'
    ]
    readonly_fields = ['created_at', 'updated_at']
    
    fieldsets = (
        ('Informations', {
            'fields': ('content', 'user', 'parent', 'text', 'is_active')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    
    def text_preview(self, obj):
        return obj.text[:50] + '...' if len(obj.text) > 50 else obj.text
    text_preview.short_description = 'Aperçu du texte'
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('content', 'user', 'parent')


@admin.register(ContentView)
class ContentViewAdmin(admin.ModelAdmin):
    """
    Administration pour les vues
    """
    list_display = ['content', 'user', 'ip_address', 'viewed_at']
    list_filter = ['viewed_at']
    search_fields = [
        'content__title', 'user__email', 'ip_address'
    ]
    readonly_fields = ['content', 'user', 'ip_address', 'user_agent', 'viewed_at']
    
    def has_add_permission(self, request):
        return False  # Les vues sont créées automatiquement
    
    def has_change_permission(self, request, obj=None):
        return False  # Les vues ne sont pas modifiables
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('content', 'user')
