import 'package:agridecis/Pages/diagnostic_terminer.dart';
import 'package:agridecis/Pages/resultat_diagnostic_screen.dart';
import 'package:flutter/material.dart';

class DiagnosticIAScreen extends StatefulWidget {
  const DiagnosticIAScreen({super.key});

  @override
  State<DiagnosticIAScreen> createState() => _DiagnosticIAScreenState();
}

class _DiagnosticIAScreenState extends State<DiagnosticIAScreen> {

  // ================= LOADING POPUP =================
  void _startDiagnostic() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LoadingDialog(),
    );

    // simulation IA (2-3 secondes)
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // ferme popup

      // 👉 Page résultat (on la fera après)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DiagnosticTerminerScreen(),
        ),
      );
    });
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

          // ================= CAMERA BUTTON =================
          GestureDetector(
            onTap: _startDiagnostic,
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

          // ================= MESSAGE =================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Placez l’objet bien au centre pour une meilleure détection",
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // ================= VALID BUTTON =================
          GestureDetector(
            onTap: _startDiagnostic,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check,
                  color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Veuillez patienté",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Color(0xFF2E7D32),
            ),
          ],
        ),
      ),
    );
  }
}