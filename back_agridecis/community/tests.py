from rest_framework.test import APITestCase

from users.models import User


class ContentPermissionsTests(APITestCase):
    def setUp(self):
        self.agronome = User.objects.create_user(
            email="agronome@example.com",
            password="Password123!",
            nom="Agro",
            prenom="Nome",
            role="agronome",
        )
        self.agriculteur = User.objects.create_user(
            email="agri@example.com",
            password="Password123!",
            nom="Agri",
            prenom="Culteur",
            role="agriculteur",
        )

    def test_agriculteur_cannot_create_content(self):
        login = self.client.post("/api/auth/login/", {"email": "agri@example.com", "password": "Password123!"})
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {login.data['access']}")
        res = self.client.post("/api/contents/", {"title": "T1", "kind": "text", "text": "Hello"})
        self.assertEqual(res.status_code, 403)

    def test_agronome_can_create_content(self):
        login = self.client.post("/api/auth/login/", {"email": "agronome@example.com", "password": "Password123!"})
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {login.data['access']}")
        res = self.client.post("/api/contents/", {"title": "T1", "kind": "text", "text": "Hello"})
        self.assertEqual(res.status_code, 201)
