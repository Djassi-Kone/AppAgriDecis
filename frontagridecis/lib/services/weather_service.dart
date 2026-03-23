import'dart:convert';
import'package:flutter/foundation.dart';
import'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/user.dart';

class WeatherService {
  /// Récupérer les prévisions météo
  Future<Map<String, dynamic>> getPrevisions({
  String? token,
   double? lat,
   double? lon,
   String? ville,
   int jours = 7,
  }) async {
    try {
   final queryParams = <String, String>{
        'jours': jours.toString(),
      };

      if (lat != null && lon != null) {
       queryParams['lat'] = lat.toString();
       queryParams['lon'] = lon.toString();
      } else if (ville != null && ville.isNotEmpty) {
       queryParams['ville'] = ville;
      }

   final uri = Uri.parse(ApiConfig.previsionsEndpoint).replace(
        queryParameters: queryParams,
      );

   final response = await http.get(
        uri,
    headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
   final data = json.decode(response.body);
      if (data['success'] == true) {
      return {
          'previsions': data['previsions'],
         'alertes': data['alertes'] ?? [],
        };
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la récupération des prévisions');
      }
      } else {
   final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur serveur');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au service météo');
      }
  rethrow;
    }
  }

  /// Récupérer les seuils d'alerte (Admin uniquement)
  Future<List<dynamic>> getSeuilsAlerte(String token) async {
    try {
  final response = await http.get(
        Uri.parse(ApiConfig.seuilsAlerteEndpoint),
    headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
   final data = json.decode(response.body);
      if (data['success'] == true) {
      return data['seuils'] ?? [];
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la récupération des seuils');
      }
      } else {
   final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur serveur');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
 rethrow;
    }
  }

  /// Mettre à jour les seuils d'alerte (Admin uniquement)
  Future<bool> updateSeuilsAlerte(String token, List<Map<String, dynamic>> seuils) async {
    try {
  final response = await http.patch(
        Uri.parse(ApiConfig.seuilsAlerteEndpoint),
    headers: ApiConfig.headers(token: token),
    body: json.encode(seuils),
      );

      if (response.statusCode == 200) {
   final data = json.decode(response.body);
     return data['success'] == true;
      } else {
   final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
 rethrow;
    }
  }

  /// Récupérer les paramètres de notification (Admin uniquement)
  Future<Map<String, String>> getParametresNotifications(String token) async {
    try {
  final response = await http.get(
        Uri.parse(ApiConfig.parametresNotificationsEndpoint),
    headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
   final data = json.decode(response.body);
      if (data['success'] == true) {
      final params = <String, String>{};
       for (var param in(data['parametres'] ?? [])) {
        params[param['cle']] = param['valeur'];
       }
      return params;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la récupération des paramètres');
      }
      } else {
   final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur serveur');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
 rethrow;
    }
  }

  /// Mettre à jour les paramètres de notification (Admin uniquement)
  Future<bool> updateParametresNotifications(String token, Map<String, String> parametres) async {
    try {
  final response = await http.patch(
        Uri.parse(ApiConfig.parametresNotificationsEndpoint),
    headers: ApiConfig.headers(token: token),
    body: json.encode(parametres),
      );

      if (response.statusCode == 200) {
   final data = json.decode(response.body);
     return data['success'] == true;
      } else {
   final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
 rethrow;
    }
  }
}
