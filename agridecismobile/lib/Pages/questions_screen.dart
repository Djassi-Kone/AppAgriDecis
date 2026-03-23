import 'dart:ui';
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {

  final TextEditingController questionController = TextEditingController();
  bool showInput = false;

  List<Map<String, String>> questions = [
    {
      "name": "Moussa Traoré",
      "question": "Comment lutter contre les parasites du maïs ?",
      "time": "20 min"
    },
    {
      "name": "Fatoumata Diallo",
      "question": "Quelle est la meilleure période pour semer le riz ?",
      "time": "45 min"
    },
    {
      "name": "Issa Coulibaly",
      "question": "Comment améliorer la fertilité du sol naturellement ?",
      "time": "1 H"
    },
  ];

  void addQuestion() {
    if (questionController.text.trim().isEmpty) return;

    setState(() {
      questions.insert(0, {
        "name": "Vous",
        "question": questionController.text,
        "time": "Maintenant"
      });

      questionController.clear();
      showInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      /// APPBAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 45),
            const SizedBox(width: 8),
            const Text("AgriDecis"),
          ],
        ),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
        ],
      ),

      body: Stack(
        children: [

          /// CONTENU
          Column(
            children: [

              /// BARRE METEO
              Container(
                width: double.infinity,
                color: const Color(0xFF0288D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: const [
                    Icon(Icons.wb_cloudy,
                        color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bamako - Mali",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        Text("26°C Fraicheur",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.more_vert, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// TITRE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Questions",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// LISTE
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: questions.length,
                  itemBuilder: (_, i) =>
                      _buildQuestionCard(questions[i]),
                ),
              ),
            ],
          ),

          /// INPUT FLOTTANT
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

                    /// 🔥 ICONE MEDIA (UI ONLY)
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Ajout de média bientôt disponible 📷"),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// TEXTE
                    Expanded(
                      child: TextField(
                        controller: questionController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Posez votre question...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// ENVOYER
                    CircleAvatar(
                      backgroundColor:
                          const Color(0xFF2E7D32),
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Colors.white),
                        onPressed: addQuestion,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),

      /// NAVBAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: const SizedBox(height: 65),
      ),

      /// BOUTON +
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () => setState(() => showInput = true),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }

  /// CARD QUESTION
  Widget _buildQuestionCard(Map<String, String> q) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const CircleAvatar(radius: 28),
        title: Text(q["name"]!,
            style:
                const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(q["question"]!),
        trailing: Text(q["time"]!,
            style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}