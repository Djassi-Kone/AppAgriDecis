import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class AiService {
  Future<Map<String, dynamic>> chat({
    required String accessToken,
    required String message,
    int? sessionId,
    File? attachment,
  }) async {
    final req = http.MultipartRequest('POST', ApiConfig.chat());
    req.headers['Authorization'] = 'Bearer $accessToken';
    req.fields['message'] = message;
    if (sessionId != null) {
      req.fields['session_id'] = '$sessionId';
    }
    if (attachment != null) {
      req.files.add(await http.MultipartFile.fromPath('attachment', attachment.path));
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception('Chat IA échoué (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> diagnostic({
    required String accessToken,
    required File image,
    String? culture,
  }) async {
    final req = http.MultipartRequest('POST', ApiConfig.diagnostic());
    req.headers['Authorization'] = 'Bearer $accessToken';
    if (culture != null && culture.isNotEmpty) {
      req.fields['culture'] = culture;
    }
    req.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception('Diagnostic échoué (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> diagnosticHistory({required String accessToken}) async {
    final res = await http.get(
      ApiConfig.diagnosticHistory(),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $accessToken'},
    );
    if (res.statusCode != 200) {
      throw Exception('Historique diagnostic indisponible (${res.statusCode})');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }
}

