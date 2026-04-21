"""
Views pour le module IA
"""
import logging
from rest_framework import status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.parsers import MultiPartParser, FormParser
from django.shortcuts import get_object_or_404
from django.utils import timezone

from .models import DiagnosisRequest, ChatMessage, ChatSession
from .serializers import (
    DiagnosisRequestSerializer, DiagnosisCreateSerializer,
    ChatMessageSerializer, ChatMessageCreateSerializer,
    ChatSessionSerializer, ChatSessionCreateSerializer
)
from .services import oxlo_service
from back_agridecis.utils import format_api_response, format_api_error

logger = logging.getLogger(__name__)

class DiagnosisImageView(APIView):
    """
    Vue pour le diagnostic d'images de plantes
    """
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]
    
    def post(self, request):
        """
        Crée une nouvelle requête de diagnostic et traite l'image
        """
        try:
            serializer = DiagnosisCreateSerializer(data=request.data)
            if not serializer.is_valid():
                return format_api_error(
                    "Données invalides",
                    serializer.errors,
                    status.HTTP_400_BAD_REQUEST
                )
            
            # Créer la requête de diagnostic
            diagnosis = DiagnosisRequest.objects.create(
                user=request.user,
                image=serializer.validated_data['image'],
                culture=serializer.validated_data['culture'],
                status='processing'
            )
            
            # Traiter l'image avec l'IA
            result = oxlo_service.detect_plant_disease(diagnosis.image)
            
            if result['success']:
                # Mettre à jour la requête avec les résultats
                detections = result['detections']
                
                if detections:
                    # Prendre la détection avec la plus haute confiance
                    best_detection = max(detections, key=lambda x: x.get('confidence', 0))
                    
                    diagnosis.result_json = result
                    diagnosis.confidence = best_detection.get('confidence', 0)
                    diagnosis.detected_disease = best_detection.get('label', 'Inconnu')
                    diagnosis.status = 'completed'
                else:
                    diagnosis.result_json = result
                    diagnosis.status = 'completed'
                    diagnosis.detected_disease = 'Aucune maladie détectée'
                    diagnosis.confidence = 0.0
                
                diagnosis.processed_at = timezone.now()
                diagnosis.save()
                
                logger.info(f"Diagnosis {diagnosis.id} processed successfully")
                
                return format_api_response(
                    DiagnosisRequestSerializer(diagnosis).data,
                    "Diagnostic réalisé avec succès",
                    status.HTTP_201_CREATED
                )
            else:
                # Marquer comme échoué
                diagnosis.status = 'failed'
                diagnosis.result_json = result
                diagnosis.save()
                
                return format_api_error(
                    "Échec du diagnostic IA",
                    result.get('error', 'Erreur inconnue'),
                    status.HTTP_500_INTERNAL_SERVER_ERROR
                )
                
        except Exception as e:
            logger.error(f"Diagnosis processing failed: {e}")
            return format_api_error(
                "Erreur lors du traitement du diagnostic",
                str(e),
                status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    def get(self, request):
        """
        Liste les diagnostics de l'utilisateur
        """
        try:
            diagnoses = DiagnosisRequest.objects.filter(user=request.user)
            serializer = DiagnosisRequestSerializer(diagnoses, many=True)
            
            return format_api_response(
                serializer.data,
                "Liste des diagnostics récupérée"
            )
            
        except Exception as e:
            logger.error(f"Failed to get diagnoses list: {e}")
            return format_api_error(
                "Erreur lors de la récupération des diagnostics",
                str(e)
            )

class DiagnosisDetailView(APIView):
    """
    Vue pour les détails d'un diagnostic
    """
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request, diagnosis_id):
        """
        Récupère les détails d'un diagnostic spécifique
        """
        try:
            diagnosis = get_object_or_404(
                DiagnosisRequest, 
                id=diagnosis_id, 
                user=request.user
            )
            serializer = DiagnosisRequestSerializer(diagnosis)
            
            return format_api_response(
                serializer.data,
                "Détails du diagnostic récupérés"
            )
            
        except Exception as e:
            logger.error(f"Failed to get diagnosis details: {e}")
            return format_api_error(
                "Erreur lors de la récupération des détails",
                str(e)
            )

