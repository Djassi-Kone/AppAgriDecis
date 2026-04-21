import 'package:flutter/material.dart';

class WeatherAlertsPage extends StatefulWidget {
  const WeatherAlertsPage({super.key});

  @override
  State<WeatherAlertsPage> createState() => _WeatherAlertsPageState();
}

class _WeatherAlertsPageState extends State<WeatherAlertsPage> {
  final Map<String, double> _thresholds = {
    'temp_min': 15.0,
    'temp_max': 35.0,
    'humidity_min': 30.0,
    'humidity_max': 80.0,
    'wind_speed_max': 20.0,
    'rain_min': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertes Météo'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seuils d\'Alerte',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _thresholds.entries.map((entry) {
                  return _ThresholdCard(
                    title: _getThresholdTitle(entry.key),
                    value: entry.value,
                    unit: _getThresholdUnit(entry.key),
                    onChanged: (value) {
                      setState(() {
                        _thresholds[entry.key] = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seuils sauvegardés')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Sauvegarder'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset to defaults
                      setState(() {
                        _thresholds['temp_min'] = 15.0;
                        _thresholds['temp_max'] = 35.0;
                        _thresholds['humidity_min'] = 30.0;
                        _thresholds['humidity_max'] = 80.0;
                        _thresholds['wind_speed_max'] = 20.0;
                        _thresholds['rain_min'] = 0.0;
                      });
                    },
                    child: Text('Réinitialiser'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getThresholdTitle(String key) {
    switch (key) {
      case 'temp_min':
        return 'Température Minimale';
      case 'temp_max':
        return 'Température Maximale';
      case 'humidity_min':
        return 'Humidité Minimale';
      case 'humidity_max':
        return 'Humidité Maximale';
      case 'wind_speed_max':
        return 'Vitesse du Vent Maximale';
      case 'rain_min':
        return 'Pluie Minimale';
      default:
        return key;
    }
  }

  String _getThresholdUnit(String key) {
    switch (key) {
      case 'temp_min':
      case 'temp_max':
        return '°C';
      case 'humidity_min':
      case 'humidity_max':
        return '%';
      case 'wind_speed_max':
        return 'km/h';
      case 'rain_min':
        return 'mm';
      default:
        return '';
    }
  }
}

class _ThresholdCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final ValueChanged<double> onChanged;

  const _ThresholdCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.onChanged,
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
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    min: _getMinValue(title),
                    max: _getMaxValue(title),
                    divisions: _getDivisions(title),
                    onChanged: onChanged,
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 80,
                  child: Text(
                    '${value.toStringAsFixed(1)}$unit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getMinValue(String title) {
    if (title.contains('Température')) return -10.0;
    if (title.contains('Humidité')) return 0.0;
    if (title.contains('Vent')) return 0.0;
    if (title.contains('Pluie')) return 0.0;
    return 0.0;
  }

  double _getMaxValue(String title) {
    if (title.contains('Température')) return 50.0;
    if (title.contains('Humidité')) return 100.0;
    if (title.contains('Vent')) return 100.0;
    if (title.contains('Pluie')) return 50.0;
    return 100.0;
  }

  int _getDivisions(String title) {
    if (title.contains('Température')) return 60;
    if (title.contains('Humidité')) return 100;
    if (title.contains('Vent')) return 100;
    if (title.contains('Pluie')) return 50;
    return 100;
  }
}
