import'package:flutter/material.dart';
import '../Admin/Pages/ConnexionAdminPage.dart';
import '../Admin/Pages/Dashboard.dart';
import '../Admin/Pages/forgot_password_page.dart';
import '../Admin/Pages/InscriptionPage.dart';
import '../widgets/auth_wrapper.dart';

class AppRoutes {
  static const String login = '/login';
  static const String inscription = '/inscription';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String splash = '/';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const AuthWrapper(),
      login: (context) => const Connexionadminpage(),
      inscription: (context) => const InscriptionPage(),
      forgotPassword: (context) => const ForgotPassword(),
      dashboard: (context) => const Dashboard(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const Connexionadminpage(),
          settings: settings,
        );
      case inscription:
        return MaterialPageRoute(
          builder: (_) => const InscriptionPage(),
          settings: settings,
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPassword(),
          settings: settings,
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const Dashboard(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
          settings: settings,
        );
    }
  }

  // Méthode helper pour naviguer vers mot de passe oublié
  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, forgotPassword);
  }
}
