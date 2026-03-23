import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<Notifications> {
  // Données exemple 
  final List<Map<String, dynamic>> notifications = List.generate(12, (index) => {
        'titre': 'Conseil période hivernage',
        'actif': index % 3 != 1, 
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     padding: const EdgeInsets.all(32),
   child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         const Text(
            'Notifications',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ElevatedButton.icon(
             icon: const Icon(Icons.add),
            label: const Text('Créer nouvelle Notification'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
               foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
             onPressed: _showCreateNotificationBottomSheet,
            ),
         ],
       ),
      const SizedBox(height: 32),

       SizedBox(
        height: 600,
       child: GridView.builder(
           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 340,
             mainAxisExtent: 140,
             crossAxisSpacing: 20,
             mainAxisSpacing: 20,
            ),
          itemCount: notifications.length,
         itemBuilder: (context, index) {
          final notif = notifications[index];
           return Card(
             elevation: 3,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
           child: Padding(
              padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   notif['titre'],
                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ),
               const SizedBox(height: 8),
                 Text(
                   notif['titre'], 
                 style: const TextStyle(fontSize: 14, color: Colors.grey),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ),
                 Switch(
                   value: notif['actif'],
                   activeColor: const Color(0xFF10B981),
                   inactiveThumbColor: Colors.red,
                   inactiveTrackColor: Colors.red[200],
                   onChanged: (bool value) {
                    setState(() {
                       notifications[index]['actif'] = value;
                     });
                   },
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

  void _showCreateNotificationBottomSheet() {
   showModalBottomSheet(
    context: context,
     builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
     child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        const Text(
           'Créer une notification',
         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
           ),
       const SizedBox(height: 16),
         TextField(
          decoration: const InputDecoration(labelText: 'Titre'),
         ),
       const SizedBox(height: 16),
         TextField(
          decoration: const InputDecoration(labelText: 'Description'),
         ),
       const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
         height: 50,
         child: ElevatedButton(
            onPressed: () {
             Navigator.pop(context);
            },
           style: ElevatedButton.styleFrom(
             backgroundColor: const Color(0xFF10B981),
             foregroundColor: Colors.white,
             ),
          child: const Text('Créer', style: TextStyle(fontSize: 16)),
           ),
         ),
       ],
      ),
     ),
   );
  }
}
