"""
Tests pour le module IA
"""
from django.test import TestCase
from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from unittest.mock import patch, MagicMock
from rest_framework.test import APITestCase
from rest_framework import status
from ai.models import DiagnosisRequest, ChatMessage, ChatSession

User = get_user_model()


class DiagnosisModelTest(TestCase):
    """Test du modèle DiagnosisRequest"""
    
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com',
            password='TestPassword123!',
            nom='Test',
            prenom='User',
            role='agriculteur'
        )
    
    def test_create_diagnosis_request(self):
        """Test la création d'une requête de diagnostic"""
        image = SimpleUploadedFile(
            "test_image.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        
        diagnosis = DiagnosisRequest.objects.create(
            user=self.user,
            image=image,
            culture='tomate'
        )
        
        self.assertEqual(diagnosis.user, self.user)
        self.assertEqual(diagnosis.culture, 'tomate')
        self.assertEqual(diagnosis.status, 'pending')
        self.assertTrue(diagnosis.image)
    
    def test_diagnosis_str_representation(self):
        """Test la représentation string du diagnostic"""
        diagnosis = DiagnosisRequest.objects.create(
            user=self.user,
            culture='tomate'
        )
        
        expected = f"Diagnostic {diagnosis.id} - {self.user.email} - tomate"
        self.assertEqual(str(diagnosis), expected)


class ChatModelTest(TestCase):
    """Test des modèles de chat"""
    
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com',
            password='TestPassword123!',
            nom='Test',
            prenom='User',
            role='agriculteur'
        )
    
    def test_create_chat_session(self):
        """Test la création d'une session de chat"""
        session = ChatSession.objects.create(
            user=self.user,
            title='Test Session'
        )
        
        self.assertEqual(session.user, self.user)
        self.assertEqual(session.title, 'Test Session')
        self.assertEqual(session.messages.count(), 0)
    
    def test_create_chat_message(self):
        """Test la création d'un message de chat"""
        message = ChatMessage.objects.create(
            user=self.user,
            role='user',
            content='Bonjour, j\'ai besoin d\'aide',
            message_type='text'
        )
        
        self.assertEqual(message.user, self.user)
        self.assertEqual(message.role, 'user')
        self.assertEqual(message.content, 'Bonjour, j\'ai besoin d\'aide')
        self.assertEqual(message.message_type, 'text')
    
    def test_chat_session_with_messages(self):
        """Test l'ajout de messages à une session"""
        session = ChatSession.objects.create(
            user=self.user,
            title='Test Session'
        )
        
        user_message = ChatMessage.objects.create(
            user=self.user,
            role='user',
            content='Question test',
            message_type='text'
        )
        
        ai_message = ChatMessage.objects.create(
            user=self.user,
            role='assistant',
            content='Réponse test',
            message_type='text'
        )
        
        session.messages.add(user_message, ai_message)
        
        self.assertEqual(session.messages.count(), 2)


