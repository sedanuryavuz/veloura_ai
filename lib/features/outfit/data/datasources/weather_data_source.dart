import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_category.dart';

abstract class WeatherDataSource {
  Future<Map<String, dynamic>> getWeather(double lat, double lon);
}

class WeatherDataSourceImpl implements WeatherDataSource {
  @override
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url = "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final weatherCodeVal = data["current_weather"]?["weathercode"] ?? data["current_weather"]?["weather_code"] ?? 0;
    final info = WeatherConditionMapper.fromCode((weatherCodeVal as num).toInt());

    return {
      "temperature": data["current_weather"]["temperature"],
      "condition": info.condition,
      "category": info.category.name,
      "description": info.condition,
    };
  }
}
