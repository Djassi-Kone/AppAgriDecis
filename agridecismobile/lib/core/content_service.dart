import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class ContentService {
  final AuthService _auth = AuthService();

  /// Liste tous les contenus (optionnel: filtrer par kind: video, audio, text)
  Future<List<Map<String, dynamic>>> list({String? kind}) async {
    final uri = kind != null && kind.isNotEmpty
        ? ApiConfig.uri('/api/contents/', {'kind': kind})
        : ApiConfig.contentsList();
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );
    if (res.statusCode != 200) throw Exception('Liste contenus: ${res.statusCode}');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Détail d'un contenu
  Future<Map<String, dynamic>> get(int id) async {
    final res = await http.get(
      ApiConfig.contentDetail(id),
      headers: {'Accept': 'application/json'},
    );
    if (res.statusCode != 200) throw Exception('Contenu: ${res.statusCode}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Créer un contenu (agronome). text pour kind=text; file pour video/audio.
  Future<Map<String, dynamic>> create({
    required String title,
    String description = '',
    required String kind,
    String? text,
    File? file,
  }) async {
    final token = await _auth.getAccessToken();
    if (token == null) throw Exception('Connectez-vous pour ajouter un contenu');

    final uri = ApiConfig.contentsList();
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['kind'] = kind;
    if (text != null && text.isNotEmpty) request.fields['text'] = text;

    if (file != null) {
      final name = file.path.split(RegExp(r'[/\\]')).last;
      request.files.add(await http.MultipartFile.fromPath('media_file', file.path, filename: name));
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 201) {
      final body = res.body;
      throw Exception(body.isNotEmpty ? body : 'Création contenu: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Supprimer un contenu (agronome)
  Future<void> delete(int id) async {
    final token = await _auth.getAccessToken();
    if (token == null) throw Exception('Connectez-vous pour supprimer');
    final res = await http.delete(
      ApiConfig.contentDelete(id),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 204 && res.statusCode != 200) throw Exception('Suppression: ${res.statusCode}');
  }

  /// URL absolue du fichier media
  static String mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return ApiConfig.mediaUrl(path);
  }
}
