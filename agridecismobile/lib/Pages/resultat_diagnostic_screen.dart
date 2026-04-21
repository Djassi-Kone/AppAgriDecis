import 'package:flutter/material.dart';

class ResultatDiagnosticScreen extends StatefulWidget {
  const ResultatDiagnosticScreen({super.key});

  @override
  State<ResultatDiagnosticScreen> createState() =>
      _ResultatDiagnosticScreenState();
}

class _ResultatDiagnosticScreenState extends State<ResultatDiagnosticScreen> {

  List<Map<String, dynamic>> diagnostics = [
    {
      "titre": "Maladie de plante détecter",
      "details": "Placez l’objet bien au centre pour une meilleure détection",
      "date": "Le 05/02/2026 à 10H20",
      "expanded": false
    },
    {
      "titre": "Maladie de plante détecter",
      "details": "Placez l’objet bien au centre pour une meilleure détection",
      "date": "Le 05/02/2026 à 10H20",
      "expanded": false
    },
    {
      "titre": "Maladie de plante détecter",
      "details": "Placez l’objet bien au centre pour une meilleure détection",
      "date": "Le 05/02/2026 à 10H20",
      "expanded": false
    },
  ];

  // ================= SUPPRESSION =================

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer"),
          content: const Text(
              "Voulez-vous vraiment supprimer ce diagnostic ?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                setState(() {
                  diagnostics.removeAt(index);
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  // ================= BUILD =================

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
            Image.asset(
              "assets/images/logo.png",
              height: 40,
            ),
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
                    "Resultat diagnostic IA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                const Icon(Icons.delete, color: Colors.red)
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ================= LISTE =================

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: diagnostics.length,
              itemBuilder: (context, index) {
                final item = diagnostics[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      // ================= TITRE =================

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item["titre"],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                diagnostics[index]["expanded"] =
                                    !diagnostics[index]["expanded"];
                              });
                            },
                            child: Icon(
                              item["expanded"]
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ),

                          const SizedBox(width: 5),

                          GestureDetector(
                            onTap: () => deleteItem(index),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ================= DETAILS =================

                      if (item["expanded"])
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                item["details"],
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item["date"],
                                style: const TextStyle(
                                    color: Colors.brown),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}