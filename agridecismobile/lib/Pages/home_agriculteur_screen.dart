import 'package:flutter/material.dart';
import 'package:agridecis/Pages/connexion_screen.dart';
import 'package:agridecis/Pages/inscription_screen.dart';
import 'package:agridecis/Pages/contenus_screen.dart';

class HomeAgriculteurScreen extends StatelessWidget {
  const HomeAgriculteurScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

            child: Text('Page $title en construction'),
          ),
        ),
   }
  }

  void _showMenuOption(BuildContext context, String option) {
    // Pour l'exemple, on affiche un simple snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Option sélectionnée : $option')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 8),
            const Text(
              'AgriDecis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          )
        ],
      ),
    ),
      body: Column(
        children: [
          // Barre météo bleue collée à l'AppBar
          Container(
            width: double.infinity,
            color: const Color(0xFF0288D1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icône météo (nuage avec soleil)
                const Icon(
                  Icons.wb_cloudy,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                // Texte 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bamako - Mali',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '26°C Fraicheur',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Menu à trois points
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) => _showMenuOption(context, value),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'Historiques météo',
                      child: Text('Historiques météo'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Alerte Météo',
                      child: Text('Alerte Météo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Espace après la barre
          const SizedBox(height: 40),
          // Reste du contenu (bouton et grille) en SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Bouton Voir mes diagnostiques IA
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DiagnosticIAScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF2E7D32), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      Image.asset(
                        "assets/images/plante1.png",
                        height: 100,
                        width: 70,
                      ),

                      const SizedBox(width: 15),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Voir les diagnostic IA",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Analyse intelligente de vos culture",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

                   const SizedBox(height: 30),  const SizedBox(height: 30),
                  // Grille des fonctionnalités
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.0,
                      children: [
                        _buildFeatureCard(
                          icon: Icons.people,
                          label: 'Communauté',
                          backgroundColor: const Color(0xFF2E7D32),
                          iconColor: const Color(0xFF2E7D32),
                          textColor: Colors.white,
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CommunityScreen(),
                            ),
                          );
                        },
                        ),
                        _buildFeatureCard(
                          icon: Icons.menu_book,
                          label: 'Contenus',
                          backgroundColor: const Color(0xFF0288D1),
                          iconColor: const Color(0xFF0288D1),
                          textColor: Colors.white,
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContenusScreen(),
                            ),
                          );
                        },
                        ),
                        _buildFeatureCard(
                        icon: Icons.psychology,
                        label: 'Conseil IA',
                        backgroundColor: const Color(0xFFFBC02D),
                        iconColor: const Color(0xFFFBC02D),
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConseilIaScreen(),
                            ),
                          );
                        },
                      ),
                        _buildFeatureCard(
                          icon: Icons.history,
                          label: 'Mes historiques',
                          backgroundColor: const Color(0xFF8D6E63),
                          iconColor: const Color(0xFF8D6E63),
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoriquesScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: 1,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_outlined),
            activeIcon: Icon(Icons.cloud),
            label: 'Prévision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrevisionScreen(),
                ),
              );
              break;
            case 1:
              // Déjà sur Home
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}