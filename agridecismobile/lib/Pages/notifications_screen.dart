import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      "title": "Nouvelle notification",
      "message": "Nouveau contenu ajouter",
      "time": "Il y a 2h"
    },
    {
      "title": "Nouvelle notification",
      "message": "Les seuils météo ont été modifier",
      "time": "Il y a 2h"
    },
    {
      "title": "Nouvelle notification",
      "message": "Prévision météo , ciel nuageur pour demain",
      "time": "Il y a 2h"
    },
    {
      "title": "Nouvelle notification",
      "message": "Prévision météo , ciel nuageur pour demain",
      "time": "Il y a 2h"
    },
    {
      "title": "Nouvelle notification",
      "message": "Prévision météo , ciel nuageur pour demain",
      "time": "Il y a 2h"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),

      // 🔵 APPBAR IDENTIQUE
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

          // 🔵 HEADER Notifications
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
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                const Icon(Icons.delete, color: Colors.red),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🔵 Bandeau vert
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF5E8F5E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: const [
                Icon(Icons.info, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "1 notification non lue",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Text(
                  "TOUT MARQUER COMME LU",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🔵 Liste notifications
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFDDE7DD),
                      child: Icon(Icons.notifications, color: Colors.green),
                    ),
                    title: Text(
                      item["title"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(item["message"]!),
                        const SizedBox(height: 6),
                        Text(
                          item["time"]!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
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