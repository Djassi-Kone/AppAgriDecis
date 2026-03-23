import 'package:flutter/material.dart';

class ResetPopup extends StatelessWidget {
  final String email;
  final VoidCallback onClose;

  const ResetPopup({super.key, required this.email, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        padding: const EdgeInsets.fromLTRB(30, 25, 30, 35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton X rouge (exactement comme ton image)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Vous allez recevoir le lien de réinitialisation sur ce email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 8),

            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            const Text(
              'le lien sera expiré dans 2min',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}