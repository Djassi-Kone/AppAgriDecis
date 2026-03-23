import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import 'api_config.dart';

class ProfileService {
  /// Récupérer le profil de l'utilisateur connecté
  Future<User> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.monProfilEndpoint),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['profil']);
        } else {
          throw Exception('Erreur lors de la récupération du profil');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
      rethrow;
    }
  }

  /// Modifier son profil avec upload de photo
  Future<User> updateProfile({
    required String token,
    String? nom,
    String? prenom,
    String? telephone,
    File? photo_profil,
    String? localisation,
    String? typeCulture,
    String? specialite,
  }) async {
    try {
      // Créer une requête multipart pour uploader la photo
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiConfig.monProfilEndpoint),
      );

      // Ajouter les headers d'authentification
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Ajouter les champs texte
      if (nom != null) request.fields['nom'] = nom;
      if (prenom != null) request.fields['prenom'] = prenom;
      if (telephone != null) request.fields['telephone'] = telephone;
      if (localisation != null) request.fields['localisation'] = localisation;
      if (typeCulture != null) request.fields['typeCulture'] = typeCulture;
      if (specialite != null) request.fields['specialite'] = specialite;

      // Ajouter la photo si présente
      if (photo_profil != null) {
        var fileStream = http.ByteStream(photo_profil.openRead());
        var length = await photo_profil.length();
        
        var multipartFile = http.MultipartFile(
          'photo_profil',
          fileStream,
          length,
          filename: basename(photo_profil.path),
          contentType: MediaType('image', 'jpeg'),
        );
        
        request.files.add(multipartFile);
      }

      // Envoyer la requête
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['profil']);
        } else {
          throw Exception(data['errors']?['nonFieldErrors']?.first ?? 
                         'Erreur lors de la mise à jour');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['errors']?['nonFieldErrors']?.first ?? 
                       'Erreur serveur: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur réseau: Impossible de se connecter au serveur');
      }
      rethrow;
    }
  }
}
