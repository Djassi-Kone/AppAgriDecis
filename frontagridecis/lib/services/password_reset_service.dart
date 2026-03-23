import'dart:convert';
import'package:flutter/foundation.dart';
import'package:http/http.dart' as http;
import 'api_config.dart';

class PasswordResetService {
  /// Demander une réinitialisation de mot de passe
  Future<bool> demanderReinitialisation(String email) async {
    try {
  final response = await http.post(
        Uri.parse(ApiConfig.passwordResetRequestEndpoint),
     headers: ApiConfig.headers(),
     body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
    final data = json.decode(response.body);
      return data['success'] == true;
      } else {
    final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de la demande');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
  rethrow;
    }
  }

  /// Confirmer la réinitialisation avec le token
  Future<bool> confirmerReinitialisation({
  required String token,
  required String nouveauMotDePasse,
  }) async {
    try {
  final response = await http.post(
        Uri.parse(ApiConfig.passwordResetConfirmEndpoint),
     headers: ApiConfig.headers(),
     body: json.encode({
          'token': token,
          'nouveauMotDePasse': nouveauMotDePasse,
        }),
      );

      if (response.statusCode == 200) {
    final data = json.decode(response.body);
      return data['success'] == true;
      } else {
    final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Token invalide ou expiré');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
  rethrow;
    }
  }
}
