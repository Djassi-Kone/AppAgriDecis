import'package:flutter/material.dart';
import'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/error_widget.dart';
import '../../routes/app_routes.dart';

class Connexionadminpage extends StatefulWidget {
  const Connexionadminpage({super.key});

  @override
  State<Connexionadminpage> createState() => _ConnexionadminpageState();
}

class _ConnexionadminpageState extends State<Connexionadminpage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
           fit: BoxFit.cover,
          ),
        ),
       child: Center(
         child: SingleChildScrollView(
           child: Padding(
              padding: const EdgeInsets.all(20),
             child: ClipRRect(
               borderRadius: BorderRadius.circular(30),
               child: BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                 child: Container(
                   constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo + AgriDecis 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/logo.png', height: 68),
                            const SizedBox(width: 12),
                            const Text(
                              'AgriDecis',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        const Text('Bienvenue !', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Connectez-vous à AgriDecis', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 40),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'admin@agridecis.com',
                                  hintStyle: const TextStyle(color: Colors.white38),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.15),
                                  errorStyle: const TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre email';
                                  }
                                  // Regex plus permissive pour les emails
                                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                    return 'Veuillez entrer un email valide';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  hintText: 'admin123',
                                  hintStyle: const TextStyle(color: Colors.white38),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.15),
                                  errorStyle: const TextStyle(color: Colors.white),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre mot de passe';
                                  }
                                  if (value.length < 6) {
                                    return 'Le mot de passe doit contenir au moins 6 caractères';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                            child: const Text('Mot de passe oublié', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Afficher les erreurs
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            if (authProvider.status == AuthStatus.error && authProvider.errorMessage != null) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.errorMessage!,
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                      onPressed: () => authProvider.clearError(),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return ElevatedButton(
                                onPressed: authProvider.status == AuthStatus.loading
                                    ? null
                                    : () async {
                                        print('Bouton cliqué!');
                                        print('Email: ${_emailController.text.trim()}');
                                        print('Password: ${_passwordController.text}');
                                        print('Formulaire valide: ${_formKey.currentState!.validate()}');
                                        
                                        if (_formKey.currentState!.validate()) {
                                          print('Tentative de connexion...');
                                          await authProvider.login(
                                            _emailController.text.trim(),
                                            _passwordController.text,
                                          );
                                          
                                          // Vérifier si c'est un admin
                                          if (authProvider.isAuthenticated && !authProvider.isAdmin) {
                                            // Ce n'est pas un admin, afficher une erreur et déconnecter
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Accès réservé aux administrateurs uniquement'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            await authProvider.logout();
                                          } else if (authProvider.isAuthenticated && authProvider.isAdmin) {
                                            print('Admin connecté avec succès!');
                                          }
                                          
                                          print('Connexion terminée');
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  disabledBackgroundColor: Colors.grey,
                                ),
                                child: authProvider.status == AuthStatus.loading
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text('Connexion...', style: TextStyle(fontSize: 20, color: Colors.white)),
                                        ],
                                      )
                                    : const Text('Connexion', style: TextStyle(fontSize: 20, color: Colors.white)),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Bouton Créer un compte
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pas encore de compte ?', style: TextStyle(color: Colors.white70)),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.inscription),
                              child: const Text('S\'inscrire', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}