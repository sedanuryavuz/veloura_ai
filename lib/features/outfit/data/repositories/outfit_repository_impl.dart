import 'dart:io';
import '../../domain/entities/outfit.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/repositories/outfit_repository.dart';
import '../datasources/outfit_remote_data_source.dart';
import '../datasources/outfit_ai_data_source.dart';
import '../datasources/background_removal_data_source.dart';
import '../datasources/storage_data_source.dart';
import '../models/outfit_model.dart';
import '../models/clothing_item_model.dart';

// Assuming we add these to datasources folder as well
import '../datasources/location_data_source.dart';
import '../datasources/weather_data_source.dart';

class OutfitRepositoryImpl implements OutfitRepository {
  final OutfitRemoteDataSource remoteDataSource;
  final OutfitAiDataSource aiDataSource;
  final BackgroundRemovalDataSource backgroundRemovalDataSource;
  final StorageDataSource storageDataSource;
  final LocationDataSource locationDataSource;
  final WeatherDataSource weatherDataSource;

  OutfitRepositoryImpl({
    required this.remoteDataSource,
    required this.aiDataSource,
    required this.backgroundRemovalDataSource,
    required this.storageDataSource,
    required this.locationDataSource,
    required this.weatherDataSource,
  });

  @override
  Future<List<Outfit>> getOutfits(String userId) async {
    final models = await remoteDataSource.getOutfits(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Outfit> saveOutfit(Outfit outfit) async {
    final model = OutfitModel.fromEntity(outfit);
    final savedModel = await remoteDataSource.createOutfit(model);
    return savedModel.toEntity();
  }

  @override
  Future<void> deleteOutfit(String id) async {
    await remoteDataSource.deleteOutfit(id);
  }

  @override
  Future<Outfit?> generateAiOutfit({
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) async {
    // We can use the passed weather or fetch it here if needed.
    // The existing GenerateAiOutfitUseCase fetches it.
    
    final location = await locationDataSource.getLocation();
    final currentWeather = await weatherDataSource.getWeather(location.latitude, location.longitude);

    final wardrobeJson = wardrobe.map((e) => ClothingItemModel.fromEntity(e).toMap()).toList();
    final result = await aiDataSource.generateOutfit(
      items: wardrobeJson,
      weather: currentWeather,
    );

    if (result == null) return null;

    final List<String> itemIds = (result['items'] as List)
        .map((e) => e['id'].toString())
        .toList();

    final selectedItems = wardrobe.where((item) => itemIds.contains(item.id)).toList();

    return Outfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: wardrobe.isNotEmpty ? wardrobe.first.userId : '',
      name: result['outfit_name'] ?? 'AI Outfit',
      items: selectedItems,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<File?> removeBackground(File image) async {
    return await backgroundRemovalDataSource.removeBackground(image);
  }

  @override
  Future<String> uploadImage(File file, String userId) async {
    return await storageDataSource.uploadImage(file, userId);
  }
}