class ChatSessionView(APIView):
    """
    Vue pour les sessions de chat IA
    """
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        """
        Liste les sessions de chat de l'utilisateur
        """
        try:
            sessions = ChatSession.objects.filter(user=request.user)
            serializer = ChatSessionSerializer(sessions, many=True)
            
            return format_api_response(
                serializer.data,
                "Liste des sessions de chat récupérée"
            )
            
        except Exception as e:
            logger.error(f"Failed to get chat sessions: {e}")
            return format_api_error(
                "Erreur lors de la récupération des sessions",
                str(e)
            )
    
    def post(self, request):
        """
        Crée une nouvelle session de chat
        """
        try:
            serializer = ChatSessionCreateSerializer(
                data=request.data,
                context={'request': request}
            )
            
            if not serializer.is_valid():
                return format_api_error(
                    "Données invalides",
                    serializer.errors,
                    status.HTTP_400_BAD_REQUEST
                )
            
            session = serializer.save()
            serializer_response = ChatSessionSerializer(session)
            
            return format_api_response(
                serializer_response.data,
                "Session de chat créée avec succès",
                status.HTTP_201_CREATED
            )
            
        except Exception as e:
            logger.error(f"Failed to create chat session: {e}")
            return format_api_error(
                "Erreur lors de la création de la session",
                str(e),
                status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class ChatMessageView(APIView):
    """
    Vue pour les messages de chat IA
    """
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]
    
    def get(self, request, session_id):
        """
        Récupère les messages d'une session
        """
        try:
            session = get_object_or_404(
                ChatSession,
                id=session_id,
                user=request.user
            )
            
            messages = session.messages.all()
            serializer = ChatMessageSerializer(messages, many=True)
            
            return format_api_response(
                serializer.data,
                "Messages de la session récupérés"
            )
            
        except Exception as e:
            logger.error(f"Failed to get chat messages: {e}")
            return format_api_error(
                "Erreur lors de la récupération des messages",
                str(e)
            )
    
    def post(self, request, session_id):
        """
        Ajoute un message à une session et génère une réponse IA
        """
        try:
            session = get_object_or_404(
                ChatSession,
                id=session_id,
                user=request.user
            )
            
            # Créer le message utilisateur
            serializer = ChatMessageCreateSerializer(data=request.data)
            if not serializer.is_valid():
                return format_api_error(
                    "Données invalides",
                    serializer.errors,
                    status.HTTP_400_BAD_REQUEST
                )
            
            message_type = serializer.validated_data.get('message_type', 'text')
            content = serializer.validated_data.get('content', '')
            audio_file = serializer.validated_data.get('audio_file')
            
            # Transcrire l'audio si nécessaire
            if message_type == 'audio' and audio_file:
                transcription_result = oxlo_service.transcribe_audio(audio_file)
                if transcription_result['success']:
                    content = transcription_result['text']
                    transcription = transcription_result['text']
                else:
                    return format_api_error(
                        "Échec de la transcription audio",
                        transcription_result.get('error', 'Erreur inconnue'),
                        status.HTTP_500_INTERNAL_SERVER_ERROR
                    )
            else:
                transcription = None
            
            # Créer le message utilisateur
            user_message = ChatMessage.objects.create(
                user=request.user,
                role='user',
                content=content,
                audio_file=audio_file,
                transcription=transcription,
                message_type=message_type
            )
            session.messages.add(user_message)
            
            # Préparer le contexte pour l'IA
            context = f"Utilisateur: {request.user.email}, Rôle: {request.user.role}"
            if request.user.role == 'agriculteur':
                context += f", Localisation: {request.user.localisation or 'Non spécifiée'}"
                context += f", Culture: {request.user.typeCulture or 'Non spécifiée'}"
            elif request.user.role == 'agronome':
                context += f", Spécialité: {request.user.specialite or 'Non spécifiée'}"
            
            # Générer la réponse IA
            ai_response = oxlo_service.get_agricultural_advice(content, context)
            
            if ai_response['success']:
                # Créer le message assistant
                ai_message = ChatMessage.objects.create(
                    user=request.user,
                    role='assistant',
                    content=ai_response['content'],
                    message_type='text'
                )
                session.messages.add(ai_message)
                
                # Mettre à jour la session
                session.updated_at = timezone.now()
                session.save()
                
                logger.info(f"Chat response generated for session {session_id}")
                
                response_data = {
                    'user_message': ChatMessageSerializer(user_message).data,
                    'ai_response': ChatMessageSerializer(ai_message).data
                }
                
                return format_api_response(
                    response_data,
                    "Message traité avec succès",
                    status.HTTP_201_CREATED
                )
            else:
                return format_api_error(
                    "Échec de la génération de réponse IA",
                    ai_response.get('error', 'Erreur inconnue'),
                    status.HTTP_500_INTERNAL_SERVER_ERROR
                )
                
        except Exception as e:
            logger.error(f"Failed to process chat message: {e}")
            return format_api_error(
                "Erreur lors du traitement du message",
                str(e),
                status.HTTP_500_INTERNAL_SERVER_ERROR
            )

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def chat_history(request):
    """
    Récupère l'historique complet des conversations de l'utilisateur
    """
    try:
        sessions = ChatSession.objects.filter(user=request.user)
        serializer = ChatSessionSerializer(sessions, many=True)
        
        return format_api_response(
            serializer.data,
            "Historique des conversations récupéré"
        )
        
    except Exception as e:
        logger.error(f"Failed to get chat history: {e}")
        return format_api_error(
            "Erreur lors de la récupération de l'historique",
            str(e)
        )
