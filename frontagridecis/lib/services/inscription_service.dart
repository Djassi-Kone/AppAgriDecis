import'dart:convert';
import'package:flutter/foundation.dart';
import'package:http/http.dart' as http;
import '../models/user.dart';
import 'api_config.dart';

class InscriptionService {
  Future<User> inscrire({
   required String email,
   required String password,
   required String nom,
   required String prenom,
   required String role, // AGRICULTEUR ou AGRONOME
    String? telephone,
    String? specialite,
    String? localisation,
    String? typeCulture,
  }) async {
    try {
    final body = <String, dynamic>{
        'email': email,
        'password': password,
        'nom': nom,
        'prenom': prenom,
        'role': role.toUpperCase(),
      };

      // Ajouter les champs optionnels selon le rôle
      if (telephone != null && telephone.isNotEmpty) {
      body['telephone'] = telephone;
      }
      
      if (role.toUpperCase() == 'AGRICULTEUR') {
        if (specialite != null && specialite.isNotEmpty) {
        body['specialite'] = specialite;
        }
        if (localisation != null && localisation.isNotEmpty) {
        body['localisation'] = localisation;
        }
        if (typeCulture != null && typeCulture.isNotEmpty) {
        body['typeCulture'] = typeCulture;
        }
      } else if (role.toUpperCase() == 'AGRONOME') {
        if (specialite != null && specialite.isNotEmpty) {
        body['specialite'] = specialite;
        }
      }

    final response = await http.post(
        Uri.parse(ApiConfig.inscriptionEndpoint),
      headers: ApiConfig.headers(),
      body: json.encode(body),
      );

      if (response.statusCode == 201) {
      final data = json.decode(response.body);
        
        if (data['success'] == true) {
        final user = User.fromJson(data['utilisateur']);
        return user;
        } else {
          throw Exception(data['message'] ?? 'Erreur lors de l\'inscription');
        }
      } else {
      final error = json.decode(response.body);
        throw Exception(_formatErrors(error['errors']));
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
    rethrow;
    }
  }

  String _formatErrors(Map<String, dynamic>? errors) {
    if (errors == null) return 'Erreur inconnue';
    
  final messages = <String>[];
    errors.forEach((key, value) {
      if (value is List) {
       messages.addAll(value.map((e) => '$key: $e'));
      } else if (value is String) {
       messages.add('$key: $value');
      }
    });
    
   return messages.isEmpty ? 'Erreur lors de l\'inscription' : messages.join(', ');
  }
}
