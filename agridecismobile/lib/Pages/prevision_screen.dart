// lib/screens/prevision_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class PrevisionScreen extends StatefulWidget {
  const PrevisionScreen({super.key});

  @override
  State<PrevisionScreen> createState() => _PrevisionScreenState();
}

class _PrevisionScreenState extends State<PrevisionScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _showMenuOption(BuildContext context, String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Option sélectionnée : $option')),
    );
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bamako - Mali',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '26°C Fraicheur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _weatherPage([
                    {"temp": "23°C", "day": "Aujourd'hui", "icon": Icons.wb_sunny},
                    {"temp": "2°C", "day": "Demain", "icon": Icons.cloud},
                    {"temp": "13°C", "day": "Après-demain", "icon": Icons.wb_cloudy},
                    {"temp": "15°C", "day": "Lundi", "icon": Icons.wb_cloudy},
                    {"temp": "25°C", "day": "Mardi", "icon": Icons.wb_sunny},
                    {"temp": "41°C", "day": "Mercredi", "icon": Icons.grain},
                  ]),
                  _weatherPage([
                    {"temp": "29°C", "day": "Jeudi", "icon": Icons.wb_sunny},
                    {"temp": "27°C", "day": "Vendredi", "icon": Icons.cloud},
                    {"temp": "24°C", "day": "Samedi", "icon": Icons.wb_cloudy},
                    {"temp": "26°C", "day": "Dimanche", "icon": Icons.wb_sunny},
                    {"temp": "30°C", "day": "Lundi", "icon": Icons.wb_sunny},
                    {"temp": "31°C", "day": "Mardi", "icon": Icons.grain},
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// INDICATEUR PAGES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
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
}