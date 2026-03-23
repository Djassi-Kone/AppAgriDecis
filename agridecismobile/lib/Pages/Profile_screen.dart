// lib/screens/profile_screen.dart
import 'package:agridecis/Pages/edit_profile_screen.dart';
import 'package:flutter/material.dart';  
import 'prevision_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget innerShadowContainer({required Widget child, double radius = 16}) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
          // Overlay pour simuler shadow interne
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.04),
                  Colors.transparent,
                  Colors.black.withOpacity(0.04),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
     appBar: PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        automaticallyImplyLeading: false, // pour enlèvé la flèche retour
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
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
    ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, 
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Navigation
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrevisionScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
          }
        
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Prévision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      body: Column(
        children: [
          /// HEADER
          Container(
          padding: const EdgeInsets.only(
              top: 10, left: 16, right: 16, bottom: 10),
          color: const Color(0xFFFFFFFF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Profil",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
                IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                color: const Color(0xFF2E7D32),
              )
            ],
          ),
        ),
          const SizedBox(height: 16),
          
          /// CARD PROFIL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                /// PHOTO + NOM + STATUS
                innerShadowContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/profil.png'),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFFFFFFFF),
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Dr. Moussa Coulibaly",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            /// ROLE
                            Chip(
                              label: Text("Expert Agronome",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Color(0xFF2E7D32),
                            ),
                            SizedBox(width: 8),
                            /// STATUS
                            Chip(
                              label: Text("Active"),
                              backgroundColor:
                                  Color.fromARGB(255, 168, 222, 181),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Les autres cards restent identiques
                const SizedBox(height: 16),
                innerShadowContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informations",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 17),
                        Row(
                          children: const [
                            Icon(Icons.email, color: Color(0xFF2E7D32)),
                            SizedBox(width: 8),
                            Text("Email : "),
                            Text("moussacoul26@gmail.com",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.phone, color: Color(0xFF2E7D32)),
                            SizedBox(width: 8),
                            Text("Téléphone : "),
                            Text("+223 70 12 34 56",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.spa, color: Color(0xFF2E7D32)),
                            SizedBox(width: 8),
                            Text("Spécialité : "),
                            Text("Agroécologie",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 18),
                innerShadowContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: const [
                            Icon(Icons.check_circle,
                                color: Color(0xFF2E7D32)),
                            SizedBox(height: 8),
                            Text("Conseils donnés"),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.chat_bubble,
                                color: Color(0xFF2E7D32)),
                            SizedBox(height: 8),
                            Text("Questions repondus"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}