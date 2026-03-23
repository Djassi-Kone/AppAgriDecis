import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'session.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';
  static const _keyRole = 'user_role';
  static const _keyEmail = 'user_email';

  Future<SessionUser> login({required String email, required String password}) async {
    final res = await http.post(
      ApiConfig.login(),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception('Connexion échouée (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final access = data['access'] as String?;
    final refresh = data['refresh'] as String?;
    if (access == null || refresh == null) {
      throw Exception('Réponse login invalide (tokens manquants)');
    }

    // récupérer le rôle via /me
    final meRes = await http.get(
      ApiConfig.me(),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $access'},
    );
    if (meRes.statusCode != 200) {
      throw Exception('Connexion OK, mais /me échoue (${meRes.statusCode})');
    }
    final me = jsonDecode(meRes.body) as Map<String, dynamic>;
    final role = me['role'] as String?;
    final meEmail = (me['email'] ?? email) as String;

    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
    await _storage.write(key: _keyRole, value: role ?? '');
    await _storage.write(key: _keyEmail, value: meEmail);

    return SessionUser(email: meEmail, accessToken: access, refreshToken: refresh, role: role);
  }

  Future<void> register({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String password,
    required String role, // 'agriculteur' | 'agronome'
  }) async {
    final res = await http.post(
      ApiConfig.register(),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'telephone': telephone,
        'password': password,
        'role': role,
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Inscription échouée (${res.statusCode})');
    }
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccess);

  Future<String?> getRole() async {
    final role = await _storage.read(key: _keyRole);
    if (role == null || role.isEmpty) return null;
    return role;
  }

  Future<void> logout() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
    await _storage.delete(key: _keyRole);
    await _storage.delete(key: _keyEmail);
  }
}

