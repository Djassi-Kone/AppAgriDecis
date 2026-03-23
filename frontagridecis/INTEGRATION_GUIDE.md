# 🚜 AgriDecis - Intégration Frontend-Backend

## ✅ Intégration Complète Réalisée

**Application Flutter : Dashboard Admin uniquement**

Votre application Flutter est un **dashboard administrateur** qui se connecte à votre backend Django.

> **Note importante :** 
> - Cette version Flutter est destinée **uniquement aux administrateurs**
> - L'admin est créé par défaut dans la base de données Django
> - Il pourra modifier ses identifiants plus tard depuis son profil
> - Les versions mobiles pour Agriculteurs/Agronomes seront développées ultérieurement

---

## 📁 Fichiers Créés/Modifiés

### Backend Django (inchangé - déjà fonctionnel)
- ✅ API REST avec JWT authentication
- ✅ CORS configuré pour Flutter
- ✅ Endpoints : Login, Inscription, Password Reset, Météo, Diagnostic IA

### Frontend Flutter

#### **1. Modèles**
- [`lib/models/user.dart`](lib/models/user.dart) - Modèle utilisateur complet avec tokens JWT

#### **2. Configuration API**
- [`lib/services/api_config.dart`](lib/services/api_config.dart) - Configuration centralisée des endpoints

#### **3. Services d'Authentification**
- [`lib/services/auth_service.dart`](lib/services/auth_service.dart) - Gestion complète de l'authentification
  - Connexion avec email/mot de passe
  - Rafraîchissement automatique des tokens
  - Déconnexion sécurisée
  - Stockage chiffré des tokens

- [`lib/services/inscription_service.dart`](lib/services/inscription_service.dart) - Service d'inscription
  - Inscription Agriculteur/Agronome
  - Champs dynamiques selon le rôle
  - Validation des données

- [`lib/services/password_reset_service.dart`](lib/services/password_reset_service.dart) - Réinitialisation mot de passe
  - Demande par email
  - Confirmation avec token

#### **4. Services Métier**
- [`lib/services/weather_service.dart`](lib/services/weather_service.dart) - API Météo
  - Prévisions par ville ou coordonnées GPS
  - Alertes météo
  - Seuils d'alerte (Admin)
  - Paramètres de notification (Admin)

- [`lib/services/diagnostic_service.dart`](lib/services/diagnostic_service.dart) - API Intelligence Artificielle
  - Upload d'image pour diagnostic
  - Historique des diagnostics
  - Chat de conseils agricoles

#### **5. Providers**
- [`lib/providers/auth_provider.dart`](lib/providers/auth_provider.dart) - State management de l'authentification
  - Gestion des états (loading, authenticated, error)
  - Rafraîchissement automatique des tokens
  - Helpers pour les rôles (isAdmin, isAgriculteur, isAgronome)

#### **6. Exemples**
- [`lib/services/USAGE_EXAMPLE.dart`](lib/services/USAGE_EXAMPLE.dart) - Guide complet d'utilisation

---

## 🚀 Démarrage Rapide

### 1. Configuration du Backend

**Sur votre machine Windows :**

```powershell
# Se placer dans le dossier backend
cd c:\Users\DELLi5\Desktop\PRJET_GL\AgriDecis

# Activer l'environnement virtuel (si existe)
# ou installer les dépendances
pip install -r requirements.txt

# Lancer le serveur Django
python manage.py runserver
```

Le backend tourne maintenant sur : **http://localhost:8000**

### 2. Configuration du Frontend

**URL de développement :**

La configuration par défaut est dans [`lib/services/api_config.dart`](lib/services/api_config.dart):

```dart
static const String _devBaseUrl = 'http://10.0.2.2:8000'; // Android Emulator
static const String_webBaseUrl = 'http://localhost:8000'; // Web
```

**⚠️ Important selon votre plateforme :**

- **Android Emulator** : `http://10.0.2.2:8000` (déjà configuré)
- **iOS Simulator** : `http://localhost:8000`
- **Web** : `http://localhost:8000`
- **Windows/Linux/Mac Desktop** : `http://localhost:8000`

### 3. Lancer l'Application Flutter

```powershell
# Se placer dans le folder frontend
cd c:\Users\DELLi5\Desktop\PRJET_GL\frontagridecis

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

---

## 🔐 Utilisation des Services

### Exemple : Connexion

```dart
import'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// Dans votre widget
final authProvider= Provider.of<AuthProvider>(context, listen: false);

await authProvider.login('email@example.com', 'motdepasse');

if (authProvider.isAuthenticated) {
  print('Connecté en tant que ${authProvider.userRole}');
  // Navigation...
} else {
  print('Erreur: ${authProvider.errorMessage}');
}
```

### Exemple : Récupérer les prévisions météo

```dart
import '../services/weather_service.dart';
import '../services/auth_service.dart';

