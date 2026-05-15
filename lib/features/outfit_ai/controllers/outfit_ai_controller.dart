import 'package:flutter/material.dart';

import '../models/ai_outfit_result.dart';
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

  String? error;

  AiOutfitResult? result;

  Future<void> generateOutfit({
    required List wardrobe,
  }) async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      final position =
          await locationService.getLocation();

      final weather =
          await weatherService.getWeather(
        position.latitude,
        position.longitude,
      );

      result = await aiService.generateOutfit(
        items: wardrobe,
        weather: weather,
      );

      if (result == null) {
        throw Exception("AI result null");
      }
    } catch (e) {
      error = e.toString();

      debugPrint(
        "OUTFIT AI CONTROLLER ERROR: $e",
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}