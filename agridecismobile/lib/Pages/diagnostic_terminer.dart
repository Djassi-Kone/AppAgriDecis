import 'dart:typed_data';

import 'package:agridecis/Pages/diagnostic_ia_screen.dart';
import 'package:agridecis/Pages/resultat_diagnostic_screen.dart';
import 'package:flutter/material.dart';

class DiagnosticTerminerScreen extends StatefulWidget {
  final Map<String, dynamic>? result;
  final Uint8List? imageBytes;
  const DiagnosticTerminerScreen({super.key, this.result, this.imageBytes});

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
              child: widget.imageBytes != null && widget.imageBytes!.isNotEmpty
                  ? Image.memory(
                      widget.imageBytes!,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
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
            child: Text(
              _formatResult(widget.result),
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

String _formatResult(Map<String, dynamic>? res) {
  if (res == null) {
    return "Diagnostic indisponible.";
  }
  final status = res['status']?.toString();
  final resultJson = res['result_json'];
  if (status == 'error') {
    return "Erreur: ${res['error_message'] ?? ''}";
  }
  if (resultJson is Map) {
    final preds = resultJson['predictions'];
    if (preds is List && preds.isNotEmpty) {
      final first = preds.first as Map;
      return "Résultat: ${first['label']} (confiance: ${first['confidence']})";
    }
  }
  return "Diagnostic terminé.";
}

