import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Sur téléphone physique, mets l'IP de ton PC (ex: http://192.168.1.10:8000).
  /// Sur émulateur Android laisse null (10.0.2.2 sera utilisé).
  static const String? baseUrlOverride = null;

  static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:8000';
  static const String _localBaseUrl = 'http://127.0.0.1:8000';

  static String get baseUrl {
    if (baseUrlOverride != null && baseUrlOverride!.isNotEmpty) {
      return baseUrlOverride!.endsWith('/') ? baseUrlOverride!.substring(0, baseUrlOverride!.length - 1) : baseUrlOverride!;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidEmulatorBaseUrl;
    }
    return _localBaseUrl;
  }

  static Uri uri(String path, [Map<String, String>? query]) {
    final base = Uri.parse(baseUrl);
    return base.replace(path: path.startsWith('/') ? path : '/$path', queryParameters: query);
  }

  // Auth
  static Uri register() => uri('/api/auth/register/');
  static Uri login() => uri('/api/auth/login/');
  static Uri me() => uri('/api/auth/me/');
  static Uri profile() => uri('/api/profile/');

  // Weather
  static Uri weatherForecast({required double lat, required double lon}) =>
      uri('/api/weather/forecast/', {'lat': '$lat', 'lon': '$lon'});

  // IA
  static Uri diagnostic() => uri('/api/diagnostic/');
  static Uri diagnosticHistory() => uri('/api/diagnostic/history/');
  static Uri chat() => uri('/api/ai/chat/');
  static Uri chatHistory({required int sessionId}) =>
      uri('/api/ai/chat/history/', {'session_id': '$sessionId'});

  // Contenus (vidéo, audio, texte)
  static Uri contentsList() => uri('/api/contents/');
  static Uri contentDetail(int id) => uri('/api/contents/$id/');
  static Uri contentDelete(int id) => uri('/api/contents/$id/');

  /// URL absolue pour un fichier media (ex: /media/contents/xxx.mp4)
  static String mediaUrl(String path) {
    if (path.isEmpty) return '';
    final base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    return path.startsWith('http') ? path : base + (path.startsWith('/') ? path.substring(1) : path);
  }
}

