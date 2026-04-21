import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content.dart';
import 'api_config.dart';

class ContentService {
  static Future<List<Content>> getContents() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.contentsEndpoint),
        headers: ApiConfig.headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> contentsJson;
        
        // Gérer les différents formats de réponse
        if (data is List) {
          // Format direct: liste de contenus
          contentsJson = data;
        } else if (data is Map) {
          if (data['success'] == true) {
            // Format enveloppé: {success: true, data: [...]}
            contentsJson = data['data'];
          } else if (data['results'] != null) {
            // Format Django REST Framework: {count, next, previous, results: [...]}
            contentsJson = data['results'];
          } else {
            throw Exception(data['message'] ?? 'Format de réponse invalide');
          }
        } else {
          throw Exception('Format de réponse invalide');
        }
        
        return contentsJson.map((json) => Content.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<List<Content>> getMyContents(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.myContentsEndpoint),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> contentsJson = data['data'];
          return contentsJson.map((json) => Content.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Erreur lors de la récupération de vos contenus');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<Content> getContentDetail(int contentId, {String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.contentsEndpoint}$contentId/'),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Content.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Erreur lors de la récupération du contenu');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<bool> likeContent(int contentId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.contentsEndpoint}$contentId/like/'),
        headers: ApiConfig.headers(token: token),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<bool> unlikeContent(int contentId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.contentsEndpoint}$contentId/like/'),
        headers: ApiConfig.headers(token: token),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<Content> createContent(Map<String, dynamic> contentData, String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.contentsEndpoint),
        headers: ApiConfig.headers(token: token),
        body: json.encode(contentData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Content.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Erreur lors de la création du contenu');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }
}
