import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/admin_api_service.dart';

class ContentsPage extends StatefulWidget {
  const ContentsPage({super.key});

  @override
  State<ContentsPage> createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _api = AdminApiService();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _contents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await context.read<AuthProvider>().getAccessToken();
      if (token == null) throw Exception('Token manquant');
      final list = await _api.listContents(token);
      _contents = list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
     child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        const Text(
            'Contenus',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 24),

          // Onglets
         Container(
           decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            ),
          child: TabBar(
            controller: _tabController,
             indicator: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
              ),
             labelColor: Colors.white,
             unselectedLabelColor: Colors.black87,
             tabs: const [
               Tab(text: 'Vidéos'),
               Tab(text: 'Audios'),
               Tab(text: 'Textes'),
              ],
            ),
          ),

        const SizedBox(height: 16),

        SizedBox(
          height: 600,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : (_error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _ContentGrid(type: 'video', items: _contents),
                        _ContentGrid(type: 'audio', items: _contents),
                        _ContentGrid(type: 'text', items: _contents),
                      ],
                    )),
         ),
        ],
      ),
    );
  }
}

class _ContentGrid extends StatelessWidget {
  final String type;
  final List<Map<String, dynamic>> items;
  const _ContentGrid({required this.type, required this.items});

  @override
  Widget build(BuildContext context) {
    final filtered = items.where((c) => (c['kind']?.toString() ?? '') == type).toList();
    return GridView.builder(
     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
       maxCrossAxisExtent: 280,
       mainAxisExtent: 260,
       crossAxisSpacing: 20,
       mainAxisSpacing: 20,
      ),
     itemCount: filtered.length,
     itemBuilder: (context, index) {
      final c = filtered[index];
       return Card(
         elevation: 3,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Image / miniature
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  color: Colors.green[100],
                  child: Center(
                    child: type == 'video'
                         ? const Icon(Icons.play_circle_fill, size: 60, color: Colors.green)
                         : type == 'audio'
                             ? const Icon(Icons.audiotrack, size: 60, color: Colors.green)
                             : const Icon(Icons.article, size: 60, color: Colors.green),
                   ),
                 ),
               ),
             ),

             Padding(
               padding: const EdgeInsets.all(12.0),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${c['title'] ?? ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                   Row(
                    children: [
                      Text('${c['culture'] ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const Spacer(),
                       Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                       Text('0', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const SizedBox(width: 12),
                       Icon(Icons.comment_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                       Text('0', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                     ],
                   ),
                 ],
               ),
             ),
           ],
         ),
       );
     },
   );
  }
}
