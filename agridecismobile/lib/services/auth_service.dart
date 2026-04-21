import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'api_config.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _userKey = 'user_data';

  Future<User> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    String? telephone,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.inscriptionEndpoint),
        headers: ApiConfig.headers(),
        body: json.encode({
          'email': email,
          'password': password,
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final user = User.fromJson(data);
        await _saveUserToStorage(user);
        return user;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
      rethrow;
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.headers(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final access = data['access'] as String?;
        final refresh = data['refresh'] as String?;
        if (access == null || refresh == null) {
          throw Exception('Réponse login invalide (tokens manquants)');
        }

        // Récupérer les infos user/role
        final meRes = await http.get(
          Uri.parse(ApiConfig.meEndpoint),
          headers: ApiConfig.headers(token: access),
        );
        if (meRes.statusCode != 200) {
          throw Exception('Connexion OK, mais /me échoue (${meRes.statusCode})');
        }
        final me = json.decode(meRes.body) as Map<String, dynamic>;
        final user = User.fromJson({
          ...me,
          'access': access,
          'refresh': refresh,
        });

        await _saveUserToStorage(user);
        return user;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Email ou mot de passe incorrect');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        final userJson = json.decode(userData);
        return User.fromJson(userJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _clearStorage();
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }

  Future<void> _saveUserToStorage(User user) async {
    final userJson = json.encode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<void> _clearStorage() async {
    await _storage.delete(key: _userKey);
  }

  Future<bool> isTokenValid() async {
    try {
      final user = await getCurrentUser();
      if (user == null || user.accessToken == null) {
        return false;
      }

      final response = await http.get(
        Uri.parse(ApiConfig.meEndpoint),
        headers: ApiConfig.headers(token: user.accessToken!),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
