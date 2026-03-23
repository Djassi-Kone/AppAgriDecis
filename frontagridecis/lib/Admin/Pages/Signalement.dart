import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/admin_api_service.dart';

class Signalement extends StatefulWidget {
  const Signalement({super.key});

  @override
  State<Signalement> createState() => _SignalementState();
}

class _SignalementState extends State<Signalement> {
  final _api = AdminApiService();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> signalement = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await context.read<AuthProvider>().getAccessToken();
      if (token == null) throw Exception('Token manquant');
      final list = await _api.listReports(token);
      signalement = list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resolve(String id) async {
    try {
      final token = await context.read<AuthProvider>().getAccessToken();
      if (token == null) throw Exception('Token manquant');
      await _api.resolveReport(token, id);
      final idx = signalement.indexWhere((r) => '${r['id']}' == id);
      if (idx >= 0) {
        setState(() => signalement[idx]['resolved'] = true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> _delete(String id) async {
    try {
      final token = await context.read<AuthProvider>().getAccessToken();
      if (token == null) throw Exception('Token manquant');
      await _api.deleteReport(token, id);
      setState(() => signalement.removeWhere((r) => '${r['id']}' == id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
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
          'Signalements et publications',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
       const SizedBox(height: 32),
         if (_loading)
           const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
         else if (_error != null)
           Column(
             children: [
               Text(_error!, style: const TextStyle(color: Colors.red)),
               const SizedBox(height: 12),
               ElevatedButton(onPressed: _load, child: const Text('Réessayer')),
             ],
           )
         else
           Card(
             elevation: 4,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
             child: DataTable(
               columnSpacing: 40,
               headingRowColor: WidgetStatePropertyAll(const Color(0xFF10B981)),
               headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
               columns: const [
                 DataColumn(label: Text('Cible')),
                 DataColumn(label: Text('Signalé par')),
                 DataColumn(label: Text('Résolu')),
                 DataColumn(label: Text('Actions')),
               ],
               rows: signalement.map((s) {
                 final id = '${s['id']}';
                 return DataRow(cells: [
                   DataCell(Text('${s['target_content_type'] ?? ''}#${s['target_object_id'] ?? ''}')),
                   DataCell(Text('${s['reporter'] ?? ''}')),
                   DataCell(Text((s['resolved'] == true) ? 'Oui' : 'Non')),
                   DataCell(
                     Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         IconButton(
                           icon: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981)),
                           onPressed: (s['resolved'] == true) ? null : () => _resolve(id),
                         ),
                         IconButton(
                           icon: const Icon(Icons.delete_outline, color: Colors.red),
                           onPressed: () => _delete(id),
                         ),
                       ],
                     ),
                   ),
                 ]);
               }).toList(),
             ),
           ),
       ],
      ),
    );
  }
}
