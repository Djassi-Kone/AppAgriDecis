"""
Serializers pour le module IA
"""
from rest_framework import serializers
from .models import DiagnosisRequest, ChatMessage, ChatSession

class DiagnosisRequestSerializer(serializers.ModelSerializer):
    """
    Serializer pour les requêtes de diagnostic
    """
    image_url = serializers.ImageField(source='image', read_only=True)
    user_info = serializers.SerializerMethodField()
    
    class Meta:
        model = DiagnosisRequest
        fields = [
            'id', 'user', 'user_info', 'image', 'image_url', 'culture', 
            'status', 'result_json', 'confidence', 'detected_disease',
            'created_at', 'updated_at', 'processed_at'
        ]
        read_only_fields = [
            'id', 'user', 'status', 'result_json', 'confidence', 
            'detected_disease', 'created_at', 'updated_at', 'processed_at'
        ]
    
    def get_user_info(self, obj):
        return {
            'id': obj.user.id,
            'email': obj.user.email,
            'nom': obj.user.nom,
            'prenom': obj.user.prenom,
            'role': obj.user.role
        }
    
    def validate_culture(self, value):
        """Validation du type de culture"""
        if not value or len(value.strip()) < 2:
            raise serializers.ValidationError("Le type de culture est requis")
        return value.strip()

class DiagnosisCreateSerializer(serializers.ModelSerializer):
    """
    Serializer pour la création d'une requête de diagnostic
    """
    class Meta:
        model = DiagnosisRequest
        fields = ['image', 'culture']
    
    def validate_image(self, value):
        """Validation du fichier image"""
        if not value:
            raise serializers.ValidationError("L'image est requise")
        
        # Vérifier la taille (max 10MB)
        if value.size > 10 * 1024 * 1024:
            raise serializers.ValidationError("L'image ne doit pas dépasser 10MB")
        
        # Vérifier le format
        allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
        if value.content_type not in allowed_types:
            raise serializers.ValidationError(
                "Format d'image non supporté. Utilisez JPEG, PNG ou WebP"
            )
        
        return value

class ChatMessageSerializer(serializers.ModelSerializer):
    """
    Serializer pour les messages de chat
    """
    user_info = serializers.SerializerMethodField()
    
    class Meta:
        model = ChatMessage
        fields = [
            'id', 'user', 'user_info', 'role', 'content', 'audio_file',
            'transcription', 'message_type', 'created_at'
        ]
        read_only_fields = [
            'id', 'user', 'role', 'transcription', 'created_at'
        ]
    
    def get_user_info(self, obj):
        return {
            'id': obj.user.id,
            'email': obj.user.email,
            'nom': obj.user.nom,
            'prenom': obj.user.prenom
        }

class ChatMessageCreateSerializer(serializers.ModelSerializer):
    """
    Serializer pour la création de messages de chat
    """
    class Meta:
        model = ChatMessage
        fields = ['content', 'audio_file', 'message_type']
    
    def validate(self, data):
        """Validation des données du message"""
        message_type = data.get('message_type', 'text')
        
        if message_type == 'text':
            if not data.get('content') or len(data['content'].strip()) < 1:
                raise serializers.ValidationError(
                    "Le contenu du message est requis pour les messages texte"
                )
        elif message_type == 'audio':
            if not data.get('audio_file'):
                raise serializers.ValidationError(
                    "Le fichier audio est requis pour les messages vocaux"
                )
            
            # Vérifier la taille du fichier audio (max 25MB)
            if data['audio_file'].size > 25 * 1024 * 1024:
                raise serializers.ValidationError(
                    "Le fichier audio ne doit pas dépasser 25MB"
                )
        else:
            raise serializers.ValidationError(
                "Type de message non supporté. Utilisez 'text' ou 'audio'"
            )
        
        return data

class ChatSessionSerializer(serializers.ModelSerializer):
    """
    Serializer pour les sessions de chat
    """
    user_info = serializers.SerializerMethodField()
    messages = ChatMessageSerializer(many=True, read_only=True)
    message_count = serializers.SerializerMethodField()
    
    class Meta:
        model = ChatSession
        fields = [
            'id', 'user', 'user_info', 'title', 'messages', 'message_count',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'updated_at']
    
    def get_user_info(self, obj):
        return {
            'id': obj.user.id,
            'email': obj.user.email,
            'nom': obj.user.nom,
            'prenom': obj.user.prenom,
            'role': obj.user.role
        }
    
    def get_message_count(self, obj):
        return obj.messages.count()

class ChatSessionCreateSerializer(serializers.ModelSerializer):
    """
    Serializer pour la création de sessions de chat
    """
    first_message = serializers.CharField(write_only=True, required=False)
    
    class Meta:
        model = ChatSession
        fields = ['title', 'first_message']
    
    def create(self, validated_data):
        """Crée une session avec le premier message si fourni"""
        first_message_content = validated_data.pop('first_message', None)
        user = self.context['request'].user
        
        # Créer la session
        session = ChatSession.objects.create(user=user, **validated_data)
        
        # Ajouter le premier message si fourni
        if first_message_content:
            message = ChatMessage.objects.create(
                user=user,
                role='user',
                content=first_message_content,
                message_type='text'
            )
            session.messages.add(message)
        
        return session
