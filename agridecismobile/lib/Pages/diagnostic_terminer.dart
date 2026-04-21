import 'package:agridecis/Pages/diagnostic_ia_screen.dart';
import 'package:agridecis/Pages/resultat_diagnostic_screen.dart';
import 'package:flutter/material.dart';

class DiagnosticTerminerScreen extends StatefulWidget {
  const DiagnosticTerminerScreen({super.key});

  @override
  State<DiagnosticTerminerScreen> createState() => _DiagnosticTerminerScreenState();
}

class _DiagnosticTerminerScreenState extends State<DiagnosticTerminerScreen> {
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

      body: Column(
        children: [

          // ================= HEADER =================
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),

                const Expanded(
                  child: Text(
                    "Diagnostic IA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                // MENU 3 POINTS
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == "resultats") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ResultatDiagnosticScreen(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: "resultats",
                      child: Text("Résultats des diagnostics"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ================= IMAGE =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/img2.jpg",
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ================= MESSAGE =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Plante : Pomme de terre"
              "Symptôme : Taches brunes sur les feuilles"
              "Diagnostic IA : Mildiou (Phytophthora infestans) – 90% de probabilité"
              "Conseil : Retirer les feuilles touchées et traiter avec un fongicide.",
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // ================= CAMERA BUTTON =================
          GestureDetector(
            onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiagnosticIAScreen(),
                          ),
                        );
                      },
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt,
                  color: Colors.white, size: 35),
            ),
          ),

          const SizedBox(height: 25),

          
        ],
      ),
    );
  }
}

