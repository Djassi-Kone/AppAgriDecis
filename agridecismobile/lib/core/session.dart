class SessionUser {
  final String email;
  final String? role;
  final String accessToken;
  final String refreshToken;

  const SessionUser({
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      email: (json['email'] ?? '') as String,
      role: json['role'] as String?,
      accessToken: (json['accessToken'] ?? '') as String,
      refreshToken: (json['refreshToken'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'role': role,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}

