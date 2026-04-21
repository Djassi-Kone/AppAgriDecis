import 'package:flutter/material.dart';
import 'dart:ui';
import '../../services/inscription_service.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final InscriptionService _inscriptionService = InscriptionService();
  
  // Champs du formulaire
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _localisationController = TextEditingController();
  final _specialiteController = TextEditingController();
  final _typeCultureController = TextEditingController();
  
  bool _obscurePassword = true;
  String _selectedRole = 'AGRICULTEUR';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _localisationController.dispose();
    _specialiteController.dispose();
    _typeCultureController.dispose();
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
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo + Titre
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
                        const SizedBox(height: 20),
                        
                        const Text('Créer un compte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Agriculteur ou Agronome', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 30),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'exemple@email.com',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Email requis';
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Email invalide';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Nom
                              _buildTextField(
                                controller: _nomController,
                                label: 'Nom',
                                hint: 'Votre nom',
                                icon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Nom requis';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Prénom
                              _buildTextField(
                                controller: _prenomController,
                                label: 'Prénom',
                                hint: 'Votre prénom',
                                icon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Prénom requis';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Téléphone
                              _buildTextField(
                                controller: _telephoneController,
                                label: 'Téléphone',
                                hint: '+223 70 34 56 78',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Téléphone requis';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Sélection du rôle
                              _buildRoleSelector(),
                              const SizedBox(height: 15),

                              // Localisation (pour agriculteur)
                              if (_selectedRole == 'AGRICULTEUR') ...[
                                _buildTextField(
                                  controller: _localisationController,
                                  label: 'Localisation',
                                  hint: 'Ville, Région',
                                  icon: Icons.location_on,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Localisation requise';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),

                                // Type de culture (pour agriculteur)
                                _buildTextField(
                                  controller: _typeCultureController,
                                  label: 'Type de culture',
                                  hint: 'Blé, Maïs, etc.',
                                  icon: Icons.agriculture,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Type de culture requis';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                              ],

                              // Spécialité
                              _buildTextField(
                                controller: _specialiteController,
                                label: 'Spécialité',
                                hint: 'Votre domaine d\'expertise',
                                icon: Icons.work,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Spécialité requise';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Mot de passe
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Mot de passe',
                                hint: '********',
                                icon: Icons.lock,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Mot de passe requis';
                                  if (value.length < 6) return '6 caractères minimum';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Confirmation mot de passe
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirmer le mot de passe',
                                hint: '********',
                                icon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Confirmation requise';
                                  if (value != _passwordController.text) return 'Les mots de passe ne correspondent pas';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Bouton d'inscription
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleInscription,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: _isLoading
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
                                      Text('Inscription...', style: TextStyle(fontSize: 20, color: Colors.white)),
                                    ],
                                  )
                                : const Text('S\'inscrire', style: TextStyle(fontSize: 20, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Déjà un compte
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Déjà un compte ?', style: TextStyle(color: Colors.white70)),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Se connecter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        errorStyle: const TextStyle(color: Colors.white),
      ),
      validator: validator,
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Je suis :', style: TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Agriculteur', style: TextStyle(color: Colors.white)),
                value: 'AGRICULTEUR',
                groupValue: _selectedRole,
                onChanged: (value) => setState(() => _selectedRole = value!),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Agronome', style: TextStyle(color: Colors.white)),
                value: 'AGRONOME',
                groupValue: _selectedRole,
                onChanged: (value) => setState(() => _selectedRole = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleInscription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _inscriptionService.inscrire(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        role: _selectedRole,
        telephone: _telephoneController.text.trim(),
        specialite: _specialiteController.text.trim(),
        localisation: _selectedRole == 'AGRICULTEUR' ? _localisationController.text.trim() : null,
        typeCulture: _selectedRole == 'AGRICULTEUR' ? _typeCultureController.text.trim() : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Inscription réussie ! Vous pouvez maintenant vous connecter.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
