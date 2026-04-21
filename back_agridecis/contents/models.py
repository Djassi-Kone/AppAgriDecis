"""
Modèles pour le module de gestion des contenus
"""
from django.db import models
from django.utils import timezone
from django.conf import settings
from back_agridecis.validators import validate_image_file, validate_audio_file

class Content(models.Model):
    """
    Modèle principal pour les contenus publiés par les agronomes
    """
    CONTENT_TYPES = [
        ('text', 'Texte'),
        ('image', 'Image'),
        ('video', 'Vidéo'),
        ('audio', 'Audio'),
    ]
    
    STATUS_CHOICES = [
        ('draft', 'Brouillon'),
        ('published', 'Publié'),
        ('archived', 'Archivé'),
    ]
    
    title = models.CharField(max_length=255, verbose_name="Titre")
    description = models.TextField(verbose_name="Description")
    content_type = models.CharField(
        max_length=10,
        choices=CONTENT_TYPES,
        verbose_name="Type de contenu"
    )
    
    # Fichiers média
    image_file = models.ImageField(
        upload_to='contents/images/',
        blank=True,
        null=True,
        validators=[validate_image_file],
        verbose_name="Fichier image"
    )
    video_file = models.FileField(
        upload_to='contents/videos/',
        blank=True,
        null=True,
        verbose_name="Fichier vidéo"
    )
    audio_file = models.FileField(
        upload_to='contents/audios/',
        blank=True,
        null=True,
        validators=[validate_audio_file],
        verbose_name="Fichier audio"
    )
    
    # Métadonnées
    status = models.CharField(
        max_length=10,
        choices=STATUS_CHOICES,
        default='draft',
        verbose_name="Statut"
    )
    tags = models.CharField(
        max_length=500,
        blank=True,
        help_text="Tags séparés par des virgules",
        verbose_name="Tags"
    )
    category = models.CharField(
        max_length=100,
        blank=True,
        help_text="Catégorie du contenu (ex: culture, irrigation, maladies)",
        verbose_name="Catégorie"
    )
    
    # Relations
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='contents',
        verbose_name="Auteur"
    )
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Date de création")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Date de modification")
    published_at = models.DateTimeField(
        blank=True,
        null=True,
        verbose_name="Date de publication"
    )
    
    class Meta:
        verbose_name = "Contenu"
        verbose_name_plural = "Contenus"
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - {self.author.email}"
    
    @property
    def likes_count(self):
        """Retourne le nombre de likes"""
        return self.likes.filter(is_active=True).count()
    
    @property
    def comments_count(self):
        """Retourne le nombre de commentaires"""
        return self.comments.filter(is_active=True).count()
    
    def get_tags_list(self):
        """Retourne les tags sous forme de liste"""
        return [tag.strip() for tag in self.tags.split(',') if tag.strip()]
    
    def get_file_url(self):
        """Retourne l'URL du fichier principal"""
        if self.content_type == 'image' and self.image_file:
            return self.image_file.url
        elif self.content_type == 'video' and self.video_file:
            return self.video_file.url
        elif self.content_type == 'audio' and self.audio_file:
            return self.audio_file.url
        return None
    
    def save(self, *args, **kwargs):
        """Surcharge pour gérer la date de publication"""
        if self.status == 'published' and not self.published_at:
            self.published_at = timezone.now()
        super().save(*args, **kwargs)


class ContentLike(models.Model):
    """
    Modèle pour les likes sur les contenus
    """
    content = models.ForeignKey(
        Content,
        on_delete=models.CASCADE,
        related_name='likes'
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='content_likes'
    )
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['content', 'user']
        verbose_name = "Like"
        verbose_name_plural = "Likes"
    
    def __str__(self):
        return f"{self.user.email} likes {self.content.title}"


class ContentComment(models.Model):
    """
    Modèle pour les commentaires sur les contenus
    """
    content = models.ForeignKey(
        Content,
        on_delete=models.CASCADE,
        related_name='comments'
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='content_comments'
    )
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        related_name='replies'
    )
    text = models.TextField(verbose_name="Texte du commentaire")
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "Commentaire"
        verbose_name_plural = "Commentaires"
        ordering = ['created_at']
    
    def __str__(self):
        return f"Commentaire de {self.user.email} sur {self.content.title}"
    
    @property
    def replies_count(self):
        """Retourne le nombre de réponses"""
        return self.replies.filter(is_active=True).count()


class ContentView(models.Model):
    """
    Modèle pour suivre les vues des contenus
    """
    content = models.ForeignKey(
        Content,
        on_delete=models.CASCADE,
        related_name='views'
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='content_views',
        blank=True,
        null=True
    )
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True)
    viewed_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name = "Vue"
        verbose_name_plural = "Vues"
    
    def __str__(self):
        user_info = self.user.email if self.user else f"IP: {self.ip_address}"
        return f"Vue de {user_info} sur {self.content.title}"
