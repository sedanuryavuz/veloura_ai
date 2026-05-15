import 'package:flutter/material.dart';
import '../services/ai_outfit_service.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';

class OutfitAiController extends ChangeNotifier {
  final AiOutfitService aiService;
  final LocationService locationService;
  final WeatherService weatherService;

  OutfitAiController({
    required this.aiService,
    required this.locationService,
    required this.weatherService,
  });

  bool isLoading = false;
  Map<String, dynamic>? result;

  Future<void> generateOutfit({
    required List wardrobe,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await locationService.getLocation();

      final weather = await weatherService.getWeather(
        position.latitude,
        position.longitude,
      );

      result = await aiService.generateOutfit(
        items: wardrobe,
        weather: weather,
      );
    } catch (e) {
      print("CONTROLLER ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}