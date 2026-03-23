from django.urls import reverse
from rest_framework.test import APITestCase

from users.models import User


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
