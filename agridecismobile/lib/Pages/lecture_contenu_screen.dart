import 'package:agridecis/core/api_config.dart';
import 'package:agridecis/core/content_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Lecture d'un contenu (vidéo, audio, texte) + téléchargement pour agriculteur.
class LectureContenuScreen extends StatelessWidget {
  final Map<String, dynamic> content;

  const LectureContenuScreen({super.key, required this.content});

  String get kind => (content['kind'] as String?) ?? 'text';
  String get title => (content['title'] as String?) ?? '';
  String get description => (content['description'] as String?) ?? '';
  String? get mediaPath => content['media_file'] as String?;
  String get text => (content['text'] as String?) ?? '';

  String get mediaUrl {
    if (mediaPath == null || mediaPath!.isEmpty) return '';
    return ContentService.mediaUrl(mediaPath);
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impossible d\'ouvrir le lien')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: const Text('Contenu', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 20),
            if (kind == 'text') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(text.isEmpty ? 'Aucun texte.' : text),
              ),
            ] else if (mediaUrl.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (kind == 'video')
                      const Icon(Icons.play_circle_fill, size: 64, color: Color(0xFF2E7D32)),
                    if (kind == 'audio')
                      const Icon(Icons.audiotrack, size: 64, color: Color(0xFF2E7D32)),
                    const SizedBox(height: 12),
                    Text(
                      kind == 'video' ? 'Vidéo' : 'Audio',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    // Bouton Lire / Ouvrir
                    OutlinedButton.icon(
                      onPressed: () => _openUrl(context, mediaUrl),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Ouvrir / Lire'),
                    ),
                    const SizedBox(height: 8),
                    // Téléchargement = ouvrir l’URL (le navigateur ou l’app peut télécharger)
                    OutlinedButton.icon(
                      onPressed: () => _openUrl(context, mediaUrl),
                      icon: const Icon(Icons.download),
                      label: const Text('Télécharger'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
