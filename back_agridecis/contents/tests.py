"""
Tests pour le module de gestion des contenus
"""
from django.test import TestCase
from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework.test import APITestCase
from rest_framework import status
from unittest.mock import patch
from contents.models import Content, ContentLike, ContentComment, ContentView

User = get_user_model()


class ContentModelTest(TestCase):
    """Test du modèle Content"""
    
    def setUp(self):
        self.agronome = User.objects.create_user(
            email='agronome@example.com',
            password='TestPassword123!',
            nom='Agronome',
            prenom='Test',
            role='agronome'
        )
        self.agriculteur = User.objects.create_user(
            email='agriculteur@example.com',
            password='TestPassword123!',
            nom='Agriculteur',
            prenom='Test',
            role='agriculteur'
        )
    
    def test_create_text_content(self):
        """Test la création d'un contenu texte"""
        content = Content.objects.create(
            title='Conseil sur le maïs',
            description='Voici comment cultiver le maïs efficacement...',
            content_type='text',
            author=self.agronome,
            category='culture',
            tags='maïs, culture, conseils'
        )
        
        self.assertEqual(content.title, 'Conseil sur le maïs')
        self.assertEqual(content.author, self.agronome)
        self.assertEqual(content.content_type, 'text')
        self.assertEqual(content.status, 'draft')
        self.assertEqual(content.get_tags_list(), ['maïs', 'culture', 'conseils'])
    
    def test_create_image_content(self):
        """Test la création d'un contenu image"""
        image = SimpleUploadedFile(
            "test_image.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        
        content = Content.objects.create(
            title='Maladie des tomates',
            description='Symptômes de la maladie...',
            content_type='image',
            image_file=image,
            author=self.agronome,
            status='published'
        )
        
        self.assertEqual(content.content_type, 'image')
        self.assertTrue(content.image_file)
        self.assertEqual(content.status, 'published')
        self.assertIsNotNone(content.published_at)
    
    def test_content_str_representation(self):
        """Test la représentation string du contenu"""
        content = Content.objects.create(
            title='Test Content',
            description='Test description',
            content_type='text',
            author=self.agronome
        )
        
        expected = f"Test Content - {self.agronome.email}"
        self.assertEqual(str(content), expected)
    
    def test_content_likes_count(self):
        """Test le comptage des likes"""
        content = Content.objects.create(
            title='Test Content',
            description='Test description',
            content_type='text',
            author=self.agronome
        )
        
        # Créer des likes
        ContentLike.objects.create(content=content, user=self.agriculteur)
        ContentLike.objects.create(content=content, user=self.agronome)
        
        self.assertEqual(content.likes_count, 2)
    
    def test_content_comments_count(self):
        """Test le comptage des commentaires"""
        content = Content.objects.create(
            title='Test Content',
            description='Test description',
            content_type='text',
            author=self.agronome
        )
        
        # Créer des commentaires
        ContentComment.objects.create(
            content=content,
            user=self.agriculteur,
            text='Super contenu !'
        )
        ContentComment.objects.create(
            content=content,
            user=self.agriculteur,
            text='Très utile'
        )
        
        self.assertEqual(content.comments_count, 2)


class ContentAPITest(APITestCase):
    """Test des API de contenus"""
    
    def setUp(self):
        self.agronome = User.objects.create_user(
            email='agronome@example.com',
            password='TestPassword123!',
            nom='Agronome',
            prenom='Test',
            role='agronome'
        )
        self.agriculteur = User.objects.create_user(
            email='agriculteur@example.com',
            password='TestPassword123!',
            nom='Agriculteur',
            prenom='Test',
            role='agriculteur'
        )
        self.admin = User.objects.create_superuser(
            email='admin@example.com',
            password='AdminPassword123!',
            nom='Admin',
            prenom='User'
        )
    
    def test_create_text_content_as_agronome(self):
        """Test la création d'un contenu texte par un agronome"""
        self.client.force_authenticate(user=self.agronome)
        
        data = {
            'title': 'Guide de plantation',
            'description': 'Voici un guide complet pour planter...',
            'content_type': 'text',
            'category': 'culture',
            'tags': 'plantation, guide, culture'
        }
        
        response = self.client.post('/api/contents/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Content.objects.filter(title='Guide de plantation').exists())
    
    def test_create_image_content_as_agronome(self):
        """Test la création d'un contenu image par un agronome"""
        self.client.force_authenticate(user=self.agronome)
        
        image = SimpleUploadedFile(
            "test_image.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        
        data = {
            'title': 'Photo de maladie',
            'description': 'Voici les symptômes...',
            'content_type': 'image',
            'image_file': image,
            'category': 'maladies'
        }
        
        response = self.client.post('/api/contents/', data, format='multipart')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        content = Content.objects.get(title='Photo de maladie')
        self.assertTrue(content.image_file)
    
    def test_create_content_as_agriculteur_fails(self):
        """Test que l'agriculteur ne peut pas créer de contenu"""
        self.client.force_authenticate(user=self.agriculteur)
        
        data = {
            'title': 'Test Content',
            'description': 'Test description',
            'content_type': 'text'
        }
        
        response = self.client.post('/api/contents/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
    
    def test_list_published_contents(self):
        """Test la liste des contenus publiés"""
        # Créer des contenus
        Content.objects.create(
            title='Publié 1',
            description='Description 1',
            content_type='text',
            author=self.agronome,
            status='published'
        )
        Content.objects.create(
            title='Brouillon 1',
            description='Description 2',
            content_type='text',
            author=self.agronome,
            status='draft'
        )
        
        response = self.client.get('/api/contents/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 1)  # Seulement le contenu publié
        self.assertEqual(data['data'][0]['title'], 'Publié 1')
    
    def test_my_contents_as_agronome(self):
        """Test la consultation de ses propres contenus par un agronome"""
        self.client.force_authenticate(user=self.agronome)
        
        # Créer des contenus
        Content.objects.create(
            title='Mon contenu 1',
            description='Description 1',
            content_type='text',
            author=self.agronome,
            status='published'
        )
        Content.objects.create(
            title='Mon contenu 2',
            description='Description 2',
            content_type='text',
            author=self.agronome,
            status='draft'
        )
        
        response = self.client.get('/api/contents/my-contents/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 2)  # Tous ses contenus
    
    def test_update_own_content(self):
        """Test la modification de son propre contenu"""
        self.client.force_authenticate(user=self.agronome)
        
        content = Content.objects.create(
            title='Titre original',
            description='Description originale',
            content_type='text',
            author=self.agronome
        )
        
        data = {
            'title': 'Titre modifié',
            'description': 'Description modifiée'
        }
        
        response = self.client.patch(f'/api/contents/{content.id}/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        content.refresh_from_db()
        self.assertEqual(content.title, 'Titre modifié')
    
    def test_update_other_content_fails(self):
        """Test que l'on ne peut pas modifier le contenu d'un autre"""
        other_agronome = User.objects.create_user(
            email='other@example.com',
            password='TestPassword123!',
            nom='Other',
            prenom='Agronome',
            role='agronome'
        )
        
        self.client.force_authenticate(user=self.agronome)
        
        content = Content.objects.create(
            title='Contenu autre',
            description='Description autre',
            content_type='text',
            author=other_agronome
        )
        
        data = {'title': 'Titre modifié'}
        
        response = self.client.patch(f'/api/contents/{content.id}/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)


class CommentAPITest(APITestCase):
    """Test des API de commentaires"""
    
    def setUp(self):
        self.agronome = User.objects.create_user(
            email='agronome@example.com',
            password='TestPassword123!',
            nom='Agronome',
            prenom='Test',
            role='agronome'
        )
        self.agriculteur = User.objects.create_user(
            email='agriculteur@example.com',
            password='TestPassword123!',
            nom='Agriculteur',
            prenom='Test',
            role='agriculteur'
        )
        
        self.content = Content.objects.create(
            title='Test Content',
            description='Test description',
            content_type='text',
            author=self.agronome,
            status='published'
        )
    
    def test_create_comment_as_agriculteur(self):
        """Test la création d'un commentaire par un agriculteur"""
        self.client.force_authenticate(user=self.agriculteur)
        
        data = {
            'text': 'Super contenu, très utile !'
        }
        
        response = self.client.post(f'/api/contents/{self.content.id}/comments/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(ContentComment.objects.filter(content=self.content).exists())
    
    def test_create_comment_as_agronome_fails(self):
        """Test que l'agronome ne peut pas commenter"""
        self.client.force_authenticate(user=self.agronome)
        
        data = {
            'text': 'Mon commentaire'
        }
        
        response = self.client.post(f'/api/contents/{self.content.id}/comments/', data, format='json')
        
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
    
    def test_list_comments(self):
        """Test la liste des commentaires d'un contenu"""
        # Créer des commentaires
        ContentComment.objects.create(
            content=self.content,
            user=self.agriculteur,
            text='Commentaire 1'
        )
        ContentComment.objects.create(
            content=self.content,
            user=self.agriculteur,
            text='Commentaire 2'
        )
        
        response = self.client.get(f'/api/contents/{self.content.id}/comments/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 2)


class LikeAPITest(APITestCase):
    """Test des API de likes"""
    
    def setUp(self):
        self.agronome = User.objects.create_user(
            email='agronome@example.com',
            password='TestPassword123!',
            nom='Agronome',
            prenom='Test',
            role='agronome'
        )
        self.agriculteur = User.objects.create_user(
            email='agriculteur@example.com',
            password='TestPassword123!',
            nom='Agriculteur',
            prenom='Test',
            role='agriculteur'
        )
        
        self.content = Content.objects.create(
            title='Test Content',
            description='Test description',
            content_type='text',
            author=self.agronome,
            status='published'
        )
    
    def test_like_content_as_agriculteur(self):
        """Test le like d'un contenu par un agriculteur"""
        self.client.force_authenticate(user=self.agriculteur)
        
        response = self.client.post(f'/api/contents/{self.content.id}/like/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertTrue(data['data']['is_liked'])
        self.assertEqual(data['data']['likes_count'], 1)
    
    def test_unlike_content_as_agriculteur(self):
        """Test l'unlike d'un contenu"""
        self.client.force_authenticate(user=self.agriculteur)
        
        # D'abord liker
        self.client.post(f'/api/contents/{self.content.id}/like/')
        
        # Ensuite unlike
        response = self.client.post(f'/api/contents/{self.content.id}/like/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertFalse(data['data']['is_liked'])
        self.assertEqual(data['data']['likes_count'], 0)


class AdminContentAPITest(APITestCase):
    """Test des API admin pour les contenus"""
    
    def setUp(self):
        self.agronome = User.objects.create_user(
            email='agronome@example.com',
            password='TestPassword123!',
            nom='Agronome',
            prenom='Test',
            role='agronome'
        )
        self.admin = User.objects.create_superuser(
            email='admin@example.com',
            password='AdminPassword123!',
            nom='Admin',
            prenom='User'
        )
        
        self.content = Content.objects.create(
            title='Test Content',
            description='Test description',
            content_type='text',
            author=self.agronome,
            status='published'
        )
    
    def test_admin_list_all_contents(self):
        """Test que l'admin peut lister tous les contenus"""
        self.client.force_authenticate(user=self.admin)
        
        response = self.client.get('/api/contents/admin/all/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(len(data['data']), 1)
    
    def test_admin_delete_content(self):
        """Test que l'admin peut supprimer un contenu"""
        self.client.force_authenticate(user=self.admin)
        
        response = self.client.delete(f'/api/contents/admin/{self.content.id}/delete/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertFalse(Content.objects.filter(id=self.content.id).exists())
