// Configuration spécifique pour le Dashboard Admin
// ===================================================

class AdminConfig {
  // Routes du dashboard admin
  static const String routeHome= '/admin-dashboard';
  static const String routeUsers = '/admin-users';
  static const String routeWeather= '/admin-weather';
  static const String routeDiagnostics = '/admin-diagnostics';
  static const String routeSettings = '/admin-settings';
  
  // Permissions Admin
  static const bool canManageUsers = true;
  static const bool canManageWeatherThresholds = true;
  static const bool canManageNotifications = true;
  static const bool canViewAllDiagnostics = true;
  static const bool canViewReports = true;
  
  // Features disponibles pour Admin
  static const List<String> availableFeatures = [
    'Gestion des utilisateurs',
    'Seuils d\'alerte météo',
    'Paramètres de notification',
    'Diagnostics IA (tous agriculteurs)',
    'Rapports et statistiques',
    'Historique des actions',
  ];
  
  // Note: L'admin est créé par défaut dans la base de données
  // Il peut modifier ses identifiants plus tard depuis son profil
}
