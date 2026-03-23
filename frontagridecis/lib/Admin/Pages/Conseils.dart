// conseils_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/admin_api_service.dart';

class Conseils extends StatefulWidget {
  const Conseils({super.key});

  @override
  State<Conseils> createState() => _ConseilsState();
}

class _ConseilsState extends State<Conseils> {
  final _api = AdminApiService();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> conseils = [];

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
      final list = await _api.listAdvices(token);
      conseils = list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete(String id) async {
    try {
      final token = await context.read<AuthProvider>().getAccessToken();
      if (token == null) throw Exception('Token manquant');
      await _api.deleteAdvice(token, id);
      conseils.removeWhere((c) => '${c['id']}' == id);
      if (mounted) setState(() {});
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
            'Conseils des agronomes',
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
                  DataColumn(label: Text('Titre')),
                  DataColumn(label: Text('Culture')),
                  DataColumn(label: Text('Statut')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: conseils.map((c) {
                  final id = '${c['id']}';
                  return DataRow(cells: [
                    DataCell(Text('${c['title'] ?? ''}')),
                    DataCell(Text('${c['culture'] ?? ''}')),
                    DataCell(Text('${c['status'] ?? ''}')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, color: Color(0xFF10B981)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('${c['title'] ?? ''}'),
                                  content: Text('${c['body'] ?? ''}'),
                                ),
                              );
                            },
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
