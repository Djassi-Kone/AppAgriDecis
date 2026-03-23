// // EXEMPLE D'UTILISATION DES SERVICES D'INTÉGRATION
// // ===================================================

// import'package:flutter/material.dart';
// import'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../services/auth_service.dart';
// import '../services/inscription_service.dart';
// import '../services/password_reset_service.dart';
// import '../services/weather_service.dart';
// import '../services/diagnostic_service.dart';
// import '../models/user.dart';

// // ============================================================================
// // 1. CONNEXION (Login)
// // ============================================================================
// Future<void> exempleLogin(BuildContext context) async {
//   final authProvider= Provider.of<AuthProvider>(context, listen: false);
  
//   try {
//     await authProvider.login('agriculteur@agridecis.com', 'motdepasse123');
    
//     if (authProvider.isAuthenticated) {
//       // Connexion réussie
//      final user= authProvider.user;
//       print('Connecté en tant que : ${user?.fullName} (${user?.role})');
      
//       // Redirection selon le rôle
//       if (authProvider.isAdmin) {
//         Navigator.pushNamed(context, '/admin-dashboard');
//       } else if (authProvider.isAgriculteur) {
//         Navigator.pushNamed(context, '/agriculteur-dashboard');
//       } else if (authProvider.isAgronome) {
//         Navigator.pushNamed(context, '/agronome-dashboard');
//       }
//     }
//   } catch (e) {
//     // Afficher l'erreur
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Erreur: ${authProvider.errorMessage}')),
//     );
//   }
// }

// // ============================================================================
// // 2. INSCRIPTION
// // ============================================================================
// Future<void> exempleInscription() async {
//   final inscriptionService = InscriptionService();
  
//   try {
//     // Inscription d'un agriculteur
//    final user= await inscriptionService.inscrire(
//       email: 'nouvel.agriculteur@example.com',
//       password: 'MotDePasse123!',
//       nom: 'KONE',
//       prenom: 'Djassi',
//      role: 'AGRICULTEUR',
//       telephone: '+22362345678',
//       specialite: 'Grandes cultures',
//       localisation: 'Bamako, Mali',
//       typeCulture: 'Blé, Maïs',
//     );
    
//     print('Inscription réussie : ${user.fullName}');
    
//     // Optionnel : Connecter automatiquement après inscription
//     // Il faudra appeler login avec les identifiants
    
//   } catch (e) {
//     print('Erreur inscription: $e');
//   }
// }

// // ============================================================================
// // 3. RÉINITIALISATION DU MOT DE PASSE
// // ============================================================================
// Future<void> exemplePasswordReset() async {
//   final passwordResetService = PasswordResetService();
  
//   try {
//     // Étape 1 : Demander la réinitialisation
//    final success = await passwordResetService.demanderReinitialisation(
//       'utilisateur@example.com',
//     );
    
//     if (success) {
//       print('Email de réinitialisation envoyé !');
//       // L'utilisateur reçoit un email avec un token
//     }
    
//     // Étape 2 : Confirmer avec le token (depuis le lien dans l'email)
//     // À appeler depuis l'écran de confirmation avec le token reçu
//     await passwordResetService.confirmerReinitialisation(
//       token: 'TOKEN_RECU_DANS_EMAIL',
//       nouveauMotDePasse: 'NouveauMotDePasse123!',
//     );
    
//     print('Mot de passe réinitialisé avec succès !');
    
//   } catch (e) {
//     print('Erreur: $e');
//   }
// }

// // ============================================================================
// // 4. MÉTÉO - RÉCUPÉRER LES PRÉVISIONS
// // ============================================================================
// Future<void> exempleMeteo() async {
//   final weatherService = WeatherService();
//   final authService = AuthService();
  
//   try {
//     // Récupérer le token d'accès
//    final token = await authService.getAccessToken();
    
//     // Option 1 : Par coordonnées GPS
//    final previsionsGPS = await weatherService.getPrevisions(
//       token: token,
//       lat: 48.8566,
//       lon: 2.3522,
//       jours: 7,
//     );
    
//     // Option 2 : Par nom de ville
//    final previsionsVille = await weatherService.getPrevisions(
//       token: token,
//       ville: 'Paris',
//       jours: 5,
//     );
    
//     print('Prévisions: ${previsionsVille['previsions']}');
//     print('Alertes: ${previsionsVille['alertes']}');
    
//   } catch (e) {
//     print('Erreur météo: $e');
//   }
// }

// // ============================================================================
// // 5. DIAGNOSTIC IA - UPLOAD D'IMAGE
// // ============================================================================
// Future<void> exempleDiagnosticIA() async {
//   final diagnosticService = DiagnosticService();
//   final authService = AuthService();
  
//   try {
//    final token = await authService.getAccessToken();
    
//     // Récupérer la liste des diagnostics
//    final diagnostics = await diagnosticService.getMesDiagnostics(
//       token,
//       page: 1,
//       pageSize: 10,
//     );
    
