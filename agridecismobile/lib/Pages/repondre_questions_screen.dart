import 'package:flutter/material.dart';

class RepondreQuestionsScreen extends StatefulWidget {
  const RepondreQuestionsScreen({super.key});

  @override
  State<RepondreQuestionsScreen> createState() =>
      _RepondreQuestionsScreenState();
}

class _RepondreQuestionsScreenState extends State<RepondreQuestionsScreen> {

  List questions = [
    {
      "nom": "Aïcha Koné",
      "question": "Pourquoi les feuilles de mon maïs deviennent jaunes ?",
      "date": "12 mai 2026",
      "status": "En attente"
    },
    {
      "nom": "Mamadou Traoré",
      "question": "Quelle est la meilleure période pour planter le blé ?",
      "date": "10 mai 2026",
      "status": "Répondu"
    },
    {
      "nom": "Fatou Diallo",
      "question": "Comment traiter les maladies des tomates ?",
      "date": "8 mai 2026",
      "status": "En attente"
    }
  ];

  final TextEditingController reponseController = TextEditingController();

  void envoyerReponse(int index) {
    setState(() {
      questions[index]["status"] = "Répondu";
    });

    reponseController.clear();
  }

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
            padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)),
                const Expanded(
                  child: Text(
                    "Répondre aux questions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 30)
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ================= LISTE QUESTIONS =================

          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 8),
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

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ===== NOM =====

                      Row(
                        children: [
                          const Icon(Icons.person,
                              color: Color(0xFF2E7D32)),
                          const SizedBox(width: 6),
                          Text(
                            q["nom"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),

                          const Spacer(),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: q["status"] == "Répondu"
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              q["status"],
                              style: TextStyle(
                                  color: q["status"] == "Répondu"
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ===== QUESTION =====

                      Text(
                        q["question"],
                        style: const TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        q["date"],
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 15),

                      // ===== CHAMP REPONSE =====

                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: reponseController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Écrire votre réponse...",
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ===== BOUTON ENVOYER =====

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => envoyerReponse(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Envoyer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
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
