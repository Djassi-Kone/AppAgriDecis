import 'package:agridecis/core/auth_service.dart';
import 'package:agridecis/core/content_service.dart';
import 'package:agridecis/Pages/ajouter_contenus_screen.dart';
import 'package:agridecis/Pages/lecture_contenu_screen.dart';
import 'package:flutter/material.dart';

class ContenusScreen extends StatefulWidget {
  const ContenusScreen({super.key});

  @override
  State<ContenusScreen> createState() => _ContenusScreenState();
}

class _ContenusScreenState extends State<ContenusScreen> {
  int selectedTab = 0;
  final ContentService _contentService = ContentService();
  final AuthService _auth = AuthService();
  List<Map<String, dynamic>> _allContents = [];
  bool _loading = true;
  String? _error;
  bool _isAgronome = false;

  final List<String> tabs = ["Vidéos", "Audios", "Conseils"];
  static const List<String> _kinds = ['video', 'audio', 'text'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final role = await _auth.getRole();
      final list = await _contentService.list();
      if (!mounted) return;
      setState(() {
        _isAgronome = role == 'agronome';
        _allContents = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredContents {
    final kind = _kinds[selectedTab];
    return _allContents.where((c) => (c['kind'] as String?) == kind).toList();
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
            const Text(
              "AgriDecis",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Header Contenus
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Contenus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                if (_isAgronome)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AjouterContenuScreen(),
                          ),
                        );
                        _load();
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: selectedTab == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        height: 3,
                        width: 60,
                        color: selectedTab == index
                            ? const Color(0xFF2E7D32)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // CONTENU
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _load,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : selectedTab == 0
                        ? _videosTab()
                        : selectedTab == 1
                            ? _audiosTab()
                            : _conseilsTab(),
          ),
        ],
      ),
    );
  }

  Widget _videosTab() {
    final items = _filteredContents;
    if (items.isEmpty) {
      return const Center(child: Text('Aucune vidéo pour le moment'));
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final c = items[index];
        return _contentCard(
          title: (c['title'] as String?) ?? '',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LectureContenuScreen(content: c),
            ),
          ),
          onDelete: _isAgronome
              ? () => _confirmDelete(context, c)
              : null,
          icon: Icons.play_circle_fill,
        );
      },
    );
  }

  Widget _audiosTab() {
    final items = _filteredContents;
    if (items.isEmpty) {
      return const Center(child: Text('Aucun audio pour le moment'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final c = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LectureContenuScreen(content: c),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (c['title'] as String?) ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (c['description'] as String?) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isAgronome)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(context, c),
                ),
              const Icon(Icons.play_arrow, color: Color(0xFF2E7D32), size: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _conseilsTab() {
    final items = _filteredContents;
    if (items.isEmpty) {
      return const Center(child: Text('Aucun conseil pour le moment'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final c = items[index];
        return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LectureContenuScreen(content: c),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (c['title'] as String?) ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (c['description'] as String?) ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (_isAgronome)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context, c),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _contentCard({
    required String title,
    required VoidCallback onTap,
    VoidCallback? onDelete,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    "assets/images/img1.jpg",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      child: Center(
                        child: Icon(icon, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                ),
                if (onDelete != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: onDelete,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Map<String, dynamic> c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce contenu ?'),
        content: Text(
          'Supprimer "${(c['title'] as String?) ?? ''}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final id = c['id'];
    if (id == null) return;
    try {
      await _contentService.delete(id as int);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contenu supprimé')),
      );
      _load();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
}