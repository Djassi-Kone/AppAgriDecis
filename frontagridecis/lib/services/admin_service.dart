import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'api_config.dart';

class AdminService {
  static Future<List<User>> getUsers({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.adminUsersEndpoint),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> usersJson;
        
        if (data is List) {
          usersJson = data;
        } else if (data is Map && data['results'] != null) {
          usersJson = data['results'];
        } else if (data is Map && data['success'] == true) {
          usersJson = data['data'];
        } else {
          throw Exception('Format de réponse invalide');
        }
        
        return usersJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<List<dynamic>> getContents({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.adminAllContentsEndpoint),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> contentsJson;
        
        if (data is List) {
          contentsJson = data;
        } else if (data is Map && data['results'] != null) {
          contentsJson = data['results'];
        } else if (data is Map && data['success'] == true) {
          contentsJson = data['data'];
        } else {
          throw Exception('Format de réponse invalide');
        }
        
        return contentsJson;
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<bool> toggleUser(String userId, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.toggleUserEndpoint(userId)),
        headers: ApiConfig.headers(token: token),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<bool> deleteUser(String userId, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.deleteUserEndpoint(userId)),
        headers: ApiConfig.headers(token: token),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getSystemStats({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/stats/'),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }
}
