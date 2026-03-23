import'dart:convert';
import'package:flutter/foundation.dart';
import'package:flutter_secure_storage/flutter_secure_storage.dart';
import'package:http/http.dart' as http;
import '../models/user.dart';
import 'api_config.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _userKey = 'user_data';

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
        throw Exception(error['errors']?['nonFieldErrors']?.first ?? 
                       error['message'] ?? 'Email ou mot de passe incorrect');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
     rethrow;
    }
  }

  Future<User> refreshToken(String refreshToken) async {
    try {
     final response = await http.post(
        Uri.parse(ApiConfig.refreshEndpoint),
       headers: ApiConfig.headers(),
       body: json.encode({
          'refresh': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final currentUser = await getCurrentUser();
        if (currentUser == null) throw Exception('Utilisateur non trouvé');

        final updatedUser = currentUser.copyWith(
          accessToken: data['access'],
          refreshToken: refreshToken,
        );
        await _saveUserToStorage(updatedUser);
        return updatedUser;
      } else {
       final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Token expiré ou invalide');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de rafraîchir le token');
      }
     rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _clearStorage();
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
     final userData = await _storage.read(key: _userKey);
      if (userData != null) {
       return User.fromJson(json.decode(userData));
      }
     return null;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'utilisateur: ${e.toString()}');
     return null;
    }
  }

  Future<String?> getAccessToken() async {
    try {
     final user = await getCurrentUser();
      if (user != null) {
       return user.accessToken;
      }
     return null;
    } catch (e) {
      debugPrint('Erreur lors de la récupération du token: ${e.toString()}');
     return null;
    }
  }

  Future<bool> isTokenValid() async {
    try {
     final user = await getCurrentUser();
      if (user == null || user.accessToken == null) return false;
      return true;
    } catch (e) {
     return false;
    }
  }

  Future<void> _saveUserToStorage(User user) async {
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  Future<void> _clearStorage() async {
    await _storage.deleteAll();
  }
}
