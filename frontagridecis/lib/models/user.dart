class User {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String? telephone;
  final String role; // ADMIN, AGRICULTEUR, AGRONOME
  final String? accessToken;
  final String? refreshToken;
  final DateTime? accessExpires;
  final DateTime? refreshExpires;
  final String? dashboardUrl;

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
    this.dashboardUrl,
  });

  String get fullName => '$prenom $nom';

  // Pour Admin uniquement (pour l'instant)
  bool get isAdminUser => role == 'ADMIN';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'],
     role: json['role'] ?? 'AGRICULTEUR',
      accessToken: json['access'],
      refreshToken: json['refresh'],
      accessExpires: json['access_expires'] != null 
          ? DateTime.parse(json['access_expires']) 
          : null,
      refreshExpires: json['refresh_expires'] != null 
          ? DateTime.parse(json['refresh_expires']) 
          : null,
      dashboardUrl: json['dashboard_url'],
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
      'dashboard_url': dashboardUrl,
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
    String? dashboardUrl,
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
      dashboardUrl: dashboardUrl ?? this.dashboardUrl,
    );
  }
}
