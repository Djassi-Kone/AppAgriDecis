import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontagridecis/providers/auth_provider.dart';
import'package:frontagridecis/routes/app_routes.dart';
import 'package:frontagridecis/widgets/error_widget.dart';

void main() async {
  // S'assurer que Flutter est complètement initialisé
  WidgetsFlutterBinding.ensureInitialized();
  
  // Attendre que les bindings soient prêts avant de créer le provider
  await Future.delayed(const Duration(milliseconds: 100));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'AgriDecis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF10B981),
          scaffoldBackgroundColor: Colors.grey[100],
          fontFamily: 'sans-serif',
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}