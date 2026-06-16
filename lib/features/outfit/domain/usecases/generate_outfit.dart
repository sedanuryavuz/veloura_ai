import '../entities/outfit.dart';
import '../entities/clothing_item.dart';
import '../repositories/outfit_repository.dart';

class GenerateOutfit {
  final OutfitRepository repository;

  GenerateOutfit(this.repository);

  Future<Outfit?> execute({
    required List<ClothingItem> wardrobe,
    List<String> previousOutfitIds = const [],
  }) {
    return repository.generateAiOutfit(
      wardrobe: wardrobe,
      previousOutfitIds: previousOutfitIds,
    );
  }
}
