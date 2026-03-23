# 🎯 AgriDecis - Dashboard Admin Flutter

## 📋 Vue d'Ensemble

Cette application Flutter est le **dashboard administrateur** pour AgriDecis. Elle permet à l'administrateur de :

- ✅ Gérer les utilisateurs (Agriculteurs, Agronomes)
- ✅ Configurer les seuils d'alerte météo
- ✅ Superviser les paramètres de notification
- ✅ Consulter tous les diagnostics IA
- ✅ Voir l'historique des actions
- ✅ Générer des rapports

---

## 🔐 Authentification Admin

### Compte Admin par Défaut

L'administrateur est **créé automatiquement** dans la base de données Django lors de la première migration ou via une commande de gestion.

**Pour créer/modifier l'admin :**

```bash
# Dans le dossier backend AgriDecis
python manage.py shell

# Créer ou modifier l'admin
from users.models import Administrateur
admin = Administrateur.objects.first()
if admin:
    # Modifier les identifiants
    admin.email = 'nouvel.email@agridecis.com'
    admin.set_password('nouveau_mot_de_passe')
    admin.save()
```

### Connexion depuis Flutter

```dart
import'package:provider/provider.dart';
import '../providers/auth_provider.dart';

final authProvider= Provider.of<AuthProvider>(context, listen: false);

// Connexion avec les identifiants admin
await authProvider.login('admin@agridecis.com', 'mot_de_passe');

if (authProvider.isAuthenticated && authProvider.isAdmin) {
  // Redirection vers le dashboard admin
  Navigator.pushReplacementNamed(context, '/admin-dashboard');
}
```

---

## 🏗️ Architecture du Code

### Structure des Dossiers

```
lib/
├── config/
│   └── admin_config.dart          # Configuration spécifique admin
├── models/
│   └── user.dart                   # Modèle utilisateur (Admin, etc.)
├── providers/
│   └── auth_provider.dart          # State management auth
├── services/
│   ├── api_config.dart             # URLs des endpoints
│   ├── auth_service.dart           # Authentification
│   ├── inscription_service.dart    # Inscription (pour créer utilisateurs)
│   ├── password_reset_service.dart # Réinitialisation mot de passe
│   ├── weather_service.dart        # API Météo (seuils, notifications)
│   └── diagnostic_service.dart     # API IA (diagnostics, chat)
└── widgets/
    └── admin_only_widget.dart      # Widget réservé aux admins
```

### Services Disponibles pour l'Admin

#### 1. **Gestion des Utilisateurs**
```dart
import '../services/inscription_service.dart';

final inscriptionService = InscriptionService();

// Créer un nouvel agriculteur
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
  specialite: 'Conseil en agriculture durable',
);
```

#### 2. **Configuration Météo**
```dart
import '../services/weather_service.dart';
import '../services/auth_service.dart';

final weatherService = WeatherService();
final authService = AuthService();
final token = await authService.getAccessToken();

// Récupérer les seuils d'alerte
final seuils = await weatherService.getSeuilsAlerte(token);

// Mettre à jour les seuils
await weatherService.updateSeuilsAlerte(token, [
  {'id': 1, 'valeurSeuil': 30.0, 'actif': true},
  {'id': 2, 'valeurSeuil': 15.0, 'actif': true},
]);

// Récupérer les paramètres de notification
final params = await weatherService.getParametresNotifications(token);

// Mettre à jour les paramètres
await weatherService.updateParametresNotifications(token, {
  'notification_email': 'true',
  'frequence_notifications': 'quotidien',
});
```

#### 3. **Supervision des Diagnostics IA**
```dart
import '../services/diagnostic_service.dart';

final diagnosticService = DiagnosticService();
final token = await authService.getAccessToken();

// Voir tous les diagnostics (tous agriculteurs)
final diagnostics = await diagnosticService.getMesDiagnostics(
  token,
  page: 1,
  pageSize: 50,
);

// Voir le détail d'un diagnostic
final detail = await diagnosticService.getDetailDiagnostic(
  token,
  diagnosticId.toString(),
);

print('Diagnostic: ${detail['resume']}');
print('Score: ${detail['scoreConfiance']}');
print('Agriculteur: ${detail['agriculteur_nom']}');
```

---

## 🎨 Widgets Spécifiques Admin

