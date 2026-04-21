import 'package:flutter/material.dart';

class AdvicesManagementPage extends StatefulWidget {
  const AdvicesManagementPage({super.key});

  @override
  State<AdvicesManagementPage> createState() => _AdvicesManagementPageState();
}

class _AdvicesManagementPageState extends State<AdvicesManagementPage> {
  List<Map<String, dynamic>> advices = [
    {
      'id': '1',
      'title': 'Traitement des pucerons',
      'content': 'Utilisez du savon noir dilué pour traiter les pucerons...',
      'author': 'Dr. Agronome',
      'date': '2024-04-07',
      'status': 'approved',
      'category': 'traitement',
    },
    {
      'id': '2',
      'title': 'Rotation des cultures',
      'content': 'Pratiquez la rotation des cultures pour améliorer le sol...',
      'author': 'Expert Agricole',
      'date': '2024-04-06',
      'status': 'pending',
      'category': 'pratique',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Conseils'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddAdviceDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  label: Text('Tous'),
                  selected: true,
                  onSelected: (value) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Approuvés'),
                  selected: false,
                  onSelected: (value) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('En attente'),
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: advices.length,
              itemBuilder: (context, index) {
                final advice = advices[index];
                return AdviceCard(
                  advice: advice,
                  onStatusChanged: (status) {
                    setState(() {
                      advices[index]['status'] = status;
                    });
                  },
                  onEdit: () {
                    _showEditAdviceDialog(advice);
                  },
                  onDelete: () {
                    setState(() {
                      advices.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAdviceDialog() {
    showDialog(
      context: context,
      builder: (context) => _AdviceDialog(
        onSave: (title, content, category) {
          setState(() {
            advices.add({
              'id': (advices.length + 1).toString(),
              'title': title,
              'content': content,
              'author': 'Admin',
              'date': DateTime.now().toString().split(' ')[0],
              'status': 'approved',
              'category': category,
            });
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditAdviceDialog(Map<String, dynamic> advice) {
    showDialog(
      context: context,
      builder: (context) => _AdviceDialog(
        initialTitle: advice['title'],
        initialContent: advice['content'],
        initialCategory: advice['category'],
        onSave: (title, content, category) {
          setState(() {
            advice['title'] = title;
            advice['content'] = content;
            advice['category'] = category;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

class AdviceCard extends StatelessWidget {
  final Map<String, dynamic> advice;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdviceCard({
    super.key,
    required this.advice,
    required this.onStatusChanged,
    required this.onEdit,
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
                    advice['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _StatusBadge(status: advice['status']),
              ],
            ),
            SizedBox(height: 8),
            Text(
              advice['content'],
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(advice['author']),
                SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(advice['date']),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    advice['category'] ?? 'général',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                if (advice['status'] == 'pending')
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => onStatusChanged('approved'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Approuver'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => onStatusChanged('rejected'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text('Rejeter'),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: onEdit,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    
    switch (status) {
      case 'approved':
        color = Colors.green;
        text = 'Approuvé';
        break;
      case 'pending':
        color = Colors.orange;
        text = 'En attente';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'Rejeté';
        break;
      default:
        color = Colors.grey;
        text = 'Inconnu';
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

class _AdviceDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final String? initialCategory;
  final Function(String title, String content, String category) onSave;

  const _AdviceDialog({
    this.initialTitle,
    this.initialContent,
    this.initialCategory,
    required this.onSave,
  });

  @override
  State<_AdviceDialog> createState() => _AdviceDialogState();
}

class _AdviceDialogState extends State<_AdviceDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedCategory = 'général';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
    _selectedCategory = widget.initialCategory ?? 'général';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTitle == null ? 'Ajouter un conseil' : 'Modifier un conseil'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Contenu',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'général', child: Text('Général')),
                DropdownMenuItem(value: 'traitement', child: Text('Traitement')),
                DropdownMenuItem(value: 'pratique', child: Text('Pratique')),
                DropdownMenuItem(value: 'prévention', child: Text('Prévention')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
              widget.onSave(
                _titleController.text,
                _contentController.text,
                _selectedCategory,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
          child: Text('Sauvegarder'),
        ),
      ],
    );
  }
}
