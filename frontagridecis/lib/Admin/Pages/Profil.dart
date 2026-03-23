import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/profile_service.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<Profil> {
  final ProfileService _profileService = ProfileService();
  bool _isEditing = false;
  bool _isLoading = false;
  File? _selectedImage;
  
  // Contrôleurs avec valeurs par défaut (seront mis à jour au chargement)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = await authProvider.getAccessToken();
      if (token != null) {
        final user = await _profileService.getProfile(token);
        setState(() {
          _emailController.text = user.email;
          _nomController.text = user.nom;
          _prenomController.text = user.prenom;
          _telephoneController.text = user.telephone ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur chargement profil: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Upload automatique de la photo
      _uploadPhoto();
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;
    
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = await authProvider.getAccessToken();
      if (token != null) {
        await _profileService.updateProfile(
          token: token,
          photo_profil: _selectedImage!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo de profil mise à jour ✅')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur upload photo: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = await authProvider.getAccessToken();
      if (token != null) {
        await _profileService.updateProfile(
          token: token,
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          telephone: _telephoneController.text.trim(),
        );
        if (mounted) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil mis à jour avec succès ✅')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur mise à jour: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 72, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'Supprimer votre compte ?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cette action est irréversible.\nToutes vos données, publications, conseils et historique seront définitivement supprimés.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Supprimer définitivement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: appel API suppression + déconnexion
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Compte supprimé (simulation)')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentIndex: 8, 
            onTap: (_) {},
          ),
          Expanded(
            child: Column(
              children: [
                const Topbar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(48.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Profil',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 48),

                          CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : const AssetImage('assets/images/profil.png') as ImageProvider,
                          ),
                          const SizedBox(height: 16),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt, size: 20),
                            label: const Text('Changer la photo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                              foregroundColor: const Color(0xFF10B981),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: _pickImage,
                          ),
                          const SizedBox(height: 48),

                          SizedBox(
                            width: 520,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _isEditing
                                            ? TextFormField(
                                                controller: _emailController,
                                                decoration: const InputDecoration(border: InputBorder.none),
                                              )
                                            : Text(_emailController.text, style: const TextStyle(fontSize: 16)),
                                      ),
                                      const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                const Text('Mot de passe', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _isEditing
                                            ? TextFormField(
                                                controller: _passwordController,
                                                obscureText: true,
                                                decoration: const InputDecoration(border: InputBorder.none),
                                              )
                                            : const Text('••••••••••', style: TextStyle(fontSize: 16)),
                                      ),
                                      const Icon(Icons.lock, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isEditing)
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() => _isEditing = false);
                                    _loadProfile(); // Recharger les données originales
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  ),
                                  child: const Text('Annuler'),
                                ),
                              if (_isEditing) const SizedBox(width: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isEditing ? const Color(0xFF10B981) : Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(_isEditing ? 'Enregistrer' : 'Éditer'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 80),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.delete_forever, color: Colors.red),
                                label: const Text('Supprimer mon compte', style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  side: const BorderSide(color: Colors.red),
                                ),
                                onPressed: _showDeleteAccountDialog,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}