import 'package:flutter/material.dart';

import '../core/ai_service.dart';
import '../core/auth_service.dart';

class ConseilIaScreen extends StatefulWidget {
  const ConseilIaScreen({super.key});

  @override
  State<ConseilIaScreen> createState() => _ConseilIaScreenState();
}

class _ConseilIaScreenState extends State<ConseilIaScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  int? _sessionId;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      _loading = true;
    });
    _controller.clear();

    try {
      final token = await AuthService().getAccessToken();
      if (token == null) {
        throw Exception("Vous devez vous connecter pour utiliser l'IA");
      }
      final res = await AiService().chat(
        accessToken: token,
        message: text,
        sessionId: _sessionId,
      );
      final session = res['session'] as Map<String, dynamic>?;
      final reply = res['reply']?.toString() ?? '';
      setState(() {
        _sessionId = session?['id'] as int?;
        messages.add({"role": "ia", "text": reply});
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMenuOption(String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Option sélectionnée : $option')),
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: _showMenuOption,
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: "Mes historiques",
                      child: Text("Mes historiques"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // "Que puis-je faire pour vous ?" + Champ de saisie
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                // Texte juste au-dessus du champ
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Text(
                    "Que puis-je faire pour vous ?",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Icône media
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.grey),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Ajouter un média")));
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Tapez votre message...",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
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
                        onPressed: _loading ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}