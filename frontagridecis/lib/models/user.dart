class User {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String? telephone;
  final String role; // admin, agronome, agriculteur
  final String? accessToken;
  final String? refreshToken;
  final DateTime? accessExpires;
  final DateTime? refreshExpires;
  final String? specialite; // pour agronome
  final String? localisation; // pour agriculteur
  final String? typeCulture; // pour agriculteur
  final String? profilePhoto;
  final DateTime? dateCreation;

  User({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    this.telephone,
    required this.role,
    this.accessToken,
    this.refreshToken,
    this.accessExpires,
    this.refreshExpires,
    this.specialite,
    this.localisation,
    this.typeCulture,
    this.profilePhoto,
    this.dateCreation,
  });

  String get fullName => '$prenom $nom';

  // Pour Admin uniquement
  bool get isAdminUser => role == 'admin';
  
  bool get isAgriculteur => role == 'agriculteur';
  
  bool get isAgronome => role == 'agronome';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'],
     role: json['role'] ?? 'agriculteur',
      accessToken: json['access'],
      refreshToken: json['refresh'],
      accessExpires: json['access_expires'] != null 
          ? DateTime.parse(json['access_expires']) 
          : null,
      refreshExpires: json['refresh_expires'] != null 
          ? DateTime.parse(json['refresh_expires']) 
          : null,
      specialite: json['specialite'],
      localisation: json['localisation'],
      typeCulture: json['typeCulture'],
      profilePhoto: json['profile_photo'],
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'role': role,
      'access': accessToken,
      'refresh': refreshToken,
      'access_expires': accessExpires?.toIso8601String(),
      'refresh_expires': refreshExpires?.toIso8601String(),
      'specialite': specialite,
      'localisation': localisation,
      'typeCulture': typeCulture,
      'profile_photo': profilePhoto,
      'dateCreation': dateCreation?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? nom,
    String? prenom,
    String? telephone,
    String? role,
    String? accessToken,
    String? refreshToken,
    DateTime? accessExpires,
    DateTime? refreshExpires,
    String? specialite,
    String? localisation,
    String? typeCulture,
    String? profilePhoto,
    DateTime? dateCreation,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
     role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessExpires: accessExpires ?? this.accessExpires,
      refreshExpires: refreshExpires ?? this.refreshExpires,
      specialite: specialite ?? this.specialite,
      localisation: localisation ?? this.localisation,
      typeCulture: typeCulture ?? this.typeCulture,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }
}
