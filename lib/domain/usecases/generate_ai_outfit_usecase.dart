import '../../features/outfit_ai/models/ai_outfit_result.dart';
import '../../features/outfit_ai/services/ai_outfit_service.dart';
import '../../features/outfit_ai/services/location_service.dart';
import '../../features/outfit_ai/services/weather_service.dart';

class GenerateAiOutfitUseCase {
  final AiOutfitService aiService;
  final LocationService locationService;
  final WeatherService weatherService;

  GenerateAiOutfitUseCase({
    required this.aiService,
    required this.locationService,
    required this.weatherService,
  });

  Future<AiOutfitResult?> execute({
    required List wardrobe,
  }) async {
    final position = await locationService.getLocation();
    
    final weather = await weatherService.getWeather(
      position.latitude,
      position.longitude,
    );

    return await aiService.generateOutfit(
      items: wardrobe,
      weather: weather,
    );
  }
}
