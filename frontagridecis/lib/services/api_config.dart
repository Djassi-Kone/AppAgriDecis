// import'package:flutter/foundation.dart';

// class ApiConfig {
//   // URL de base - À modifier selon l'environnement
//   static const String _devBaseUrl = 'http://10.0.2.2:8000'; // Android Emulator
//   static const String_webBaseUrl = 'http://localhost:8000'; // Web
//   static const String _prodBaseUrl = 'https://votre-api-production.com';
  
//   static String get baseUrl {
//     if (kDebugMode) {
//       // En mode développement
//       return _devBaseUrl;
//     }
//     return _prodBaseUrl;
//   }

//   // Endpoints d'authentification
//   static String get loginEndpoint => '$baseUrl/api/login/';
//   static String get inscriptionEndpoint => '$baseUrl/api/inscription/';
//   static String get refreshEndpoint => '$baseUrl/api/refresh/';
//   static String get passwordResetRequestEndpoint => '$baseUrl/api/password-reset/request/';
//   static String get passwordResetConfirmEndpoint => '$baseUrl/api/password-reset/confirm/';
//   static String get monProfilEndpoint => '$baseUrl/api/mon-profil/';
//   static String get monHistoriqueEndpoint => '$baseUrl/api/mon-historique/';

  

//   // Endpoints Météo
//   static String get previsionsEndpoint => '$baseUrl/api/meteo/previsions/';
//   static String get seuilsAlerteEndpoint => '$baseUrl/api/meteo/seuils-alerte/';
//   static String get parametresNotificationsEndpoint => '$baseUrl/api/meteo/parametres-notifications/';

//   // Endpoints Diagnostic IA
//   static String get diagnosticImageEndpoint => '$baseUrl/api/ia/diagnostic-image/';
//   static String get mesDiagnosticsEndpoint => '$baseUrl/api/ia/mes-diagnostics/';
//   static String detailDiagnosticEndpoint(String id) => '$baseUrl/api/ia/diagnostic/$id/';
//   static String get chatConseilsEndpoint => '$baseUrl/api/ia/chat-conseils/';

//   // Headers communs
//   static Map<String, String> headers({String? token}) {
//     final baseHeaders = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     if (token != null && token.isNotEmpty) {
//       baseHeaders['Authorization'] = 'Bearer $token';
//     }
//     return baseHeaders;
//   }

//   // Headers pour upload de fichiers
//   static Map<String, String> uploadHeaders({String? token}) {
//     final baseHeaders = {
//       'Accept': 'application/json',
//     };
//     if (token != null && token.isNotEmpty) {
//       baseHeaders['Authorization'] = 'Bearer $token';
//     }
//     return baseHeaders;
//   }
// }



import 'package:flutter/foundation.dart';

class ApiConfig {
  // ================= BASE URL =================

  static const String _devBaseUrlAndroid = 'http://10.0.2.2:8000';
  static const String _devBaseUrlWeb = 'http://localhost:8000';
  static const String _prodBaseUrl = 'https://votre-api-production.com';

  static String get baseUrl {
    if (kDebugMode) {
      // Web ou Desktop
      if (kIsWeb) {
        return _devBaseUrlWeb;
      }
      // Android Emulator
      return _devBaseUrlAndroid;
    }
    return _prodBaseUrl;
  }

  // ================= AUTH =================

  static String get loginEndpoint => '$baseUrl/api/login/';
  static String get inscriptionEndpoint => '$baseUrl/api/inscription/';
  static String get refreshEndpoint => '$baseUrl/api/refresh/';
  static String get meEndpoint => '$baseUrl/api/mon-profil/';
  static String get monProfilEndpoint => '$baseUrl/api/mon-profil/';

  static String get passwordResetRequestEndpoint =>
      '$baseUrl/api/password-reset/request/';

  static String get passwordResetConfirmEndpoint =>
      '$baseUrl/api/password-reset/confirm/';

  static String get monHistoriqueEndpoint =>
      '$baseUrl/api/mon-historique/';

  // ================= ADMIN =================

  static String get adminUsersEndpoint =>
      '$baseUrl/api/admin/users/';

  static String toggleUserEndpoint(String userId) =>
      '$baseUrl/api/admin/users/$userId/toggle/';

  static String deleteUserEndpoint(String userId) =>
      '$baseUrl/api/admin/users/$userId/delete/';

  // ================= CONTENT =================

  static String get contentsEndpoint =>
      '$baseUrl/api/contents/';

  // ================= REPORTS =================

  static String get reportsEndpoint =>
      '$baseUrl/api/reports/';

  // ================= ADVICES =================

  static String get advicesEndpoint =>
      '$baseUrl/api/advices/';

  // ================= METEO =================

  static String get previsionsEndpoint =>
      '$baseUrl/api/meteo/previsions/';

  static String get seuilsAlerteEndpoint =>
      '$baseUrl/api/meteo/seuils-alerte/';

  static String get parametresNotificationsEndpoint =>
      '$baseUrl/api/meteo/parametres-notifications/';

  // ================= IA =================

  static String get diagnosticImageEndpoint =>
      '$baseUrl/api/ia/diagnostic-image/';

  static String get mesDiagnosticsEndpoint =>
      '$baseUrl/api/ia/mes-diagnostics/';

  static String detailDiagnosticEndpoint(String id) =>
      '$baseUrl/api/ia/diagnostic/$id/';

  static String get chatConseilsEndpoint =>
      '$baseUrl/api/ia/chat-conseils/';

  // ================= HEADERS =================

  static Map<String, String> headers({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Map<String, String> uploadHeaders({String? token}) {
    final headers = {
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}