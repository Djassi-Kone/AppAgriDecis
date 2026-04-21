import 'dart:ui';
import 'package:agridecis/Pages/Profile_screen.dart';
import 'package:agridecis/Pages/questions_screen.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  final TextEditingController messageController = TextEditingController();
  bool showInput = false;

  List<Map<String, String>> posts = [
    {
      "name": "Djassi Koné",
      "message":
          "Bonjour ! Je suis agronome vous pouvez exposer vos problème agricole.",
      "time": "38 min"
    },
    {
      "name": "Moussa Coulibaly",
      "message":
          "Bonjour ! Je suis cultivateur j’aimerai participer aux échanges sur la plateforme.",
      "time": "48 min"
    },
    {
      "name": "Mamadou Wagué",
      "message": "Bonjour ! J’ai des questions à poser sur mes culture.",
      "time": "1 H"
    },
  ];

  void addPost() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      posts.insert(0, {
        "name": "Vous",
        "message": messageController.text,
        "time": "Maintenant"
      });

      messageController.clear();
      showInput = false;
    });
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
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
            color: Colors.white,
          ),
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
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                /// LISTE DES POSTS
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      "Plateform",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...posts.map((post) => _buildPostCard(post)),
                  ],
                ),
                /// OVERLAY FLOU + INPUT
                if (showInput) ...[
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: "Écrire un message...",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: const Color(0xFF2E7D32),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: addPost,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),

      /// NAVBAR PERSONNALISÉE
      bottomNavigationBar: BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            /// QUESTIONS ❓
            IconButton(
              icon: const Icon(Icons.help_outline),
              color: Colors.grey,
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(width: 40), // espace pour le bouton +

            /// PROFIL 👤
            IconButton(
              icon: const Icon(Icons.person_outline),
              color: const Color(0xFF2E7D32),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: const Color(0xFF2E7D32),
      onPressed: () {
        // Action bouton +
        setState(() {
          showInput = true; // pour afficher le champ flou + saisie
        });
      },
      child: const Icon(
        Icons.add,
        size: 32,
        color: Colors.white,
      ),
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// CARD POST
  Widget _buildPostCard(Map<String, String> post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    post["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(post["message"]!),

                  const SizedBox(height: 8),

                  Text(
                    post["time"]!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PAGE TEMPORAIRE
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Page $title")),
    );
  }
}