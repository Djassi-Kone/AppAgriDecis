import 'package:flutter/material.dart';

import '../core/ai_service.dart';
import '../core/auth_service.dart';

class ResultatDiagnosticScreen extends StatefulWidget {
  const ResultatDiagnosticScreen({super.key});

  @override
  State<ResultatDiagnosticScreen> createState() =>
      _ResultatDiagnosticScreenState();
}

class _ResultatDiagnosticScreenState extends State<ResultatDiagnosticScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> diagnostics = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await AuthService().getAccessToken();
      if (token == null) {
        throw Exception("Connectez-vous pour voir l'historique");
      }
      final list = await AiService().diagnosticHistory(accessToken: token);
      diagnostics = list.map((e) {
        final m = e as Map<String, dynamic>;
        final created = m['created_at']?.toString() ?? '';
        final resultJson = m['result_json'];
        String titre = 'Diagnostic';
        String details = '';
        if (resultJson is Map) {
          final preds = resultJson['predictions'];
          if (preds is List && preds.isNotEmpty) {
            final p = preds.first as Map;
            titre = 'Diagnostic: ${p['label']}';
            details = 'Confiance: ${p['confidence']}';
          }
        }
        return {
          'titre': titre,
          'details': details,
          'date': created,
          'expanded': false,
        };
      }).toList();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (_error != null
                    ? Center(
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
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
                      )),
          )
        ],
      ),
    );
  }
}