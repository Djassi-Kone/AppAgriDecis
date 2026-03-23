# 🎯 INTÉGRATION AGRIDECIS - SYNTHÈSE

## 📌 Architecture du Projet

### Backend Django (`AgriDecis/`)
✅ **Déjà en place et fonctionnel**
- API REST complète avec JWT
- Modèles: Administrateur, Agriculteur, Agronome
- Endpoints : Auth, Météo, IA, Historique
- CORS configuré pour Flutter

### Frontend Flutter (`frontagridecis/`)
🎯 **Dashboard Admin Uniquement** (pour l'instant)

---

## 📁 Fichiers Créés pour l'Intégration

### 🔧 Configuration
- ✅ `lib/services/api_config.dart` - URLs et endpoints API
- ✅ `lib/config/admin_config.dart` - Config spécifique dashboard admin

### 👤 Modèles
- ✅ `lib/models/user.dart` - Modèle utilisateur complet (Admin, etc.)

### 🔐 Authentification
- ✅ `lib/services/auth_service.dart` - Gestion JWT complète
- ✅ `lib/services/inscription_service.dart` - Création utilisateurs
- ✅ `lib/services/password_reset_service.dart` - Réinitialisation mot de passe
- ✅ `lib/providers/auth_provider.dart` - State management auth

### 🌦️ Services Métier
- ✅ `lib/services/weather_service.dart` - API Météo (seuils, notifications)
- ✅ `lib/services/diagnostic_service.dart` - API IA (diagnostics, chat)

### 🎨 UI & Widgets
- ✅ `lib/widgets/admin_only_widget.dart` - Widget réservé aux admins
- ✅ `lib/screens/admin_dashboard_screen.dart` - Exemple dashboard admin

### 📚 Documentation
- ✅ `INTEGRATION_GUIDE.md` - Guide complet d'intégration
- ✅ `README_ADMIN.md` - Documentation spécifique dashboard admin
- ✅ `lib/services/USAGE_EXAMPLE.dart` - Exemples de code commentés
- ✅ `lib/services/integration_test.dart` - Tests de connexion backend

---

## 🚀 Comment Démarrer

### 1. Lancer le Backend Django

```powershell
cd c:\Users\DELLi5\Desktop\PRJET_GL\AgriDecis
python manage.py runserver
```

✅ Le backend tourne sur `http://localhost:8000`

### 2. Configurer le Frontend Flutter

L'URL est déjà configurée dans `lib/services/api_config.dart` :

```dart
static const String _devBaseUrl = 'http://10.0.2.2:8000'; // Android Emulator
```

### 3. Tester la Connexion

```powershell
cd c:\Users\DELLi5\Desktop\PRJET_GL\frontagridecis
flutter pub get
flutter run
```

### 4. Se Connecter comme Admin

Utilisez les identifiants admin créés par défaut dans Django :

```dart
await authProvider.login('admin@agridecis.com', 'mot_de_passe_admin');

if (authProvider.isAuthenticated && authProvider.isAdmin) {
  // Navigation vers le dashboard
  Navigator.pushReplacementNamed(context, '/admin-dashboard');
}
```

---

## 🎯 Fonctionnalités Dashboard Admin

### Ce que l'Admin Peut Faire

#### 1. **Gestion des Utilisateurs**
```dart
// Créer un agriculteur
await inscriptionService.inscrire(
  email: 'agriculteur@example.com',
  password: 'MotDePasse123!',
  nom: 'Dupont',
  prenom: 'Jean',
  role: 'AGRICULTEUR',
  telephone: '+33612345678',
  specialite: 'Grandes cultures',
  localisation: 'Paris',
  typeCulture: 'Blé, Maïs',
);

// Créer un agronome
await inscriptionService.inscrire(
  email: 'agronome@example.com',
  password: 'MotDePasse123!',
  nom: 'Martin',
  prenom: 'Sophie',
  role: 'AGRONOME',
  telephone: '+33687654321',
  specialite: 'Conseil agricole',
);
```

#### 2. **Configuration Météo**
```dart
// Récupérer/modifier les seuils d'alerte
final seuils = await weatherService.getSeuilsAlerte(token);
await weatherService.updateSeuilsAlerte(token, [
  {'id': 1, 'valeurSeuil': 30.0, 'actif': true},
]);

// Récupérer/modifier les paramètres de notification
final params = await weatherService.getParametresNotifications(token);
await weatherService.updateParametresNotifications(token, {
  'notification_email': 'true',
});
```

#### 3. **Supervision des Diagnostics IA**
```dart
// Voir tous les diagnostics
final diagnostics = await diagnosticService.getMesDiagnostics(token);

// Voir le détail
final detail = await diagnosticService.getDetailDiagnostic(
  token,
  diagnosticId.toString(),
);
```

#### 4. **Rapports et Statistiques**
- Consulter l'historique des actions
- Générer des rapports
- Analyser les tendances

---

## 🏗️ Structure du Code

### Organisation Recommandée

```
lib/
├── config/                    # Configuration
│   └── admin_config.dart      # Config dashboard admin
├── models/                    # Modèles de données
│   └── user.dart              # Modèle utilisateur
├── providers/                 # State management
│   └── auth_provider.dart     # Authentification
├── screens/                   # Écrans
│   └── admin_dashboard_screen.dart  # Dashboard admin
├── services/                  # Services API
│   ├── api_config.dart        # Configuration URLs
│   ├── auth_service.dart      # Authentification
│   ├── inscription_service.dart       # Inscriptions
│   ├── password_reset_service.dart    # Password reset
│   ├── weather_service.dart   # API Météo
│   └── diagnostic_service.dart # API IA
└── widgets/                   # Composants UI
    └── admin_only_widget.dart # Widget réservé admins
```

---

## 🔐 Sécurité

### Tokens JWT
- **Access Token** : Expire après 1 heure
- **Refresh Token** : Expire après 7 jours
- **Rafraîchissement automatique** géré par `AuthService`

### Stockage Sécurisé
- Tokens chiffrés avec `FlutterSecureStorage`
- Headers HTTP sécurisés
- HTTPS requis en production

### Rôles et Permissions
```dart
// Vérifier si admin
if (authProvider.isAdmin) {
  // Afficher contenu admin
}

// Utiliser le widget dédié
AdminOnly(
  child: Text('Contenu réservé aux admins'),
  fallback: Text('Accès refusé'),
)
```

---

## 📝 Prochaines Étapes

### Phase 1 : Dashboard Admin (Priorité Actuelle)

À développer :

1. ✅ **Écran de Connexion**
   - Formulaire email/mot de passe
   - Gestion des erreurs
   - Redirection selon rôle

2. ✅ **Dashboard Principal**
   - Statistiques en temps réel
   - Cartes de résumé
   - Accès rapide aux fonctionnalités

3. ✅ **Gestion des Utilisateurs**
   - Liste des utilisateurs
   - CRUD (Créer, Lire, Mettre à jour, Supprimer)
   - Filtrage par rôle

4. ✅ **Configuration Météo**
   - Interface des seuils d'alerte
   - Paramètres de notification
   - Prévisions en temps réel

5. ✅ **Diagnostics IA**
   - Liste complète des diagnostics
   - Détails par agriculteur
   - Statistiques d'utilisation

6. ✅ **Profil Admin**
   - Modifier ses identifiants
   - Historique des actions
   - Paramètres personnels

### Phase 2 : Applications Mobiles (Plus Tard)

Quand les pages mobiles seront prêtes:

- 📱 **App Mobile Agriculteur**
  - Diagnostic personnalisé
  - Météo locale
  - Conseils IA
  - Historique personnel

- 📱 **App Mobile Agronome**
  - Suivi des agriculteurs
  - Conseils avancés
  - Rapports détaillés

---

## 💡 Points Importants

### Admin par Défaut
- L'administrateur est **créé automatiquement** dans la base Django
- Il peut **modifier ses identifiants** plus tard depuis son profil
- Un seul admin pour l'instant (extensible à plusieurs)

### Application Flutter Actuelle
- **Uniquement pour le dashboard admin**
- Ne remplace pas les futures apps mobiles
- Permet la gestion globale de la plateforme

### Architecture Évolutive
- Code prêt pour ajouter d'autres rôles
- Services modulaires et réutilisables
- Facile à étendre pour les apps mobiles futures

---

## 🛠️ Commandes Utiles

### Backend Django
```bash
# Lancer le serveur
python manage.py runserver

# Créer un superuser (admin)
python manage.py createsuperuser

# Migration base de données
python manage.py migrate

# Collect static files
python manage.py collectstatic
```

### Frontend Flutter
```powershell
# Installer dépendances
flutter pub get

# Lancer l'app
flutter run

# Build APK
flutter build apk

# Build Web
flutter build web

# Nettoyer le projet
flutter clean
```

---

## 📞 Besoin d'Aide ?

### Documentation Complète
- [`INTEGRATION_GUIDE.md`](INTEGRATION_GUIDE.md) - Guide général
- [`README_ADMIN.md`](README_ADMIN.md) - Spécifique admin
- [`USAGE_EXAMPLE.dart`](lib/services/USAGE_EXAMPLE.dart) - Exemples de code

### Tests d'Intégration
```dart
// Tester la connexion au backend
import '../services/integration_test.dart';

void main() async {
  await testBackendConnection();
  await testLoginEndpoint();
}
```

---

## ✅ Checklist d'Installation

- [ ] Backend Django installé et fonctionnel
- [ ] Base de données migrée
- [ ] Admin créé dans la base
- [ ] Flutter dependencies installisées (`flutter pub get`)
- [ ] URL backend configurée dans `api_config.dart`
- [ ] Test de connexion réussi
- [ ] Premier login admin effectué

---

## 🎉 Résumé Final

**Votre application Flutter est maintenant :**

✅ **Entièrement intégrée** avec le backend Django  
✅ **Configurée pour le dashboard admin**  
✅ **Prête à développer** les écrans de gestion  
✅ **Évolutive** pour les futures apps mobiles  

**L'admin peut :**
- ✅ Se connecter avec JWT
- ✅ Créer des utilisateurs (Agriculteurs/Agronomes)
- ✅ Configurer la météo (seuils, notifications)
- ✅ Superviser les diagnostics IA
- ✅ Générer des rapports

**Prochaine étape :** Développer les écrans du dashboard en utilisant les services fournis !

Bon développement ! 🚜🌾
