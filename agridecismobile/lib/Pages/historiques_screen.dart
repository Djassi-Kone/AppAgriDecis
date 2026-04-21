import 'package:flutter/material.dart';

class HistoriquesScreen extends StatelessWidget {
  const HistoriquesScreen({super.key});

  final List<Map<String, String>> historiques = const [
    {"title": "Diagnostic IA", "date": "Le 15/01/2026", "icon": "assets/images/img3.jpg"},
    {"title": "Météo", "date": "Le 15/01/2026", "icon": "assets/images/img3.jpg"},
    {"title": "Vidéo télécharger", "date": "Le 15/01/2026", "icon": "assets/images/img3.jpg"},
    {"title": "Audio télécharger", "date": "Le 15/01/2026", "icon": "assets/images/img3.jpg"},
    {"title": "Conseil consulter", "date": "Le 15/01/2026", "icon": "assets/images/img3.jpg"},
    {"title": "Conseil IA", "date": "Le 15/01/2026", "icon": "assets/images/img3.jpg"},
  ];
void _showMenuOption(BuildContext context, String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Option sélectionnée : $option')),
    );
  }

  void _showDeleteDialog(BuildContext context, String itemTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Vous allez supprimer cet historique"),
        content: Text(itemTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          // Croix rouge → annuler
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          // V vert → confirmer
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$itemTitle supprimé")));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),

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
            const Expanded(
              child: Text(
                "AgriDecis",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            
          ],
        ),
      ),

      body: Column(
        children: [
          // Header "Conseil IA"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Conseil IA",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 190),
                 IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                // Si tu veux un bouton global pour tout supprimer
                _showDeleteDialog(context, "Tous les historiques");
               },
               )
              ],
            ),
          ),

          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: historiques.length,
              itemBuilder: (context, index) {
                final item = historiques[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(item["icon"]!),
                    ),
                    title: Text(item["title"]!),
                    subtitle: Text(item["date"]!),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Popup suppression pour cet item spécifique
                      _showDeleteDialog(context, item["title"]!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}