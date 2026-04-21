import 'package:flutter/material.dart';

class ListeRapportsScreen extends StatelessWidget {
  const ListeRapportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List rapports = [
      {
        "titre": "Rapport sur la maladie du blé",
        "date": "22 avril 2024",
        "status": "Diagnostiqué"
      },
      {
        "titre": "Rapport sur les maladies des tomates",
        "date": "20 avril 2024",
        "status": "En attente"
      },
      {
        "titre": "Rapport sur les maladies du maïs",
        "date": "12 avril 2024",
        "status": "Traité"
      },
      {
        "titre": "Rapport sur la maladie du blé",
        "date": "4 avril 2024",
        "status": "Diagnostiqué"
      },
    ];

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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)),
                const Expanded(
                  child: Text(
                    "Liste des rapports",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 30)
              ],
            ),
          ),

          const SizedBox(height: 15),

          // ================= SEARCH =================

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3))
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Rechercher...",
                  suffixIcon: Icon(Icons.mic),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= LISTE =================

          Expanded(
            child: ListView.builder(
              itemCount: rapports.length,
              itemBuilder: (context, index) {
                final rapport = rapports[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      // ===== ICON DOCUMENT =====

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: Color(0xFF2E7D32),
                          size: 35,
                        ),
                      ),

                      const SizedBox(width: 15),

                      // ===== INFOS =====

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              rapport["titre"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              rapport["date"],
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text("Voir détails"),
                                ),

                                const SizedBox(width: 6),

                                const Icon(Icons.info,
                                    color: Colors.green)
                              ],
                            )
                          ],
                        ),
                      ),

                      // ===== STATUS =====

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: rapport["status"] == "Diagnostiqué"
                              ? Colors.green.shade100
                              : rapport["status"] == "En attente"
                                  ? Colors.orange.shade100
                                  : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          rapport["status"],
                          style: TextStyle(
                            color: rapport["status"] == "Diagnostiqué"
                                ? Colors.green
                                : rapport["status"] == "En attente"
                                    ? Colors.orange
                                    : Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
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