//     print('Nombre de diagnostics: ${diagnostics.length}');
    
//     // Récupérer le détail d'un diagnostic
//     if (diagnostics.isNotEmpty) {
//      final detail = await diagnosticService.getDetailDiagnostic(
//         token,
//         diagnostics.first['id'].toString(),
//       );
      
//       print('Détail: ${detail['resume']}');
//       print('Score de confiance: ${detail['scoreConfiance']}');
//     }
    
//   } catch (e) {
//     print('Erreur diagnostic: $e');
//   }
// }

// // ============================================================================
// // 6. CHAT CONSEILS AGRICOLES
// // ============================================================================
// Future<void> exempleChatConseils() async {
//   final diagnosticService = DiagnosticService();
//   final authService = AuthService();
  
//   try {
//    final token = await authService.getAccessToken();
    
//     // Envoyer un message au chat
//    final reponse = await diagnosticService.sendChatMessage(
//       token,
//       'Comment traiter le mildiou de la tomate ?',
//       historique: [
//         {'role': 'user', 'content': 'Bonjour'},
//         {'role': 'assistant', 'content': 'Bonjour ! Comment puis-je vous aider ?'},
//       ],
//     );
    
//     print('Réponse de l\'IA: $reponse');
    
//   } catch (e) {
//     print('Erreur chat: $e');
//   }
// }

// // ============================================================================
// // 7. GESTIONNAIRE DE TOKEN AUTOMATIQUE
// // ============================================================================
// // L'AuthService gère automatiquement le rafraîchissement des tokens
// // Quand vous appelez une API, le token est vérifié et rafraîchi si besoin

// Future<void> exempleApiAvecToken() async {
//   final weatherService = WeatherService();
//   final authService = AuthService();
  
//   try {
//     // Pas besoin de gérer manuellement le token
//     // L'AuthService va automatiquement :
//     // 1. Vérifier si le token access est valide
//     // 2. Le rafraîchir s'il expire dans moins de 5 minutes
//     // 3. Utiliser le refresh token si nécessaire
    
//    final token = await authService.getAccessToken();
    
//    final previsions = await weatherService.getPrevisions(
//       token: token,
//       ville: 'Lyon',
//     );
    
//     print('Prévisions récupérées avec succès !');
    
//   } catch (e) {
//     // Si erreur 401 (token invalide), l'AuthService tente de rafraîchir
//     // Si le refresh échoue, il faut se reconnecter
//     print('Erreur: $e');
//   }
// }

// // ============================================================================
// // 8. EXEMPLE COMPLET DANS UN WIDGET
// // ============================================================================
// class ExempleEcranConnexion extends StatefulWidget {
//   @override
//   _ExempleEcranConnexionState createState() => _ExempleEcranConnexionState();
// }

// class _ExempleEcranConnexionState extends State<ExempleEcranConnexion> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final_passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       appBar: AppBar(title: Text('Connexion AgriDecis')),
//      body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                    return 'Email requis';
//                   }
//                  return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Mot de passe'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                    return 'Mot de passe requis';
//                   }
//                  return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _handleLogin,
//                       child: Text('Se connecter'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
//     await authProvider.login(
//       _emailController.text,
//       _passwordController.text,
//     );

//     setState(() => _isLoading = false);

//     if (authProvider.isAuthenticated) {
//       // Navigation selon le rôle
//       if (authProvider.isAdmin) {
//         Navigator.pushReplacementNamed(context, '/admin');
//       } else if (authProvider.isAgriculteur) {
//         Navigator.pushReplacementNamed(context, '/agriculteur');
//       } else {
//         Navigator.pushReplacementNamed(context, '/agronome');
//       }
//     } else {
//       // Afficher l'erreur
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(authProvider.errorMessage ?? 'Erreur inconnue')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

// // ============================================================================
// // NOTES IMPORTANTES
// // ============================================================================
// //
// // 1. Configuration de l'URL du backend :
// //    - Modifiez `ApiConfig._devBaseUrl` pour le développement
// //    - Pour Android Emulator : http://10.0.2.2:8000
// //    - Pour iOS Simulator : http://localhost:8000
// //    - Pour Web : http://localhost:8000
// //    - Pour la production: https://votre-api-production.com
// //
// // 2. Tokens JWT :
// //    - Access token : Expire après 1 heure(configurable dans Django)
// //    - Refresh token : Expire après 7 jours (configurable dans Django)
// //    - L'AuthService gère automatiquement le rafraîchissement
// //
// // 3. Gestion des erreurs:
// //    - Les erreurs réseau sont capturées et converties en Exceptions
// //    - Les erreurs HTTP 4xx/5xx sont analysées et retournées
// //    - Utilisez try/catch pour gérer les erreurs dans l'UI
// //
// // 4. Sécurité :
// //    - Les tokens sont stockés dans FlutterSecureStorage (chiffré)
// //    - Ne jamais logger les tokens en production
// //    - Utiliser HTTPS en production uniquement
// //
// // ============================================================================
