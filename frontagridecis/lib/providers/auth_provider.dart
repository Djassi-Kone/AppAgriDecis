import'package:flutter/material.dart';
import'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  
  // Pour Admin uniquement (dashboard admin)
  String? get userRole => _user?.role;
  bool get isAdmin => _user?.role == 'admin';

  AuthProvider() {
   // Initialiser de manière asynchrone après que les bindings soient prêts
   WidgetsBinding.instance.addPostFrameCallback((_) {
     _initializeAuth();
   });
  }

  bool? get isAgriculteur => null;

  Future<void> _initializeAuth() async {
   _status = AuthStatus.loading;
   notifyListeners();

   try {
  final isValid = await _authService.isTokenValid();
     if (isValid) {
      _user = await _authService.getCurrentUser();
       if (_user != null) {
        _status = AuthStatus.authenticated;
       } else {
        _status = AuthStatus.unauthenticated;
       }
     } else {
      _status = AuthStatus.unauthenticated;
     }
   } catch (e) {
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
   }
  notifyListeners();
  }

  Future<void> login(String email, String password) async {
   _status = AuthStatus.loading;
   _errorMessage = null;
  notifyListeners();

   try {
    _user = await _authService.login(email, password);
    _status = AuthStatus.authenticated;
   } catch (e) {
    _status = AuthStatus.error;
    _errorMessage = e.toString();
   }
  notifyListeners();
  }

  Future<void> refreshToken() async {
   try {
  final refreshToken = _user?.refreshToken;
     if (refreshToken != null) {
      _user = await _authService.refreshToken(refreshToken);
      notifyListeners();
     }
   } catch (e) {
     debugPrint('Erreur lors du rafraîchissement du token: ${e.toString()}');
     // Déconnecter si le refresh échoue
    await logout();
   }
  }

  Future<void> logout() async {
   _status = AuthStatus.loading;
  notifyListeners();

   try {
    await _authService.logout();
    _user= null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
   } catch (e) {
    _errorMessage = e.toString();
     // Même en cas d'erreur, on déconnecte localement
    _user= null;
    _status = AuthStatus.unauthenticated;
   }
  notifyListeners();
  }

  void clearError() {
   _errorMessage = null;
  notifyListeners();
  }

  void refreshUser() {
   _initializeAuth();
  }

  Future<String?> getAccessToken() async {
 return await _authService.getAccessToken();
  }
}
