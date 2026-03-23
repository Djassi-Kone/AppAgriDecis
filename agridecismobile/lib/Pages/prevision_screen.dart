// lib/screens/prevision_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

import '../core/weather_service.dart';

class PrevisionScreen extends StatefulWidget {
  const PrevisionScreen({super.key});

  @override
  State<PrevisionScreen> createState() => _PrevisionScreenState();
}

class _PrevisionScreenState extends State<PrevisionScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  // Par défaut Bamako (si tu veux GPS plus tard, on branchera geolocator)
  static const double _defaultLat = 12.6392;
  static const double _defaultLon = -8.0029;

  void _showMenuOption(BuildContext context, String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Option sélectionnée : $option')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  Future<void> _loadForecast() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await WeatherService().forecast(lat: _defaultLat, lon: _defaultLon);
      if (!mounted) return;
      setState(() {
        _data = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

     appBar: PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        automaticallyImplyLeading: false, // enlève la flèche retour
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 8),
            const Text(
              'AgriDecis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// BARRE METEO BLEUE
            Container(
              width: double.infinity,
              color: const Color(0xFF0288D1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.wb_cloudy, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bamako - Mali',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _loading
                            ? 'Chargement...'
                            : (_error != null
                                ? 'Erreur météo'
                                : _currentTempLabel(_data)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (_error != null)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadForecast,
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) => _showMenuOption(context, value),
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'Historiques météo',
                        child: Text('Historiques météo'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Alerte Météo',
                        child: Text('Alerte Météo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// CARTE DIAGNOSTIC IA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF2E7D32), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [

                    Image.asset(
                      "assets/images/plante1.png",
                      height: 100,
                      width: 70,
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Voir les diagnostic IA",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Analyse intelligente de vos culture",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// CARTE PLUIE ATTENDUE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0288D1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ],
                ),
                child: const Row(
                  children: [

                    Icon(
                      Icons.wb_cloudy,
                      color: Color.fromARGB(255, 109, 174, 227),
                      size: 72,
                    ),

                    SizedBox(width: 25),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bamako - Mali",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Forte pluie attendue",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "38 mm",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// SCROLL METEO (6 cards par page)
            SizedBox(
              height: 210,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_error != null
                      ? Center(
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: _buildForecastPages(_data),
                        )),
            ),

            const SizedBox(height: 20),

            /// INDICATEUR PAGES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _forecastPagesCount(_data),
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.black
                        : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      /// NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud), label: "Prévision"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profil"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
          }

          if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
          }
        },
      ),
    );
  }

  Widget _weatherPage(List<Map<String, dynamic>> forecasts) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: forecasts.map((forecast) {
          return _weatherCard(
            forecast["temp"],
            forecast["day"],
            forecast["icon"],
          );
        }).toList(),
      ),
    );
  }

  Widget _weatherCard(String temp, String day, IconData icon) {

    Color iconColor = Colors.blue;

    if (icon == Icons.wb_sunny) {
      iconColor = Colors.amber;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(icon, size: 32, color: iconColor),

          const SizedBox(height: 8),

          Text(
            temp,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            day,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _currentTempLabel(Map<String, dynamic>? data) {
    try {
      final hourly = data?['hourly'] as Map<String, dynamic>?;
      final temps = hourly?['temperature_2m'] as List<dynamic>?;
      if (temps != null && temps.isNotEmpty) {
        return '${temps.first.toString()}°C';
      }
    } catch (_) {}
    return '---';
  }

  int _forecastPagesCount(Map<String, dynamic>? data) {
    final cards = _forecastCards(data);
    // 6 cartes par page (3 colonnes x 2 lignes visuelles)
    final pages = (cards.length / 6).ceil();
    return pages == 0 ? 1 : pages;
  }

  List<Widget> _buildForecastPages(Map<String, dynamic>? data) {
    final cards = _forecastCards(data);
    final pages = <Widget>[];
    for (var i = 0; i < cards.length; i += 6) {
      pages.add(_weatherPage(cards.sublist(i, (i + 6).clamp(0, cards.length))));
    }
    if (pages.isEmpty) {
      pages.add(_weatherPage(const []));
    }
    return pages;
  }

  List<Map<String, dynamic>> _forecastCards(Map<String, dynamic>? data) {
    // On utilise le daily max/min pour afficher 7 jours si dispo
    try {
      final daily = data?['daily'] as Map<String, dynamic>?;
      final days = daily?['time'] as List<dynamic>?;
      final tMax = daily?['temperature_2m_max'] as List<dynamic>?;
      if (days == null || tMax == null) return [];
      final out = <Map<String, dynamic>>[];
      for (var i = 0; i < days.length && i < tMax.length; i++) {
        out.add({
          'temp': '${tMax[i]}°C',
          'day': i == 0 ? "Aujourd'hui" : days[i].toString(),
          'icon': Icons.wb_cloudy,
        });
      }
      return out;
    } catch (_) {
      return [];
    }
  }
}