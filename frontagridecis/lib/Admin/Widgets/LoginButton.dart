import 'package:flutter/material.dart';
import 'AppColors.dart';


class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Logique de connexion (Firebase, API, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion en cours...')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        shadowColor: AppColors.primaryGreen.withOpacity(0.5),
      ),
      child: const Text(
        'Connexion',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}