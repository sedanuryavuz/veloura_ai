import '../../domain/entities/outfit.dart';
import 'clothing_item_model.dart';

class OutfitModel extends Outfit {
  const OutfitModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.items,
    required super.createdAt,
  });

  @override
  List<ClothingItemModel> get items => super.items.map((e) => ClothingItemModel.fromEntity(e)).toList();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory OutfitModel.fromMap(Map<String, dynamic> map) {
    var rawItems = map['outfit_items'] as List<dynamic>? ?? [];
    List<ClothingItemModel> parsedItems = [];
    
    for (var item in rawItems) {
      if (item is Map && item['wardrobe_items'] != null) {
        parsedItems.add(ClothingItemModel.fromMap(item['wardrobe_items']));
      }
    }

    return OutfitModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'My Outfit',
      items: parsedItems,
      createdAt: map['created_at'] != null 
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory OutfitModel.fromEntity(Outfit entity) {
    return OutfitModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      items: entity.items.map((e) => ClothingItemModel.fromEntity(e)).toList(),
      createdAt: entity.createdAt,
    );
  }

  Outfit toEntity() {
    return Outfit(
      id: id,
      userId: userId,
      name: name,
      items: items.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}
