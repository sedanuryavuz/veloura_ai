import 'dart:io';
import '../../domain/entities/outfit.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/user_ai_limit.dart';
import '../../domain/repositories/outfit_repository.dart';
import '../datasources/outfit_remote_data_source.dart';
import '../datasources/outfit_ai_data_source.dart';
import '../datasources/background_removal_data_source.dart';
import '../datasources/storage_data_source.dart';
import '../models/outfit_model.dart';
import '../models/clothing_item_model.dart';
import '../models/user_ai_limit_model.dart';

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
    List<String> previousOutfitIds = const [],
  }) async {
    final location = await locationDataSource.getLocation();
    final currentWeather = await weatherDataSource.getWeather(location.latitude, location.longitude);

    final wardrobeJson = wardrobe.map((e) => ClothingItemModel.fromEntity(e).toMap()).toList();
    final result = await aiDataSource.generateOutfit(
      items: wardrobeJson,
      weather: currentWeather,
      previousOutfitIds: previousOutfitIds,
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
      style: result['style'],
      reason: result['reason'],
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

  @override
  Future<UserAiLimit?> getOrCreateAiLimit(String userId) async {
    final model = await remoteDataSource.getAiLimit(userId);
    final now = DateTime.now();

    if (model == null) {
      final newModel = UserAiLimitModel(
        userId: userId,
        dailyAiOutfitCount: 0,
        lastAiResetDate: now,
        createdAt: now,
      );
      final created = await remoteDataSource.createAiLimit(newModel);
      return created.toEntity();
    }

    // Check if reset is needed (if last reset was a different day)
    final lastReset = model.lastAiResetDate;
    final isNewDay = lastReset.year != now.year ||
                     lastReset.month != now.month ||
                     lastReset.day != now.day;

    if (isNewDay) {
      final updatedModel = model.copyWith(
        dailyAiOutfitCount: 0,
        lastAiResetDate: now,
      );
      final updated = await remoteDataSource.updateAiLimit(updatedModel);
      return updated.toEntity();
    }

    return model.toEntity();
  }

  @override
  Future<UserAiLimit> incrementAiLimit(String userId) async {
    final model = await remoteDataSource.getAiLimit(userId);
    if (model == null) {
      throw Exception("AI limit record not found.");
    }
    final updatedModel = model.copyWith(
      dailyAiOutfitCount: model.dailyAiOutfitCount + 1,
    );
    final updated = await remoteDataSource.updateAiLimit(updatedModel);
    return updated.toEntity();
  }
}
