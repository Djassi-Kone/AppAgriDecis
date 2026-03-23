import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/admin_api_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _api = AdminApiService();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> users = [];

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
      final list = await _api.listUsers(token);
      users = list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleUser(String userId) async {
    try {
      final token = await context.read<AuthProvider>().getAccessToken();
      if (token == null) throw Exception('Token manquant');
      final res = await _api.toggleUser(token, userId);
      final isActive = res['is_active'] ?? res['actif'];
      final idx = users.indexWhere((u) => '${u['id']}' == userId);
      if (idx >= 0) {
        setState(() {
          users[idx]['is_active'] = isActive;
        });
      }
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
            'Utilisateurs',
           style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
         const SizedBox(height: 24),

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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columnSpacing: 40,
                  headingRowColor: WidgetStatePropertyAll(Colors.grey[800]),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: const [
                    DataColumn(label: Text('N°')),
                    DataColumn(label: Text('Nom')),
                    DataColumn(label: Text('Prénom')),
                    DataColumn(label: Text('Rôle')),
                    DataColumn(label: Text('État')),
                  ],
                  rows: users.asMap().entries.map((entry) {
                    final index = entry.key;
                    final user = entry.value;
                    final userId = '${user['id']}';
                    final active = (user['is_active'] ?? user['actif'] ?? true) == true;
                    return DataRow(cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text('${user['nom'] ?? ''}')),
                      DataCell(Text('${user['prenom'] ?? ''}')),
                      DataCell(Text('${user['role'] ?? ''}')),
                      DataCell(
                        Switch(
                          value: active,
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                          inactiveTrackColor: Colors.red[200],
                          onChanged: (_) => _toggleUser(userId),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
