# Documentation Complète AgriDecis

## Table des Matières
1. [Installation et Démarrage](#installation-et-démarrage)
2. [Architecture du Système](#architecture-du-système)
3. [Guide Utilisateur](#guide-utilisateur)
4. [API Documentation](#api-documentation)
5. [Dépannage](#dépannage)
6. [Développement](#développement)

---

## Installation et Démarrage

### Prérequis
- Python 3.11+
- Flutter 3.0+
- Node.js (optionnel pour certains outils)

### Backend Django

1. **Naviguer vers le dossier backend**
```bash
cd back_agridecis
```

2. **Installer les dépendances**
```bash
pip install -r requirements.txt
```

3. **Exécuter les migrations**
```bash
python manage.py makemigrations
python manage.py migrate
```

4. **Démarrer le serveur**
```bash
python manage.py runserver
```

Le serveur sera disponible sur: `http://127.0.0.1:8000`

### Frontend Flutter Web

1. **Naviguer vers le dossier frontend**
```bash
cd frontagridecis
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Démarrer l'application**
```bash
flutter run -d chrome
```

### Frontend Flutter Mobile

1. **Naviguer vers le dossier mobile**
```bash
cd agridecismobile
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Démarrer l'application**
```bash
flutter run -d chrome  # Pour le web
# ou
flutter run            # Pour un appareil mobile
```

---

## Architecture du Système

### Backend (Django REST Framework)

#### Modules Principaux
- **users**: Gestion des utilisateurs et rôles
- **weather**: API météo avec Open-Meteo
- **contents**: Gestion des contenus agricoles
- **ai**: Services IA (diagnostic, chat)
- **reports**: Rapports et analytics

#### Rôles Utilisateurs
1. **Admin**: Gestion complète du système
2. **Agronome**: Crée et gère les contenus
3. **Agriculteur**: Consulte les contenus et interagit

#### Base de Données
- SQLite pour le développement
- Modèles Django avec relations

### Frontend (Flutter)

#### Structure
- **lib/**: Code source principal
- **services/**: Services API
- **screens/**: Écrans de l'application
- **widgets/**: Composants réutilisables

#### Configuration API
- Base URL configurable selon environnement
- Authentification JWT
- Gestion des erreurs

---

## Guide Utilisateur

### Comptes Prédéfinis

#### Admin
- **Email**: admin@agridecis.com
- **Mot de passe**: Admin123!
- **Accès**: Administration complète

#### Agronome
- **Email**: agronome@agridecis.com
- **Mot de passe**: Agronome123!
- **Fonctions**: 
  - Créer des contenus
  - Voir les analytics
  - Gérer les commentaires

#### Agriculteur
- **Email**: agriculteur@agridecis.com
- **Mot de passe**: Agriculteur123!
- **Fonctions**:
  - Voir les contenus publiés
  - Liker et commenter
  - Accès aux prévisions météo
  - Chat IA pour conseils

### Workflow Utilisateur

#### Pour l'Agronome
1. **Se connecter** avec le compte agronome
2. **Créer du contenu** (articles, guides, alertes)
3. **Publier** pour les agriculteurs
4. **Suivre les analytics** (vues, likes, commentaires)
5. **Répondre aux commentaires**

#### Pour l'Agriculteur
1. **Se connecter** avec le compte agriculteur
2. **Consulter les prévisions météo**
3. **Parcourir les contenus** disponibles
4. **Intéragir** (likes, commentaires)
5. **Utiliser le chat IA** pour conseils personnalisés

---

## API Documentation

### Endpoints Principaux

#### Authentification
```
POST /api/auth/login/
POST /api/auth/register/
POST /api/auth/token/refresh/
GET  /api/auth/me/
```

#### Météo
```
GET  /api/weather/weather/forecast/?lat=X&lon=Y
GET  /api/weather/weather/alerts/?lat=X&lon=Y
GET  /api/weather/weather/current/?lat=X&lon=Y
```

#### Contenus
```
GET    /api/contents/
POST   /api/contents/
GET    /api/contents/{id}/
PUT    /api/contents/{id}/
DELETE /api/contents/{id}/
```

#### IA
```
POST /api/ai/diagnosis/
POST /api/ai/chat/
GET  /api/ai/chat/history/
```

### Exemples d'Utilisation

#### Obtenir les prévisions météo
```bash
curl -X GET "http://127.0.0.1:8000/api/weather/weather/forecast/?lat=14.7&lon=-17.5"
```

#### Connexion utilisateur
```bash
curl -X POST "http://127.0.0.1:8000/api/auth/login/" \
  -H "Content-Type: application/json" \
  -d '{"email": "agriculteur@agridecis.com", "password": "Agriculteur123!"}'
```

---

## Dépannage

### Problèmes Communs

#### Backend ne démarre pas
1. **Vérifier les migrations**: `python manage.py migrate`
2. **Vérifier les dépendances**: `pip install -r requirements.txt`
3. **Vérifier le port**: Assurez-vous que le port 8000 est libre

#### Flutter ne compile pas
1. **Nettoyer le cache**: `flutter clean`
2. **Réinstaller les dépendances**: `flutter pub get`
3. **Vérifier la version Flutter**: `flutter --version`

#### Erreurs de polices (Flutter Web)
1. **Utiliser le renderer HTML**: Configuration automatique
2. **Vérifier la connexion internet**: Pour les polices Google Fonts
3. **Utiliser les polices système**: Fallback configuré

#### API ne répond pas
1. **Vérifier que le backend est démarré**
2. **Vérifier les URLs**: Assurez-vous que les URLs sont correctes
3. **Vérifier CORS**: Configuration dans settings.py

### Messages d'Erreur

#### `ModuleNotFoundError`
- **Cause**: Import manquant ou module non installé
- **Solution**: Installer le module ou corriger l'import

#### `Authentication credentials were not provided`
- **Cause**: Token JWT manquant ou invalide
- **Solution**: Se connecter et utiliser le token

#### `CORS policy: No 'Access-Control-Allow-Origin'`
- **Cause**: Configuration CORS incorrecte
- **Solution**: Vérifier les CORS settings dans Django

---

## Développement

### Ajouter de Nouvelles Fonctionnalités

1. **Backend**: Créer nouveau module Django
2. **Models**: Définir les modèles de données
3. **Views**: Implémenter les vues API
4. **URLs**: Configurer les routes
5. **Frontend**: Créer les services et écrans Flutter

### Déploiement

#### Backend (Production)
- Utiliser PostgreSQL au lieu de SQLite
- Configurer Gunicorn/Nginx
- Variables d'environnement pour la sécurité

#### Frontend (Production)
- Build de production: `flutter build web`
- Déploiement sur serveur web statique
- Configuration CDN pour les assets

### Tests

#### Backend Tests
```bash
python manage.py test
```

#### Frontend Tests
```bash
flutter test
```

### Monitoring

#### Logs Backend
- Emplacement: `logs/django.log`
- Niveau: Configurable dans settings.py

#### Analytics
- Google Analytics (optionnel)
- Monitoring des performances API

---

## Support et Maintenance

### Mises à Jour
1. **Backend**: `pip install -r requirements.txt --upgrade`
2. **Frontend**: `flutter pub get --upgrade`
3. **Migrations**: `python manage.py makemigrations && python manage.py migrate`

### Sauvegarde
- **Base de données**: Export SQLite régulièrement
- **Médias**: Sauvegarder le dossier media/
- **Configuration**: Versionner les fichiers de config

### Sécurité
- **Mots de passe**: Utiliser des mots de passe forts
- **Tokens**: Régénérer les clés secrètes
- **HTTPS**: Activer en production

---

## Contact et Ressources

### Documentation Technique
- [Django Documentation](https://docs.djangoproject.com/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Open-Meteo API](https://open-meteo.com/)

### Communauté
- Issues GitHub pour les bugs
- Documentation mise à jour régulièrement
- Support par email

---

*Ce document est mis à jour régulièrement. Dernière mise à jour: Avril 2026*
