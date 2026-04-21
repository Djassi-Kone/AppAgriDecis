import 'dart:math';

import 'package:flutter/material.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilPage> {

  bool hidePassword = true;

  final nom = TextEditingController(text: "Aïsha");
  final prenom = TextEditingController(text: "Koné");
  final email = TextEditingController(text: "djassikone@gmail.com");
  final telephone = TextEditingController(text: "70 20 21 70");
  final password = TextEditingController(text: "password123");

  // ================= CARD STYLE =================

  BoxDecoration cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    );
  }

  // ================= INFO FIELD =================

  Widget infoField(String label, TextEditingController controller) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: cardStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 12),
              decoration: cardStyle(),
              child: Text(controller.text),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),

      // ================= APPBAR =================

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 40),
            const SizedBox(width: 10),
            const Text(
              "AgriDecis",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
             /// HEADER
          Container(
          padding: const EdgeInsets.only(
              top: 10, left: 16, right: 16, bottom: 10),
          color: const Color(0xFFFFFFFF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Edit Profil",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          const SizedBox(height: 16),
            // ================= CARD PROFIL =================

            Container(
              padding: const EdgeInsets.all(15),
              decoration: cardStyle(),
              child: Row(
                children: [

                  Stack(
                    children: [
                      const SizedBox(width: 35),

                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage("assets/images/profil1.png"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.camera_alt,
                                size: 18,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(width: 15),

                  const Text(
                    "Agriculteur",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= GRAND CARD =================

            Container(
              padding: const EdgeInsets.all(15),
              decoration: cardStyle(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===== INFORMATION PERSONNELLES =====

                  const Text(
                    "Information personnelles",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      infoField("Nom", nom),
                      const SizedBox(width: 10),
                      infoField("Prénom", prenom),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== PARAMETRE COMPTE =====

                  const Text(
                    "Paramètre compte",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      infoField("Email", email),
                      const SizedBox(width: 10),
                      infoField("Téléphone", telephone),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== MOT DE PASSE =====

                  const Text(
                    "Mot de passe",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12),
                    decoration: cardStyle(),
                    child: TextField(
                      controller: password,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= BOUTONS =================

            Row(
              children: [

                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Supprimer compte",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Enregistrer modifications",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
