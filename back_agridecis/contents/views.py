"""
Views pour le module de gestion des contenus
"""
from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from django.shortcuts import get_object_or_404
from django.utils import timezone
from django.db.models import Q, Count
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import filters

from back_agridecis.utils import format_api_response, format_api_error
from back_agridecis.exceptions import ValidationException, AuthorizationException
from users.permissions import IsAgronome, IsAgriculteur, IsAdminUserRole
from users.models import User

from .models import Content, ContentLike, ContentComment, ContentView
from .serializers import (
    ContentSerializer, ContentCreateSerializer, ContentUpdateSerializer,
    ContentListSerializer, CommentSerializer, CommentCreateSerializer,
    LikeSerializer, ContentAnalyticsSerializer
)


class ContentListCreateView(generics.ListCreateAPIView):
    """
    Vue pour lister et créer des contenus
    """
    parser_classes = [MultiPartParser, FormParser]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['content_type', 'category', 'status', 'author']
    search_fields = ['title', 'description', 'tags', 'category']
    ordering_fields = ['created_at', 'published_at', 'likes_count', 'comments_count']
    ordering = ['-created_at']
    
    def get_permissions(self):
        """Permissions selon la méthode"""
        if self.request.method == 'GET':
            # Lecture publique pour les contenus publiés
            return []
        else:
            # Création réservée aux agronomes
            return [permissions.IsAuthenticated(), IsAgronome()]
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return ContentCreateSerializer
        return ContentListSerializer
    
    def get_queryset(self):
        """Filtre les contenus selon le rôle de l'utilisateur"""
        user = self.request.user
        
        # Public: seulement les contenus publiés
        if not user.is_authenticated:
            queryset = Content.objects.filter(status='published')
        else:
            # Utilisateur authentifié
            if user.role == 'agronome':
                # Agronome: voir ses contenus + contenus publiés
                queryset = Content.objects.filter(
                    Q(status='published') | Q(author=user)
                )
            else:
                # Agriculteur et autres: seulement les contenus publiés
                queryset = Content.objects.filter(status='published')
        
        return queryset.select_related('author').prefetch_related('likes', 'comments')
    
    def perform_create(self, serializer):
        """Crée un contenu avec l'utilisateur courant comme auteur"""
        user = self.request.user
        
        # Vérifier que l'utilisateur est un agronome
        if user.role != 'agronome':
            raise AuthorizationException("Seuls les agronomes peuvent créer des contenus")
        
        serializer.save(author=user)


class MyContentView(generics.ListAPIView):
    """
    Vue pour voir les contenus de l'utilisateur (agronome)
    """
    permission_classes = [permissions.IsAuthenticated, IsAgronome]
    serializer_class = ContentSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['content_type', 'category', 'status']
    search_fields = ['title', 'description', 'tags', 'category']
    ordering_fields = ['created_at', 'published_at', 'likes_count', 'comments_count']
    ordering = ['-created_at']
    
    def get_queryset(self):
        return Content.objects.filter(
            author=self.request.user
        ).select_related('author').prefetch_related('likes', 'comments')


class ContentDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    Vue pour voir, modifier et supprimer un contenu
    """
    serializer_class = ContentSerializer
    
    def get_queryset(self):
        """Filtre selon le rôle et permissions"""
        user = self.request.user
        content_id = self.kwargs.get('pk')
        
        # Contenu publié ou contenu de l'utilisateur
        if user.is_authenticated:
            return Content.objects.filter(
                Q(id=content_id) & (
                    Q(status='published') | 
                    Q(author=user)
                )
            ).select_related('author').prefetch_related('likes', 'comments')
        else:
            return Content.objects.filter(
                id=content_id,
                status='published'
            ).select_related('author').prefetch_related('likes', 'comments')
    
    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return ContentUpdateSerializer
        return ContentSerializer
    
    def perform_update(self, serializer):
        """Vérifie les permissions de modification"""
        user = self.request.user
        content = self.get_object()
        
        # Seul l'auteur peut modifier
        if content.author != user:
            raise AuthorizationException("Seul l'auteur peut modifier ce contenu")
        
        serializer.save()
    
    def perform_destroy(self, instance):
        """Vérifie les permissions de suppression"""
        user = self.request.user
        
        # L'auteur peut supprimer, l'admin peut supprimer
        if instance.author != user and user.role != 'admin':
            raise AuthorizationException("Seul l'auteur ou un admin peut supprimer ce contenu")
        
        instance.delete()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated, IsAgronome])
def my_content_analytics(request):
    """
    Vue pour les analytics des contenus de l'agronome
    """
    contents = Content.objects.filter(author=request.user).annotate(
        views_count=Count('views'),
        likes_count=Count('likes', filter=Q(likes__is_active=True)),
        comments_count=Count('comments', filter=Q(comments__is_active=True))
    ).order_by('-created_at')
    
    serializer = ContentAnalyticsSerializer(contents, many=True)
    
    # Statistiques globales
    total_views = sum(c.views_count for c in contents)
    total_likes = sum(c.likes_count for c in contents)
    total_comments = sum(c.comments_count for c in contents)
    
    return format_api_response({
        'contents': serializer.data,
        'stats': {
            'total_contents': contents.count(),
            'published_contents': contents.filter(status='published').count(),
            'total_views': total_views,
            'total_likes': total_likes,
            'total_comments': total_comments,
            'avg_engagement_rate': round(
                sum((c.likes_count + c.comments_count) / max(c.views_count, 1) * 100 for c in contents) / max(contents.count(), 1), 2
            )
        }
    }, "Analytics récupérées avec succès")


class CommentListCreateView(generics.ListCreateAPIView):
    """
    Vue pour lister et créer des commentaires
    """
    permission_classes = [permissions.IsAuthenticated]
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return CommentCreateSerializer
        return CommentSerializer
    
    def get_queryset(self):
        """Retourne les commentaires d'un contenu"""
        content_id = self.kwargs.get('content_id')
        return ContentComment.objects.filter(
            content_id=content_id,
            parent=None,  # Seulement les commentaires principaux
            is_active=True
        ).select_related('user', 'parent').prefetch_related('replies')
    
    def perform_create(self, serializer):
        """Crée un commentaire"""
        user = self.request.user
        content_id = self.kwargs.get('content_id')
        
        # Vérifier que le contenu existe et est publié
        try:
            content = Content.objects.get(id=content_id, status='published')
        except Content.DoesNotExist:
            raise ValidationException("Contenu non trouvé")
        
        # Vérifier que l'utilisateur est un agriculteur
        if user.role != 'agriculteur':
            raise AuthorizationException("Seuls les agriculteurs peuvent commenter")
        
        serializer.save(user=user, content=content)


class CommentDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    Vue pour modifier et supprimer un commentaire
    """
    serializer_class = CommentSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return ContentComment.objects.filter(is_active=True).select_related('user')
    
    def perform_update(self, serializer):
        """Vérifie les permissions de modification"""
        comment = self.get_object()
        user = self.request.user
        
        if comment.user != user:
            raise AuthorizationException("Seul l'auteur peut modifier ce commentaire")
        
        serializer.save()
    
    def perform_destroy(self, instance):
        """Vérifie les permissions de suppression"""
        user = self.request.user
        
        # L'auteur ou l'auteur du contenu peuvent supprimer
        if instance.user != user and instance.content.author != user and user.role != 'admin':
            raise AuthorizationException("Permission insuffisante")
        
        instance.is_active = False
        instance.save()


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated, IsAgriculteur])
def toggle_content_like(request, content_id):
    """
    Vue pour liker/unliker un contenu
    """
    try:
        content = get_object_or_404(Content, id=content_id, status='published')
        user = request.user
        
        # Vérifier si l'utilisateur a déjà liké
        like, created = ContentLike.objects.get_or_create(
            content=content,
            user=user,
            defaults={'is_active': True}
        )
        
        if not created:
            # Toggle le like
            like.is_active = not like.is_active
            like.save()
            action = "liké" if like.is_active else "unliké"
        else:
            action = "liké"
        
        return format_api_response({
            'is_liked': like.is_active,
            'likes_count': content.likes_count,
            'action': action
        }, f"Contenu {action} avec succès")
        
    except Content.DoesNotExist:
        raise ValidationException("Contenu non trouvé")


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def track_content_view(request, content_id):
    """
    Vue pour suivre les vues des contenus
    """
    try:
        content = get_object_or_404(Content, id=content_id, status='published')
        
        # Créer une vue
        view_data = {
            'content': content,
            'ip_address': request.META.get('REMOTE_ADDR'),
            'user_agent': request.META.get('HTTP_USER_AGENT', '')
        }
        
        if request.user.is_authenticated:
            view_data['user'] = request.user
        
        # Vérifier si l'utilisateur a déjà vu ce contenu récemment
        recent_view = ContentView.objects.filter(
            content=content,
            user=request.user if request.user.is_authenticated else None,
            ip_address=view_data['ip_address'],
            viewed_at__gte=timezone.now() - timezone.timedelta(hours=1)
        ).first()
        
        if not recent_view:
            ContentView.objects.create(**view_data)
        
        return format_api_response({
            'views_count': content.views.count()
        }, "Vue enregistrée")
        
    except Content.DoesNotExist:
        raise ValidationException("Contenu non trouvé")


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated, IsAdminUserRole])
def admin_content_list(request):
    """
    Vue pour les admins : lister tous les contenus
    """
    contents = Content.objects.all().select_related('author').prefetch_related('likes', 'comments')
    
    # Filtrage
    status_filter = request.GET.get('status')
    if status_filter:
        contents = contents.filter(status=status_filter)
    
    author_filter = request.GET.get('author')
    if author_filter:
        contents = contents.filter(author__email__icontains=author_filter)
    
    serializer = ContentListSerializer(contents, many=True)
    return format_api_response(serializer.data, "Contenus récupérés avec succès")


@api_view(['DELETE'])
@permission_classes([permissions.IsAuthenticated, IsAdminUserRole])
def admin_delete_content(request, content_id):
    """
    Vue pour les admins : supprimer un contenu
    """
    try:
        content = get_object_or_404(Content, id=content_id)
        content.delete()
        
        return format_api_response(None, "Contenu supprimé avec succès")
        
    except Content.DoesNotExist:
        raise ValidationException("Contenu non trouvé")
