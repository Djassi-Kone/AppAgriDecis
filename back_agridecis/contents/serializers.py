"""
Serializers pour le module de gestion des contenus
"""
from rest_framework import serializers
from django.utils import timezone
from .models import Content, ContentLike, ContentComment, ContentView


class ContentSerializer(serializers.ModelSerializer):
    """
    Serializer principal pour les contenus
    """
    author_name = serializers.SerializerMethodField()
    author_email = serializers.CharField(source='author.email', read_only=True)
    author_role = serializers.CharField(source='author.role', read_only=True)
    likes_count = serializers.ReadOnlyField()
    comments_count = serializers.ReadOnlyField()
    file_url = serializers.SerializerMethodField()
    tags_list = serializers.SerializerMethodField()
    is_liked_by_user = serializers.SerializerMethodField()
    created_at_formatted = serializers.SerializerMethodField()
    
    class Meta:
        model = Content
        fields = [
            'id', 'title', 'description', 'content_type', 'status',
            'image_file', 'video_file', 'audio_file', 'file_url',
            'tags', 'tags_list', 'category', 'author', 'author_name',
            'author_email', 'author_role', 'likes_count', 'comments_count',
            'is_liked_by_user', 'created_at', 'updated_at', 'published_at',
            'created_at_formatted'
        ]
        read_only_fields = [
            'author', 'likes_count', 'comments_count', 'is_liked_by_user',
            'created_at', 'updated_at', 'published_at'
        ]
    
    def get_author_name(self, obj):
        """Retourne le nom de l'auteur"""
        author = obj.author
        if hasattr(author, 'get_full_name'):
            return author.get_full_name()
        elif hasattr(author, 'nom') and hasattr(author, 'prenom'):
            return f"{author.prenom} {author.nom}".strip()
        else:
            return author.email
    
    def get_tags_list(self, obj):
        """Retourne les tags sous forme de liste"""
        if obj.tags:
            return [tag.strip() for tag in obj.tags.split(',') if tag.strip()]
        return []
    
    def get_is_liked_by_user(self, obj):
        """Vérifie si l'utilisateur courant a liké le contenu"""
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.likes.filter(user=request.user, is_active=True).exists()
        return False
    
    def get_created_at_formatted(self, obj):
        """Formate la date de création"""
        return obj.created_at.strftime('%d/%m/%Y %H:%M')
    
    def get_file_url(self, obj):
        """Retourne l'URL du fichier principal"""
        if hasattr(obj, 'get_file_url'):
            return obj.get_file_url()
        return None


class ContentCreateSerializer(serializers.ModelSerializer):
    """
    Serializer pour la création de contenus
    """
    class Meta:
        model = Content
        fields = [
            'title', 'description', 'content_type', 'image_file',
            'video_file', 'audio_file', 'tags', 'category'
        ]
    
    def validate(self, data):
        """Validation des données de contenu"""
        content_type = data.get('content_type')
        
        # Vérifier que le fichier correspond au type de contenu
        if content_type == 'image' and not data.get('image_file'):
            raise serializers.ValidationError(
                {"image_file": "Un fichier image est requis pour ce type de contenu"}
            )
        elif content_type == 'video' and not data.get('video_file'):
            raise serializers.ValidationError(
                {"video_file": "Un fichier vidéo est requis pour ce type de contenu"}
            )
        elif content_type == 'audio' and not data.get('audio_file'):
            raise serializers.ValidationError(
                {"audio_file": "Un fichier audio est requis pour ce type de contenu"}
            )
        elif content_type == 'text' and not data.get('description'):
            raise serializers.ValidationError(
                {"description": "Une description est requise pour le contenu texte"}
            )
        
        return data
    
    def validate_title(self, value):
        """Validation du titre"""
        if len(value.strip()) < 3:
            raise serializers.ValidationError("Le titre doit contenir au moins 3 caractères")
        return value.strip()
    
    def validate_description(self, value):
        """Validation de la description"""
        if len(value.strip()) < 10:
            raise serializers.ValidationError("La description doit contenir au moins 10 caractères")
        return value.strip()


