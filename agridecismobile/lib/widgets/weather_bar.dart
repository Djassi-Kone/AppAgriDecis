import 'package:flutter/material.dart';

import '../core/weather_service.dart';

/// Barre météo avec données réelles (ville + température).
/// Par défaut : Bamako. Optionnellement [lat], [lon] pour un autre lieu.
class WeatherBarWidget extends StatefulWidget {
  final double lat;
  final double lon;
  final String cityLabel;
  final void Function(String)? onMenuSelected;

  const WeatherBarWidget({
    super.key,
    this.lat = 12.6392,
    this.lon = -8.0029,
    this.cityLabel = 'Bamako - Mali',
    this.onMenuSelected,
  });

  @override
  State<WeatherBarWidget> createState() => _WeatherBarWidgetState();
}

class _WeatherBarWidgetState extends State<WeatherBarWidget> {
  final WeatherService _weather = WeatherService();
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _weather.forecast(lat: widget.lat, lon: widget.lon);
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _tempLabel() {
    if (_loading) return 'Chargement...';
    if (_error != null) return '---';
    try {
      final hourly = _data?['hourly'] as Map<String, dynamic>?;
      final temps = hourly?['temperature_2m'] as List<dynamic>?;
      if (temps != null && temps.isNotEmpty) {
        final t = (temps.first is num) ? (temps.first as num).toDouble() : double.tryParse(temps.first.toString());
        if (t != null) {
          String feel = 'Fraîcheur';
          if (t < 20) feel = 'Frais';
          else if (t > 30) feel = 'Chaleur';
          return '${t.toStringAsFixed(0)}°C $feel';
        }
      }
    } catch (_) {}
    return '---';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(
                widget.cityLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _tempLabel(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          if (_error != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _load,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) => widget.onMenuSelected?.call(value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(value: 'Historiques météo', child: Text('Historiques météo')),
              const PopupMenuItem<String>(value: 'Alerte Météo', child: Text('Alerte Météo')),
            ],
          ),
        ],
      ),
    );
  }
}
