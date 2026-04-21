import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import 'UsersManagementPage.dart';
import 'ContentsManagementPage.dart';
import 'WeatherAlertsPage.dart';
import 'ReportsManagementPage.dart';
import 'AdvicesManagementPage.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Map<String, dynamic>? stats;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      isLoading = true;
    });

    try {
      final statsData = await AdminService.getSystemStats();
      setState(() {
        stats = statsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Admin'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  if (stats != null) _buildStatsCards(),
                  SizedBox(height: 24),
                  
                  // Quick Actions
                  Text(
                    'Actions Rapides',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildQuickActions(),
                  SizedBox(height: 24),
                  
                  // Management Sections
                  Text(
                    'Gestion',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildManagementGrid(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(title: 'Utilisateurs', value: stats?['total_users']?.toString() ?? '0', icon: Icons.people, color: Colors.blue)),
            SizedBox(width: 16),
            Expanded(child: _StatCard(title: 'Contenus', value: stats?['total_contents']?.toString() ?? '0', icon: Icons.article, color: Colors.green)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _StatCard(title: 'Signalements', value: stats?['total_reports']?.toString() ?? '0', icon: Icons.report, color: Colors.red)),
            SizedBox(width: 16),
            Expanded(child: _StatCard(title: 'Diagnostics', value: stats?['total_diagnostics']?.toString() ?? '0', icon: Icons.healing, color: Colors.orange)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    title: 'Créer Utilisateur',
                    icon: Icons.person_add,
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Navigate to create user
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _QuickActionButton(
                    title: 'Alertes Météo',
                    icon: Icons.warning,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WeatherAlertsPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    title: 'Rapports',
                    icon: Icons.assessment,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReportsManagementPage()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _QuickActionButton(
                    title: 'Configuration',
                    icon: Icons.settings,
                    color: Colors.grey,
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _ManagementCard(
          title: 'Utilisateurs',
          subtitle: 'Gérer les comptes',
          icon: Icons.people,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UsersManagementPage()),
            );
          },
        ),
        _ManagementCard(
          title: 'Contenus',
          subtitle: 'Modérer les publications',
          icon: Icons.article,
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ContentsManagementPage()),
            );
          },
        ),
        _ManagementCard(
          title: 'Signalements',
          subtitle: 'Vérifier les alertes',
          icon: Icons.report,
          color: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReportsManagementPage()),
            );
          },
        ),
        _ManagementCard(
          title: 'Conseils IA',
          subtitle: 'Gérer les conseils',
          icon: Icons.psychology,
          color: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdvicesManagementPage()),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 48),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
