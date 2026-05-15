import '../entities/clothing_item.dart';
import '../repositories/wardrobe_repository.dart';

class GetWardrobeItems {
  final WardrobeRepository repository;

  GetWardrobeItems(this.repository);

  Future<List<ClothingItem>> call(String userId) {
    return repository.getItems(userId);
  }
}