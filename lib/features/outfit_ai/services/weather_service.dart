import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";

    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);

    return {
      "temperature": data["current_weather"]["temperature"],
      "description": "clear", // basit tuttuk
    };
  }
}