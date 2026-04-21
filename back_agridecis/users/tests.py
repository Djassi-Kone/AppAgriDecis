"""
Tests pour l'application users
"""
from django.urls import reverse
from django.test import TestCase
from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from django.core.exceptions import ValidationError
from rest_framework.test import APITestCase
from rest_framework import status
from back_agridecis.exceptions import ValidationException

User = get_user_model()


class AuthFlowTests(APITestCase):
    def test_register_and_me(self):
        res = self.client.post(
            "/api/auth/register/",
            {
                "nom": "Test",
                "prenom": "User",
                "email": "test@example.com",
                "password": "Password123!",
                "role": "agriculteur",
            },
            format="multipart",
        )
        self.assertEqual(res.status_code, 201)

        login = self.client.post(
            "/api/auth/login/",
            {"email": "test@example.com", "password": "Password123!"},
            format="json",
        )
        self.assertEqual(login.status_code, 200)
        access = login.data["access"]
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {access}")

        me = self.client.get("/api/auth/me/")
        self.assertEqual(me.status_code, 200)
        self.assertEqual(me.data["email"], "test@example.com")


class AdminPermissionsTests(APITestCase):
    def setUp(self):
        self.admin = User.objects.create_superuser(
            email="admin@example.com",
            password="AdminPassword123!",
            nom="Admin",
            prenom="User",
        )
        self.user = User.objects.create_user(
            email="u@example.com",
            password="Password123!",
            nom="U",
            prenom="X",
            role="agriculteur",
        )

    def test_non_admin_cannot_list_users(self):
        login = self.client.post("/api/auth/login/", {"email": "u@example.com", "password": "Password123!"})
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {login.data['access']}")
        res = self.client.get("/api/admin/users/")
        self.assertEqual(res.status_code, 403)

    def test_admin_can_list_users(self):
        login = self.client.post("/api/auth/login/", {"email": "admin@example.com", "password": "AdminPassword123!"})
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {login.data['access']}")
        res = self.client.get("/api/admin/users/")
        self.assertEqual(res.status_code, 200)


class UserModelTest(TestCase):
    """Test du modèle User"""
    
    def setUp(self):
        self.user_data = {
            'email': 'test@example.com',
            'nom': 'Doe',
            'prenom': 'John',
            'password': 'TestPassword123!',
            'role': 'agriculteur'
        }
    
    def test_create_user(self):
        """Test la création d'un utilisateur"""
        user = User.objects.create_user(**self.user_data)
        
        self.assertEqual(user.email, self.user_data['email'])
        self.assertEqual(user.nom, self.user_data['nom'])
        self.assertEqual(user.prenom, self.user_data['prenom'])
        self.assertEqual(user.role, self.user_data['role'])
        self.assertTrue(user.check_password(self.user_data['password']))
        self.assertTrue(user.is_active)
        self.assertFalse(user.is_staff)
        self.assertFalse(user.is_superuser)
    
    def test_create_superuser(self):
        """Test la création d'un superutilisateur"""
        superuser = User.objects.create_superuser(
            email='admin@example.com',
            password='AdminPassword123!'
        )
        
        self.assertEqual(superuser.email, 'admin@example.com')
        self.assertEqual(superuser.role, 'admin')
        self.assertTrue(superuser.is_staff)
        self.assertTrue(superuser.is_superuser)
        self.assertTrue(superuser.is_active)
    
    def test_user_str_representation(self):
        """Test la représentation string de l'utilisateur"""
        user = User.objects.create_user(**self.user_data)
        self.assertEqual(str(user), user.email)


class UserValidationTest(TestCase):
    """Test des validations utilisateur"""
    
    def test_invalid_role_validation(self):
        """Test la validation des rôles invalides"""
        with self.assertRaises(ValidationError):
            User.objects.create_user(
                email='test2@example.com',
                password='TestPassword123!',
                role='invalid_role'
            )
    
    def test_invalid_phone_validation(self):
        """Test la validation des numéros de téléphone invalides"""
        with self.assertRaises(ValidationError):
            User.objects.create_user(
                email='test3@example.com',
                password='TestPassword123!',
                telephone='invalid-phone'
            )


class UserProfileAPITest(APITestCase):
    """Test des API profil utilisateur"""
    
    def setUp(self):
        self.user_data = {
            'email': 'test@example.com',
            'nom': 'Doe',
            'prenom': 'John',
            'password': 'TestPassword123!',
            'role': 'agriculteur',
            'telephone': '+221 77 123 45 67'
        }
        self.user = User.objects.create_user(**self.user_data)
        self.client.force_authenticate(user=self.user)
    
    def test_get_user_profile(self):
        """Test la récupération du profil utilisateur"""
        response = self.client.get('/api/auth/me/')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(data['email'], self.user.email)
        self.assertEqual(data['role'], self.user.role)
    
    def test_update_user_profile(self):
        """Test la mise à jour du profil utilisateur"""
        update_data = {
            'nom': 'Updated',
            'prenom': 'Name',
            'telephone': '+221 76 987 65 43'
        }
        response = self.client.patch('/api/profile/', update_data)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertEqual(self.user.nom, 'Updated')
        self.assertEqual(self.user.prenom, 'Name')
    
    def test_upload_profile_photo(self):
        """Test l'upload de photo de profil"""
        # Créer un fichier image test
        image = SimpleUploadedFile(
            "test_image.jpg",
            b"file_content",
            content_type="image/jpeg"
        )
        
        response = self.client.patch('/api/profile/', {
            'profile_photo': image
        }, format='multipart')
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertTrue(self.user.profile_photo)
    
    def test_invalid_file_upload(self):
        """Test l'upload de fichier invalide"""
        # Fichier trop grand
        large_image = SimpleUploadedFile(
            "large_image.jpg",
            b"x" * (11 * 1024 * 1024),  # 11MB
            content_type="image/jpeg"
        )
        
        response = self.client.patch('/api/profile/', {
            'profile_photo': large_image
        }, format='multipart')
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
