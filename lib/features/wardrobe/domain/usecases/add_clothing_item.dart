import '../entities/clothing_item.dart';
import '../repositories/wardrobe_repository.dart';

class AddClothingItem {
  final WardrobeRepository repository;

  AddClothingItem(this.repository);

  Future<ClothingItem> call(ClothingItem item) {
    return repository.addItem(item);
  }
}
