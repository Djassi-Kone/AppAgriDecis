import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class AdminApiService {
  Map<String, String> _authHeaders(String token) => ApiConfig.headers(token: token);

  Future<List<dynamic>> listUsers(String token) async {
    final res = await http.get(Uri.parse(ApiConfig.adminUsersEndpoint), headers: _authHeaders(token));
    if (res.statusCode != 200) {
      throw Exception('Erreur liste utilisateurs (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> toggleUser(String token, String userId) async {
    final res = await http.post(
      Uri.parse(ApiConfig.toggleUserEndpoint(userId)),
      headers: _authHeaders(token),
    );
    if (res.statusCode != 200) {
      throw Exception('Erreur toggle utilisateur (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> deleteUser(String token, String userId) async {
    final res = await http.delete(
      Uri.parse(ApiConfig.deleteUserEndpoint(userId)),
      headers: _authHeaders(token),
    );
    if (res.statusCode != 200) {
      throw Exception('Erreur suppression utilisateur (${res.statusCode})');
    }
  }

  Future<List<dynamic>> listContents(String token) async {
    final res = await http.get(Uri.parse(ApiConfig.contentsEndpoint), headers: _authHeaders(token));
    if (res.statusCode != 200) {
      throw Exception('Erreur liste contenus (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<List<dynamic>> listReports(String token) async {
    final res = await http.get(Uri.parse(ApiConfig.reportsEndpoint), headers: _authHeaders(token));
    if (res.statusCode != 200) {
      throw Exception('Erreur liste signalements (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> resolveReport(String token, String reportId) async {
    final res = await http.patch(
      Uri.parse('${ApiConfig.reportsEndpoint}$reportId/'),
      headers: _authHeaders(token),
      body: jsonEncode({'resolved': true}),
    );
    if (res.statusCode != 200) {
      throw Exception('Erreur résolution signalement (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> deleteReport(String token, String reportId) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.reportsEndpoint}$reportId/'),
      headers: _authHeaders(token),
    );
    if (res.statusCode != 204 && res.statusCode != 200) {
      throw Exception('Erreur suppression signalement (${res.statusCode})');
    }
  }

  Future<List<dynamic>> listAdvices(String token) async {
    final res = await http.get(Uri.parse(ApiConfig.advicesEndpoint), headers: _authHeaders(token));
    if (res.statusCode != 200) {
      throw Exception('Erreur liste conseils (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<void> deleteAdvice(String token, String adviceId) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.advicesEndpoint}$adviceId/'),
      headers: _authHeaders(token),
    );
    if (res.statusCode != 204 && res.statusCode != 200) {
      throw Exception('Erreur suppression conseil (${res.statusCode})');
    }
  }
}