final weatherService = WeatherService();
final authService = AuthService();

final token = await authService.getAccessToken();
final previsions = await weatherService.getPrevisions(
  token: token,
  ville: 'Paris',
  jours: 7,
);

print('Prévisions: ${previsions['previsions']}');
```

### Exemple : Upload Diagnostic IA

```dart
import '../services/diagnostic_service.dart';
import '../services/auth_service.dart';

final diagnosticService = DiagnosticService();
final authService = AuthService();

final token = await authService.getAccessToken();

// Récupérer l'historique des diagnostics
final diagnostics = await diagnosticService.getMesDiagnostics(token);

// Obtenir le détail d'un diagnostic
final detail = await diagnosticService.getDetailDiagnostic(
  token,
  diagnostics.first['id'].toString(),
);

print('Diagnostic: ${detail['resume']}');
```

---

## 📋 Endpoints API Disponibles

### Authentification
- `POST /api/login/` - Connexion
- `POST /api/inscription/` - Inscription
- `POST /api/refresh/` - Rafraîchir token
- `POST /api/password-reset/request/` - Demander réinitialisation
- `POST /api/password-reset/confirm/` - Confirmer réinitialisation
- `GET /api/mon-historique/` - Historique utilisateur

### Météo
- `GET /api/meteo/previsions/` - Prévisions météo
- `GET /api/meteo/seuils-alerte/` - Seuils d'alerte (Admin)
- `PATCH /api/meteo/seuils-alerte/` - MAJ seuils (Admin)
- `GET /api/meteo/parametres-notifications/` - Paramètres (Admin)
- `PATCH /api/meteo/parametres-notifications/` - MAJ paramètres (Admin)

### Intelligence Artificielle
- `POST /api/ia/diagnostic-image/` - Upload image diagnostic
- `GET /api/ia/mes-diagnostics/` - Liste diagnostics
- `GET /api/ia/diagnostic/{id}/` - Détail diagnostic
- `POST /api/ia/chat-conseils/` - Chat conseils agricoles

---

## 🔧 Gestion des Tokens JWT

Le système gère automatiquement les tokens :

1. **Access Token** : Valide 1 heure
2. **Refresh Token** : Valide 7 jours

**Fonctionnement :**
- À chaque appel API, le token est vérifié
- Si expiration < 5 minutes → rafraîchissement automatique
- Si refresh token expiré → déconnexion nécessaire

---

## 🛡️ Sécurité

- ✅ Tokens stockés dans `FlutterSecureStorage` (chiffré)
- ✅ HTTPS requis en production
- ✅ CORS configuré pour développement
- ✅ Validation des données côté backend
- ✅ Gestion des erreurs réseau

---

## 📱 Tests Utilisateurs

Pour tester, vous pouvez créer des utilisateurs via :

### 1. Via l'API (Postman/curl)

```bash
# Inscription Agriculteur
curl -X POST http://localhost:8000/api/inscription/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@agridecis.com",
    "password": "Test123!",
    "nom": "Dupont",
    "prenom": "Jean",
    "role": "AGRICULTEUR",
    "telephone": "+33612345678"
  }'
```

### 2. Via le code Flutter

```dart
final inscriptionService = InscriptionService();

await inscriptionService.inscrire(
  email: 'test@agridecis.com',
  password: 'Test123!',
  nom: 'Dupont',
  prenom: 'Jean',
  role: 'AGRICULTEUR',
  telephone: '+33612345678',
);
```

---

## 🐛 Dépannage

### Erreur de connexion au backend

**Vérifiez :**
1. Le backend tourne (`python manage.py runserver`)
2. L'URL dans `api_config.dart` correspond à votre plateforme
3. Le firewall ne bloque pas le port 8000

### Erreur CORS

**Solution :**
Le backend a `CORS_ALLOW_ALL_ORIGINS = True` en développement. Vérifiez dans `settings.py`.

### Token expiré

L'AuthService gère automatiquement le rafraîchissement. Si échec, reconnectez-vous.

---

## 📖 Pour Aller Plus Loin

Consultez [`USAGE_EXAMPLE.dart`](lib/services/USAGE_EXAMPLE.dart) pour des exemples complets et commentés.

---

## 🎯 Prochaines Étapes

1. **Tester l'authentification** avec de vrais utilisateurs
2. **Implémenter les écrans** de votre application
3. **Ajouter l'upload d'images** pour les diagnostics (avec `image_picker`)
4. **Configurer HTTPS** pour la production
5. **Personnaliser les URLs** selon votre environnement

---

## 💡 Besoin d'Aide ?

Les services sont documentés et prêts à l'emploi. Chaque méthode inclut :
- Gestion des erreurs
- Validation des données
- Support réseau
- Logs de débogage

**Bon développement avec AgriDecis ! 🌾**
