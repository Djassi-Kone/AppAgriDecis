import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Sidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.home, 'label': 'Accueil'},
    {'icon': Icons.people, 'label': 'Utilisateurs'},
    {'icon': Icons.content_paste, 'label': 'Contenus'},
    {'icon': Icons.notifications, 'label': 'Seuil d\'alerte'},
    {'icon': Icons.flag_outlined, 'label': 'Signalements'},
    {'icon': Icons.lightbulb_outline, 'label': 'Conseils'},
    {'icon': Icons.settings, 'label': 'Paramètres'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFF10B981),
      child: Column(
        children: [
          // Logo
          Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 68),
                        const SizedBox(width: 12),
                        const Text(
                          'AgriDecis',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

          const Divider(color: Colors.white24, thickness: 1),

          // Menu items
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final isActive = index == currentIndex;
                final item = _menuItems[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isActive ? Colors.white : Colors.white70,
                    size: 26,
                  ),
                  title: Text(
                    item['label'] as String,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white70,
                      fontSize: 17,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  selected: isActive,
                  selectedTileColor: Colors.white.withOpacity(0.18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () => onTap(index),
                );
              },
            ),
          ),

          // Déconnexion en bas
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: const Icon(Icons.logout, color: Colors.white70, size: 26),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.white70, fontSize: 17),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}