import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class WeatherDataSource {
  Future<Map<String, dynamic>> getWeather(double lat, double lon);
}

class WeatherDataSourceImpl implements WeatherDataSource {
  @override
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url = "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    return {
      "temperature": data["current_weather"]["temperature"],
      "description": "clear",
    };
  }
}
