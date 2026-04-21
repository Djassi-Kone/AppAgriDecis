import 'package:flutter/foundation.dart';

class ApiConfig {
  // ================= BASE URL =================

  static const String _devBaseUrlAndroid = 'http://10.211.99.210:8000';
  static const String _devBaseUrlWeb = 'http://10.211.99.210:8000';
  static const String _prodBaseUrl = 'https://10.211.99.210:8000';

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

  static String get loginEndpoint => '$baseUrl/api/users/auth/login/';
  static String get inscriptionEndpoint => '$baseUrl/api/users/auth/register/';
  static String get refreshEndpoint => '$baseUrl/api/users/auth/token/refresh/';
  static String get meEndpoint => '$baseUrl/api/users/auth/me/';
  static String get monProfilEndpoint => '$baseUrl/api/profile/';

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
      '$baseUrl/api/admin/users/toggle/$userId/';

  static String deleteUserEndpoint(String userId) =>
      '$baseUrl/api/admin/users/delete/$userId/';

  // ================= CONTENT =================

  static String get contentsEndpoint =>
      '$baseUrl/api/contents/';

  static String get myContentsEndpoint =>
      '$baseUrl/api/contents/my-contents/';

  static String get myContentsAnalyticsEndpoint =>
      '$baseUrl/api/contents/my-contents/analytics/';

  static String contentCommentsEndpoint(String contentId) =>
      '$baseUrl/api/contents/$contentId/comments/';

  static String contentLikeEndpoint(String contentId) =>
      '$baseUrl/api/contents/$contentId/like/';

  static String contentViewEndpoint(String contentId) =>
      '$baseUrl/api/contents/$contentId/view/';

  static String get adminAllContentsEndpoint =>
      '$baseUrl/api/contents/admin/all/';

  static String adminDeleteContentEndpoint(String contentId) =>
      '$baseUrl/api/contents/admin/$contentId/delete/';

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
      '$baseUrl/api/ai/diagnosis/';

  static String get mesDiagnosticsEndpoint =>
      '$baseUrl/api/ai/diagnosis/';

  static String detailDiagnosticEndpoint(String id) =>
      '$baseUrl/api/ai/diagnosis/$id/';

  static String get chatConseilsEndpoint =>
      '$baseUrl/api/ai/chat/';

  static String get chatHistoryEndpoint =>
      '$baseUrl/api/ai/chat/history/';

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