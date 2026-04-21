// lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      /// APPBAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 8),
              const Text(
                'AgriDecis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [

          /// HEADER
          Container(
            color: const Color(0xFFDCDCDC),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const Expanded(
                  child: Text(
                    "Profil",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 40)
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// CARD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE3E3E3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0,4),
                  )
                ],
              ),

              child: Column(
                children: [

                  /// PHOTO
                  Stack(
                    children: [

                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2E7D32),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                          AssetImage("assets/images/profil.png"),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// CHAMPS
                  _field("Nom complet", "Dr. Moussa Coulibaly", Icons.person),
                  _field("Email", "moussacoul26@gmail.com", Icons.email),
                  _field("Téléphone", "70 12 34 56", Icons.phone),
                  _passwordField(),
                  _field("Spécialités", "Agroécologie", Icons.eco),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Spacer(),

          /// BOUTON ENREGISTRER
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(
                    horizontal: 80, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  
                ),
                
              ),
       
              onPressed: () {},
              child: const Text(
                "Enregistrer",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CHAMP NORMAL
  Widget _field(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 5),

        TextField(
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFF2E7D32)),
            ),
          ),
        ),

        const SizedBox(height: 15)
      ],
    );
  }

  /// MOT DE PASSE
  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text("Mot de passe",
            style: TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 5),

        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "••••••••",
            suffixIcon: const Icon(Icons.visibility_off,
                color: Color(0xFF2E7D32)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFF2E7D32)),
            ),
          ),
        ),

        const SizedBox(height: 15)
      ],
    );
  }
}