class ContentUpdateSerializer(serializers.ModelSerializer):
    """
    Serializer pour la mise à jour de contenus
    """
    class Meta:
        model = Content
        fields = [
            'title', 'description', 'status', 'tags', 'category',
            'image_file', 'video_file', 'audio_file'
        ]


class ContentListSerializer(serializers.ModelSerializer):
    """
    Serializer pour la liste des contenus (version allégée)
    """
    author_name = serializers.CharField(source='author.get_full_name', read_only=True)
    author_role = serializers.CharField(source='author.role', read_only=True)
    likes_count = serializers.ReadOnlyField()
    comments_count = serializers.ReadOnlyField()
    views_count = serializers.SerializerMethodField()
    created_at_formatted = serializers.SerializerMethodField()
    
    class Meta:
        model = Content
        fields = [
            'id', 'title', 'description', 'content_type', 'category',
            'author_name', 'author_role', 'likes_count', 'comments_count',
            'views_count', 'created_at_formatted', 'published_at'
        ]
    
    def get_views_count(self, obj):
        """Retourne le nombre de vues"""
        return obj.views.count()
    
    def get_created_at_formatted(self, obj):
        """Formate la date de création"""
        return obj.created_at.strftime('%d/%m/%Y %H:%M')


class CommentSerializer(serializers.ModelSerializer):
    """
    Serializer pour les commentaires
    """
    author_name = serializers.CharField(source='user.get_full_name', read_only=True)
    author_email = serializers.CharField(source='user.email', read_only=True)
    author_role = serializers.CharField(source='user.role', read_only=True)
    replies_count = serializers.ReadOnlyField()
    created_at_formatted = serializers.SerializerMethodField()
    
    class Meta:
        model = ContentComment
        fields = [
            'id', 'text', 'parent', 'content', 'user', 'author_name',
            'author_email', 'author_role', 'replies_count', 'created_at',
            'updated_at', 'created_at_formatted'
        ]
        read_only_fields = ['user', 'created_at', 'updated_at']
    
    def get_created_at_formatted(self, obj):
        """Formate la date de création"""
        return obj.created_at.strftime('%d/%m/%Y %H:%M')
    
    def validate_text(self, value):
        """Validation du texte du commentaire"""
        if len(value.strip()) < 3:
            raise serializers.ValidationError("Le commentaire doit contenir au moins 3 caractères")
        return value.strip()


class CommentCreateSerializer(serializers.ModelSerializer):
    """
    Serializer pour la création de commentaires
    """
    class Meta:
        model = ContentComment
        fields = ['text', 'parent']
    
    def validate_text(self, value):
        """Validation du texte du commentaire"""
        if len(value.strip()) < 3:
            raise serializers.ValidationError("Le commentaire doit contenir au moins 3 caractères")
        return value.strip()


class LikeSerializer(serializers.ModelSerializer):
    """
    Serializer pour les likes
    """
    class Meta:
        model = ContentLike
        fields = ['content', 'is_active']
        read_only_fields = ['user', 'created_at']


class ContentAnalyticsSerializer(serializers.ModelSerializer):
    """
    Serializer pour les analytics des contenus (pour l'auteur)
    """
    views_count = serializers.SerializerMethodField()
    likes_count = serializers.SerializerMethodField()
    comments_count = serializers.SerializerMethodField()
    engagement_rate = serializers.SerializerMethodField()
    
    class Meta:
        model = Content
        fields = [
            'id', 'title', 'status', 'views_count', 'likes_count',
            'comments_count', 'engagement_rate', 'created_at', 'published_at'
        ]
    
    def get_views_count(self, obj):
        return obj.views.count()
    
    def get_likes_count(self, obj):
        return obj.likes.filter(is_active=True).count()
    
    def get_comments_count(self, obj):
        return obj.comments.filter(is_active=True).count()
    
    def get_engagement_rate(self, obj):
        """Calcule le taux d'engagement"""
        views = obj.views.count()
        if views == 0:
            return 0
        interactions = obj.likes.filter(is_active=True).count() + obj.comments.filter(is_active=True).count()
        return round((interactions / views) * 100, 2)
