class ApiConfig {
  // Base URL pour l'API
  static const String baseUrl = "http:// 10.211.99.210:8000/api";
  
  // Endpoints d'authentification
  static const String loginEndpoint = "$baseUrl/users/auth/login/";
  static const String registerEndpoint = "$baseUrl/users/auth/register/";
  static const String refreshEndpoint = "$baseUrl/users/auth/token/refresh/";
  static const String meEndpoint = "$baseUrl/users/auth/me/";
  
  // Endpoints des contenus
  static const String contentsEndpoint = "$baseUrl/contents/";
  static const String myContentsEndpoint = "$baseUrl/contents/my-contents/";
  static const String myContentsAnalyticsEndpoint = "$baseUrl/contents/my-contents/analytics/";
  
  // Endpoints météo
  static const String weatherForecastEndpoint = "$baseUrl/weather/weather/forecast/";
  static const String weatherAlertsEndpoint = "$baseUrl/weather/weather/alerts/";
  static const String weatherCurrentEndpoint = "$baseUrl/weather/weather/current/";
  
  // Endpoints IA
  static const String aiDiagnosisEndpoint = "$baseUrl/ai/diagnosis/";
  static const String aiChatEndpoint = "$baseUrl/ai/chat/";
  static const String aiChatHistoryEndpoint = "$baseUrl/ai/chat/history/";
  
  // Headers par défaut
  static Map<String, String> headers({String? token}) {
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }
    
    return defaultHeaders;
  }
  
  // URL pour les fichiers médias
  static String mediaUrl(String path) {
    return "$baseUrl/media/$path";
  }
  
  // Configuration timeout
  static const int connectionTimeout = 30000; // 30 secondes
  static const int receiveTimeout = 30000;    // 30 secondes
}
