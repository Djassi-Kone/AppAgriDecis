from users.models import User

# Créer un admin par défaut
admin_email = "admin@agridecis.com"
admin_password = "Admin123!"

# Vérifier si l'admin existe déjà
if not User.objects.filter(email=admin_email).exists():
    admin = User.objects.create_user(
        email=admin_email,
        password=admin_password,
        role="admin",
        is_staff=True,
        is_superuser=True,
        is_active=True,
        nom="Admin",
        prenom="AgriDecis",
    )
    print(f"Admin créé avec succès: {admin_email}")
else:
    print("L'admin existe déjà")

# Créer un agronome de test
agronome_email = "agronome@agridecis.com"
agronome_password = "Agronome123!"

if not User.objects.filter(email=agronome_email).exists():
    agronome = User.objects.create_user(
        email=agronome_email,
        password=agronome_password,
        role="agronome",
        is_staff=False,
        is_superuser=False,
        is_active=True,
        nom="Dupont",
        prenom="Jean",
    )
    print(f"Agronome créé avec succès: {agronome_email}")
else:
    print("L'agronome existe déjà")

# Créer un agriculteur de test
agriculteur_email = "agriculteur@agridecis.com"
agriculteur_password = "Agriculteur123!"

if not User.objects.filter(email=agriculteur_email).exists():
    agriculteur = User.objects.create_user(
        email=agriculteur_email,
        password=agriculteur_password,
        role="agriculteur",
        is_staff=False,
        is_superuser=False,
        is_active=True,
        nom="Martin",
        prenom="Pierre",
    )
    print(f"Agriculteur créé avec succès: {agriculteur_email}")
else:
    print("L'agriculteur existe déjà")

print("\n=== Comptes créés ===")
print("Admin: admin@agridecis.com / Admin123!")
print("Agronome: agronome@agridecis.com / Agronome123!")
print("Agriculteur: agriculteur@agridecis.com / Agriculteur123!")