### Utiliser `AdminOnly` Widget

```dart
import '../widgets/admin_only_widget.dart';

// Dans votre UI
AdminOnly(
  child: ElevatedButton(
    onPressed: () {
      // Action réservée aux admins
    },
    child: Text('Gérer les utilisateurs'),
  ),
  fallback: Text('Fonctionnalité non disponible'),
)
```

### Vérifier les Permissions

```dart
import '../widgets/admin_only_widget.dart';

if (AdminPermissions.canManageUsers()) {
  // Afficher le bouton de gestion des utilisateurs
}

if (AdminPermissions.canManageWeather()) {
  // Afficher la configuration des seuils météo
}

final features = AdminPermissions.getAvailableFeatures();
print('Fonctionnalités disponibles: $features');
```

---

## 📱 Routes du Dashboard Admin

Configurez vos routes dans `main.dart` ou `app_routes.dart` :

```dart
Map<String, WidgetBuilder> getAdminRoutes() {
 return {
    '/admin-dashboard': (context) => AdminDashboardScreen(),
    '/admin-users': (context) => UserManagementScreen(),
    '/admin-weather': (context) => WeatherConfigScreen(),
    '/admin-diagnostics': (context) => DiagnosticsScreen(),
    '/admin-settings': (context) => AdminSettingsScreen(),
  };
}
```

---

## 🔒 Sécurité et Permissions

### Ce que l'Admin Peut Faire

✅ **Gestion des utilisateurs**
- Créer des Agriculteurs et Agronomes
- Modifier les comptes
- Désactiver/réactiver des comptes
- Voir l'historique des actions

✅ **Configuration Météo**
- Définir les seuils d'alerte
- Configurer les notifications
- Ajuster les paramètres globaux

✅ **Supervision IA**
- Voir tous les diagnostics (tous agriculteurs)
- Accéder aux résultats détaillés
- Consulter l'historique complet

✅ **Rapports**
- Générer des statistiques
- Exporter les données
- Analyser les tendances

### Ce que l'Admin Ne Peut PAS Faire

❌ Se connecter comme un Agriculteur/Agronome  
❌ Modifier les diagnostics IA (lecture seule)  
❌ Supprimer des données critiques sans confirmation  

---

## 🛠️ Développement Futur

### Prochaines Étapes

1. **Dashboard Admin (Priorité Actuelle)**
   - [ ] Écran de connexion
   - [ ] Dashboard principal avec statistiques
   - [ ] Gestion des utilisateurs (CRUD)
   - [ ] Configuration des seuils météo
   - [ ] Visualisation des diagnostics
   - [ ] Rapports et exports

2. **Applications Mobiles (Plus Tard)**
   - [ ] App mobile pour Agriculteurs
   - [ ] App mobile pour Agronomes
   - [ ] Fonctionnalités spécifiques par rôle

---

## 💡 Bonnes Pratiques

### 1. Toujours Vérifier le Rôle

```dart
if (!authProvider.isAdmin) {
  // Rediriger ou afficher erreur
 return AccessDeniedScreen();
}
```

### 2. Gérer les Tokens Securement

```dart
// Le token est automatiquement géré par AuthService
// Utilisez simplement :
final token = await authService.getAccessToken();
```

### 3. Logger les Actions Importantes

```dart
// L'historique est automatiquement géré par le backend
// Mais vous pouvez ajouter des logs côté frontend pour le débogage
debugPrint('Admin a modifié les seuils météo');
```

---

## 📞 Support et Questions

### Comment créer le premier admin ?

Voir la section "Compte Admin par Défaut" ci-dessus.

### Comment changer les identifiants admin ?

L'admin peut modifier son email et mot de passe depuis son profil dans le dashboard.

### Puis-je avoir plusieurs admins ?

Oui, il suffit de créer plusieurs instances de `Administrateur` dans la base de données.

---

## 🚀 Résumé

**Cette application Flutter est LE dashboard administrateur pour AgriDecis.**

- ✅ Auth JWT sécurisée
- ✅ Gestion automatique des tokens
- ✅ Services prêts à l'emploi
- ✅ Widgets spécifiques admin
- ✅ Documentation complète

**Prochaine étape :** Développer les écrans du dashboard en utilisant les services fournis !

Bon développement ! 🎉
