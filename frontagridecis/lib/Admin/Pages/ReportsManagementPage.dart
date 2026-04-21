import 'package:flutter/material.dart';

class ReportsManagementPage extends StatefulWidget {
  const ReportsManagementPage({super.key});

  @override
  State<ReportsManagementPage> createState() => _ReportsManagementPageState();
}

class _ReportsManagementPageState extends State<ReportsManagementPage> {
  List<Map<String, dynamic>> reports = [
    {
      'id': '1',
      'title': 'Publication inappropriée',
      'content': 'Contenu signalé pour spam',
      'author': 'Jean Dupont',
      'date': '2024-04-07',
      'status': 'pending',
      'priority': 'high',
    },
    {
      'id': '2',
      'title': 'Commentaire offensant',
      'content': 'Langage inapproprié dans les commentaires',
      'author': 'Marie Martin',
      'date': '2024-04-07',
      'status': 'pending',
      'priority': 'medium',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Signalements'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return ReportCard(
            report: report,
            onStatusChanged: (status) {
              setState(() {
                reports[index]['status'] = status;
              });
            },
            onDelete: () {
              setState(() {
                reports.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onDelete;

  const ReportCard({
    super.key,
    required this.report,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _PriorityBadge(priority: report['priority']),
              ],
            ),
            SizedBox(height: 8),
            Text(
              report['content'],
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(report['author']),
                SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(report['date']),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: report['status'],
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(value: 'pending', child: Text('En attente')),
                      DropdownMenuItem(value: 'reviewing', child: Text('En examen')),
                      DropdownMenuItem(value: 'resolved', child: Text('Résolu')),
                      DropdownMenuItem(value: 'dismissed', child: Text('Rejeté')),
                    ],
                    onChanged: (value) {
                      if (value != null) onStatusChanged(value);
                    },
                  ),
                ),
                SizedBox(width: 16),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility),
                          SizedBox(width: 8),
                          Text('Voir le contenu'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Supprimer'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Supprimer ce signalement?'),
                          content: Text('Cette action est irréversible.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onDelete();
                              },
                              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    
    switch (priority) {
      case 'high':
        color = Colors.red;
        text = 'Haute';
        break;
      case 'medium':
        color = Colors.orange;
        text = 'Moyenne';
        break;
      case 'low':
        color = Colors.green;
        text = 'Basse';
        break;
      default:
        color = Colors.grey;
        text = 'Inconnue';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
