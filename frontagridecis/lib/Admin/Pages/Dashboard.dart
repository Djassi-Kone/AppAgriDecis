import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontagridecis/Admin/Pages/ContentsPage.dart';
import 'package:frontagridecis/Admin/Pages/Notifications.dart';
import 'package:frontagridecis/Admin/Pages/Parametres.dart';
import 'package:frontagridecis/Admin/Pages/Profil.dart';
import 'package:frontagridecis/Admin/Pages/Seuil_Alerte.dart';
import 'package:frontagridecis/Admin/Pages/Signalement.dart';
import 'package:frontagridecis/Admin/Pages/UsersPage.dart';
import 'package:frontagridecis/Admin/Pages/Conseils.dart';
import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeDashboard(),       // 0 - Accueil / Tableau de bord
    const UsersPage(),           // 1 - Utilisateurs
    const ContentsPage(),        // 2 - Contenus
    const SeuilAlerte(),         // 3 - Seuil d'alerte
    Signalement(),         // 4 - Signalements
    Conseils(),            // 5 - Conseils
    const Parametres(),          // 6 - Paramètres
  ];
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
          Expanded(
            child: Column(
              children: [
                const Topbar(),
                Expanded(
                  child: _pages[_currentIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== PAGE D'ACCUEIL DU DASHBOARD ======================
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Le tableau de bord administrateur',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 35),

          // Statut global + Total diagnostics
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statut global
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFfacc15)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Statut global du système',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          _buildWeatherItem(Icons.thermostat, 'Température', '30°C'),
                          const SizedBox(width: 40),
                          _buildWeatherItem(Icons.water_drop, 'Humidité', '40%'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniWeather(Icons.wb_sunny, 'Soleil', '7h/jour'),
                          _buildMiniWeather(Icons.cloudy_snowing, 'Pluie', '50mm'),
                          _buildMiniWeather(Icons.air, 'Vent', '8km/h'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 25),

              // Total diagnostics
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total des diagnostics IA faites',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Image.asset('assets/images/image.png', width: 50),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _DiagRow(color: Color(0xFF10B981), label: '350 images analyser'),
                              SizedBox(height: 40),
                              _DiagRow(color: Color(0xFF3B82F6), label: '215 cas de maladies'),
                              SizedBox(height: 40),
                              _DiagRow(color: Color(0xFFfacc15), label: '135 autres cas'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          // 3 cartes utilisateurs
          Row(
            children: [
              _userCard('Utilisateurs Totaux', '155', Icons.people),
              const SizedBox(width: 20),
              _userCard('Utilisateurs actifs', '134', Icons.people, active: true),
              const SizedBox(width: 20),
              _userCard('Utilisateurs inactifs', '21', Icons.people),
            ],
          ),

          const SizedBox(height: 40),

          // Les deux graphiques
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _chartCard('Utilisation de l\'application', _buildBarChart()),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: _chartCard('Alerte IA générer', _buildLineChart()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 42),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniWeather(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 38),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _userCard(String title, String number, IconData icon, {bool active = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12)],
        ),
        child: Column(
          children: [
            Icon(icon, size: 55, color: active ? const Color(0xFF10B981) : Colors.grey[400]),
            const SizedBox(height: 12),
            Text(number, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          SizedBox(height: 320, child: chart),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 90,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const titles = ['Jour', 'Mois', 'Année'];
                return Text(titles[value.toInt()], style: const TextStyle(fontSize: 14));
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: _makeRods(78, 62, 38)),
          BarChartGroupData(x: 1, barRods: _makeRods(82, 65, 35)),
          BarChartGroupData(x: 2, barRods: _makeRods(75, 61, 40)),
        ],
      ),
    );
  }

  List<BarChartRodData> _makeRods(double green, double blue, double yellow) => [
        BarChartRodData(toY: green, color: const Color(0xFF10B981), width: 22, borderRadius: BorderRadius.circular(8)),
        BarChartRodData(toY: blue, color: const Color(0xFF3B82F6), width: 22, borderRadius: BorderRadius.circular(8)),
        BarChartRodData(toY: yellow, color: const Color(0xFFfacc15), width: 22, borderRadius: BorderRadius.circular(8)),
      ];

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, horizontalInterval: 10),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 8),
              FlSpot(20, 18),
              FlSpot(40, 32),
              FlSpot(60, 48),
              FlSpot(80, 57),
              FlSpot(100, 65),
            ],
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 6,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

class _DiagRow extends StatelessWidget {
  final Color color;
  final String label;
  const _DiagRow({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 18, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}