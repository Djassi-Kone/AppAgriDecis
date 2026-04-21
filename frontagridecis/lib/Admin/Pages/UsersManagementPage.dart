import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../models/user.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;
  String searchQuery = '';
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // TODO: Get token from auth provider
      final usersList = await AdminService.getUsers();
      setState(() {
        users = usersList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<User> get filteredUsers {
    var filtered = users;
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((user) => 
        user.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
        user.fullName.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    if (selectedRole != null) {
      filtered = filtered.where((user) => user.role == selectedRole).toList();
    }
    
    return filtered;
  }

  Future<void> _toggleUserStatus(User user) async {
    try {
      await AdminService.toggleUser(user.id);
      _loadUsers(); // Reload users
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut de ${user.fullName} modifié')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer ${user.fullName}?'),
        content: Text('Cette action est irréversible. Voulez-vous continuer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AdminService.deleteUser(user.id);
        _loadUsers(); // Reload users
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user.fullName} supprimé')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    DropdownButton<String>(
                      hint: Text('Rôle'),
                      value: selectedRole,
                      items: [
                        DropdownMenuItem(value: null, child: Text('Tous')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'agronome', child: Text('Agronome')),
                        DropdownMenuItem(value: 'agriculteur', child: Text('Agriculteur')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 64, color: Colors.red),
                            Text(errorMessage),
                            ElevatedButton(
                              onPressed: _loadUsers,
                              child: Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : filteredUsers.isEmpty
                        ? Center(
                            child: Text('Aucun utilisateur trouvé'),
                          )
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return UserCard(
                                user: user,
                                onToggle: () => _toggleUserStatus(user),
                                onDelete: () => _deleteUser(user),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onToggle,
    required this.onDelete,
  });

  Color getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'agronome':
        return Colors.green;
      case 'agriculteur':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getRoleColor(user.role),
          child: Text(
            user.prenom[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(user.fullName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: getRoleColor(user.role),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.toggle_on),
              onPressed: onToggle,
              tooltip: 'Activer/Désactiver',
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  }
}
