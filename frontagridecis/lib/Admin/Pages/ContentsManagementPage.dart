import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class ContentsManagementPage extends StatefulWidget {
  const ContentsManagementPage({super.key});

  @override
  State<ContentsManagementPage> createState() => _ContentsManagementPageState();
}

class _ContentsManagementPageState extends State<ContentsManagementPage> {
  List<dynamic> contents = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // TODO: Get token from auth provider
      final contentsList = await AdminService.getContents();
      setState(() {
        contents = contentsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des contenus'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadContents,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      Text(errorMessage),
                      ElevatedButton(
                        onPressed: _loadContents,
                        child: Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : contents.isEmpty
                  ? Center(child: Text('Aucun contenu trouvé'))
                  : ListView.builder(
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        final content = contents[index];
                        return ContentCard(content: content);
                      },
                    ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final dynamic content;

  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.article, color: Colors.grey[600]),
        ),
        title: Text(content['title'] ?? 'Sans titre'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Par: ${content['author_name'] ?? 'Inconnu'}'),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getContentTypeColor(content['content_type']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (content['content_type'] ?? 'article').toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                SizedBox(width: 8),
                Text('${content['likes_count'] ?? 0} likes'),
                SizedBox(width: 8),
                Text('${content['comments_count'] ?? 0} commentaires'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Voir'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Modifier'),
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
        ),
      ),
    );
  }

  Color _getContentTypeColor(String? type) {
    switch (type) {
      case 'video':
        return Colors.red;
      case 'audio':
        return Colors.blue;
      case 'article':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
