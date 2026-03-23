import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class WeatherService {
  Future<Map<String, dynamic>> forecast({required double lat, required double lon}) async {
    final res = await http.get(
      ApiConfig.weatherForecast(lat: lat, lon: lon),
      headers: {'Accept': 'application/json'},
    );
    if (res.statusCode != 200) {
      throw Exception('Météo indisponible (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}

