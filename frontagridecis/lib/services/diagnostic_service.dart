import'dart:convert';
import'package:flutter/foundation.dart';
import'package:http/http.dart' as http;
import 'api_config.dart';

class DiagnosticService {
  /// Upload d'une image pour diagnostic IA
  Future<Map<String, dynamic>> uploadDiagnosticImage(String token, String imagePath) async {
    try {
      // Note: Pour un vrai upload de fichier, utiliser le package 'http_parser' et 'multipart'
      // Ceci est une version simplifiée - à adapter selon vos besoins
      throw UnimplementedError('Utilisez un package comme image_picker avec multipart upload');
    } catch (e) {
    rethrow;
    }
  }

  /// Récupérer la liste des diagnostics de l'agriculteur
  Future<List<dynamic>> getMesDiagnostics(String token, {int page = 1, int pageSize = 20}) async {
    try {
  final uri = Uri.parse(ApiConfig.mesDiagnosticsEndpoint).replace(
        queryParameters: {
         'page': page.toString(),
         'page_size': pageSize.toString(),
        },
      );

  final response = await http.get(
        uri,
   headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
  final data = json.decode(response.body);
      if (data['success'] == true) {
     return data['diagnostics'] ?? [];
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la récupération des diagnostics');
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

  /// Récupérer le détail d'un diagnostic
  Future<Map<String, dynamic>> getDetailDiagnostic(String token, String diagnosticId) async {
    try {
  final response = await http.get(
        Uri.parse(ApiConfig.detailDiagnosticEndpoint(diagnosticId)),
   headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
  final data = json.decode(response.body);
      if (data['success'] == true) {
     return data['diagnostic'];
      } else {
        throw Exception(data['message'] ?? 'Diagnostic non trouvé');
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

  /// Envoyer un message au chat de conseils agricoles
  Future<String> sendChatMessage(String token, String message, {List<dynamic>? historique}) async {
    try {
  final response = await http.post(
        Uri.parse(ApiConfig.chatConseilsEndpoint),
   headers: ApiConfig.headers(token: token),
   body: json.encode({
          'message': message,
         'historique': historique ?? [],
        }),
      );

      if (response.statusCode == 200) {
  final data = json.decode(response.body);
      if (data['success'] == true) {
     return data['reponse'];
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de l\'envoi du message');
      }
      } else {
  final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur serveur');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au service IA');
      }
 rethrow;
    }
  }
}
