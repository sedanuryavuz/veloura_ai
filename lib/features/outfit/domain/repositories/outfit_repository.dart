import 'dart:io';
import '../entities/outfit.dart';
import '../entities/clothing_item.dart';
import '../entities/user_ai_limit.dart';

abstract class OutfitRepository {
  Future<List<Outfit>> getOutfits(String userId);
  Future<Outfit> saveOutfit(Outfit outfit);
  Future<void> deleteOutfit(String id);
  
  Future<Outfit?> generateAiOutfit({
    required List<ClothingItem> wardrobe,
    List<String> previousOutfitIds = const [],
  });

  Future<File?> removeBackground(File image);
  Future<String> uploadImage(File file, String userId);

  Future<UserAiLimit?> getOrCreateAiLimit(String userId);
  Future<UserAiLimit> incrementAiLimit(String userId);
}
