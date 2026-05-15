import '../entities/clothing_item.dart';
import '../repositories/wardrobe_repository.dart';

class UpdateClothingItem {
  final WardrobeRepository repository;

  UpdateClothingItem(this.repository);

  Future<ClothingItem> call(ClothingItem item) {
    return repository.updateItem(item);
  }
}

class DeleteClothingItem {
  final WardrobeRepository repository;

  DeleteClothingItem(this.repository);

  Future<void> call(String id) {
    return repository.deleteItem(id);
  }
}
