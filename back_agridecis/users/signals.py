import os

from django.apps import apps
from django.db.models.signals import post_migrate
from django.dispatch import receiver

@receiver(post_migrate)
def create_or_check_admin(sender, **kwargs):
    User = apps.get_model('users', 'User')  # récupérer le modèle User

    # Création d'un admin par défaut UNIQUEMENT si activée par variables d'env.
    # Cela évite de commiter des identifiants en dur dans le code.
    create_default_admin = os.getenv("CREATE_DEFAULT_ADMIN", "").lower() in {"1", "true", "yes", "y"}
    if not create_default_admin:
        return

    admin_email = os.getenv("DEFAULT_ADMIN_EMAIL")
    admin_password = os.getenv("DEFAULT_ADMIN_PASSWORD")
    admin_nom = os.getenv("DEFAULT_ADMIN_NOM", "Admin")
    admin_prenom = os.getenv("DEFAULT_ADMIN_PRENOM", "AgrisDecis")

    if not admin_email or not admin_password:
        return

    admin = User.objects.filter(role="admin").first()
    if admin:
        return

    User.objects.create_user(
        email=admin_email,
        password=admin_password,
        role="admin",
        is_staff=True,
        is_superuser=True,
        is_active=True,
        nom=admin_nom,
        prenom=admin_prenom,
    )