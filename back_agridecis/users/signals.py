import os

from django.apps import apps
from django.db.models.signals import post_migrate
from django.dispatch import receiver

@receiver(post_migrate)
def create_or_check_admin(sender, **kwargs):
    if sender.name != 'users':
        return

    print(" POST_MIGRATE EXECUTED")

    User = apps.get_model('users', 'User')

    if not os.getenv("CREATE_DEFAULT_ADMIN", "").lower() in {"1", "true", "yes", "y"}:
        return

    email = os.getenv("DEFAULT_ADMIN_EMAIL")
    password = os.getenv("DEFAULT_ADMIN_PASSWORD")

    if not email or not password:
        return

    admin = User.objects.filter(email=email).first()

    if admin:
        print("⚠️ Admin already exists")
        return

    admin = User.objects.create_user(
        email=email,
        password=password,
        role="admin",
        is_staff=True,
        is_superuser=True,
        is_active=True,
        nom=os.getenv("DEFAULT_ADMIN_NOM", "Admin"),
        prenom=os.getenv("DEFAULT_ADMIN_PRENOM", "System"),
    )

    print(" Admin created:", admin.email)