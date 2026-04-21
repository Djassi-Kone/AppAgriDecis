from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models
from django.core.validators import RegexValidator
from back_agridecis.validators import validate_phone_number, validate_role, validate_image_file

ROLE_CHOICES = [
    ('admin', 'Administrateur'),
    ('agronome', 'Agronome'),
    ('agriculteur', 'Agriculteur'),
]

class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("L'email est obligatoire")

        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)

        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('role', 'admin')

        return self.create_user(email, password, **extra_fields)

class User(AbstractUser):
    
    username = None 

    nom = models.CharField(max_length=150)
    prenom = models.CharField(max_length=150)
    email = models.EmailField(unique=True)
    telephone = models.CharField(
        max_length=20, 
        blank=True, 
        null=True,
        validators=[validate_phone_number],
        help_text="Format: +221 77 123 45 67 ou 771234567"
    )
    role = models.CharField(
        max_length=20, 
        choices=ROLE_CHOICES, 
        blank=True, 
        null=True,
        validators=[validate_role]
    )
    profile_photo = models.ImageField(
        upload_to='profile_photos/', 
        blank=True, 
        null=True,
        validators=[validate_image_file]
    )
    dateCreation = models.DateTimeField(auto_now_add=True)

    # champs spécifiques
    specialite = models.CharField(max_length=255, blank=True, null=True)  # pour Agronome
    localisation = models.CharField(max_length=255, blank=True, null=True)  # pour Agriculteur
    typeCulture = models.CharField(max_length=255, blank=True, null=True)  # pour Agriculteur


    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = UserManager()

    def __str__(self):
        return self.email
    