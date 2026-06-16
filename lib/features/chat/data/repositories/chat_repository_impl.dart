import 'package:veloura_ai/features/wardrobe/domain/entities/clothing_item.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../../../outfit/data/datasources/location_data_source.dart';
import '../../../outfit/data/datasources/weather_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;
  final LocationDataSource locationDataSource;
  final WeatherDataSource weatherDataSource;

  ChatRepositoryImpl({
    required this.chatRemoteDataSource,
    required this.locationDataSource,
    required this.weatherDataSource,
  });

  @override
  Future<ChatMessage> sendChatMessage({
    required String message,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) async {
    Map<String, dynamic> currentWeather = Map.from(weather);

    if (currentWeather.isEmpty) {
      try {
        final location = await locationDataSource.getLocation();
        currentWeather = await weatherDataSource.getWeather(location.latitude, location.longitude);
      } catch (e) {
        // Fallback default weather
        currentWeather = {
          "temperature": 20.0,
          "condition": "Sunny",
          "category": "sunny",
          "description": "Sunny",
        };
      }
    }

    final responseModel = await chatRemoteDataSource.getAIResponse(
      message: message,
      wardrobe: wardrobe,
      weather: currentWeather,
    );

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: responseModel.reason,
      isUser: false,
      createdAt: DateTime.now(),
      outfitResponse: responseModel,
    );
  }
}
