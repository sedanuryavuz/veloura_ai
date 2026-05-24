import '../entities/outfit.dart';
import '../entities/clothing_item.dart';
import '../repositories/outfit_repository.dart';

class GenerateOutfit {
  final OutfitRepository repository;

  GenerateOutfit(this.repository);

  Future<Outfit?> execute({
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
    List<String> previousOutfitIds = const [],
  }) {
    return repository.generateAiOutfit(
      wardrobe: wardrobe,
      weather: weather,
      previousOutfitIds: previousOutfitIds,
    );
  }
}