class DiagnosisAPITest(APITestCase):
    """Test des API de diagnostic"""
    
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com',
            password='TestPassword123!',
            nom='Test',
            prenom='User',
            role='agriculteur'
        )
        self.client.force_authenticate(user=self.user)
    
    @patch('ai.services.oxlo_service.detect_plant_disease')
    def test_create_diagnosis_success(self, mock_detect):
        """Test la création réussie d'un diagnostic"""
        # Mock du service IA
        mock_detect.return_value = {
            'success': True,
            'detections': [
                {'label': 'mildew', 'confidence': 0.85}
            ],
            'total_detections': 1
        }
        
        image = SimpleUploadedFile(
            "test_image.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        
        data = {
            'image': image,
            'culture': 'tomate'
        }
        
        response = self.client.post('/api/ai/diagnosis/', data, format='multipart')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(DiagnosisRequest.objects.filter(user=self.user).exists())
        
        diagnosis = DiagnosisRequest.objects.get(user=self.user)
        self.assertEqual(diagnosis.culture, 'tomate')
        self.assertEqual(diagnosis.status, 'completed')
        self.assertEqual(diagnosis.detected_disease, 'mildew')
        self.assertEqual(diagnosis.confidence, 0.85)
    
    @patch('ai.services.oxlo_service.detect_plant_disease')
    def test_create_diagnosis_failure(self, mock_detect):
        """Test l'échec de diagnostic IA"""
        mock_detect.return_value = {
            'success': False,
            'error': 'Service temporairement indisponible'
        }
        
        image = SimpleUploadedFile(
            "test_image.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        
        data = {
            'image': image,
            'culture': 'tomate'
        }
        
        response = self.client.post('/api/ai/diagnosis/', data, format='multipart')
        
        self.assertEqual(response.status_code, status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        diagnosis = DiagnosisRequest.objects.get(user=self.user)
        self.assertEqual(diagnosis.status, 'failed')
    
    def test_list_diagnoses(self):
        """Test la liste des diagnostics"""
        # Créer quelques diagnostics
        for i in range(3):
            DiagnosisRequest.objects.create(
                user=self.user,
                culture=f'tomate_{i}',
                status='completed'
            )
        
        response = self.client.get('/api/ai/diagnosis/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 3)
    
    def test_invalid_file_upload(self):
        """Test l'upload de fichier invalide"""
        invalid_file = SimpleUploadedFile(
            "invalid.txt",
            b"file_content",
            content_type="text/plain"
        )
        
        data = {
            'image': invalid_file,
            'culture': 'tomate'
        }
        
        response = self.client.post('/api/ai/diagnosis/', data, format='multipart')
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class ChatAPITest(APITestCase):
    """Test des API de chat"""
    
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com',
            password='TestPassword123!',
            nom='Test',
            prenom='User',
            role='agriculteur'
        )
        self.client.force_authenticate(user=self.user)
    
    def test_create_chat_session(self):
        """Test la création d'une session de chat"""
        data = {
            'title': 'Nouvelle conversation',
            'first_message': 'Bonjour, j\'ai besoin de conseils'
        }
        
        response = self.client.post('/api/ai/chat/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(ChatSession.objects.filter(user=self.user).exists())
        
        session = ChatSession.objects.get(user=self.user)
        self.assertEqual(session.title, 'Nouvelle conversation')
        self.assertEqual(session.messages.count(), 1)
    
    @patch('ai.services.oxlo_service.get_agricultural_advice')
    def test_send_chat_message(self, mock_advice):
        """Test l'envoi d'un message de chat"""
        # Mock du service IA
        mock_advice.return_value = {
            'success': True,
            'content': 'Voici des conseils pour votre culture...'
        }
        
        # Créer une session
        session = ChatSession.objects.create(
            user=self.user,
            title='Test Session'
        )
        
        data = {
            'content': 'Comment protéger mes tomates contre les maladies ?',
            'message_type': 'text'
        }
        
        response = self.client.post(f'/api/ai/chat/{session.id}/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        
        session.refresh_from_db()
        self.assertEqual(session.messages.count(), 2)  # user + assistant
        
        # Vérifier les messages
        messages = session.messages.all()
        user_msg = messages.get(role='user')
        ai_msg = messages.get(role='assistant')
        
        self.assertEqual(user_msg.content, 'Comment protéger mes tomates contre les maladies ?')
        self.assertTrue(ai_msg.content)
    
    def test_get_chat_messages(self):
        """Test la récupération des messages d'une session"""
        session = ChatSession.objects.create(
            user=self.user,
            title='Test Session'
        )
        
        # Créer des messages
        ChatMessage.objects.create(
            user=self.user,
            role='user',
            content='Question',
            message_type='text'
        )
        ChatMessage.objects.create(
            user=self.user,
            role='assistant',
            content='Réponse',
            message_type='text'
        )
        
        response = self.client.get(f'/api/ai/chat/{session.id}/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 2)
    
    def test_chat_history(self):
        """Test l'historique des conversations"""
        # Créer plusieurs sessions
        for i in range(3):
            ChatSession.objects.create(
                user=self.user,
                title=f'Session {i}'
            )
        
        response = self.client.get('/api/ai/chat/history/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 3)
