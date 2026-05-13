import '../../wardrobe/models/clothing_item_model.dart';
import '../../../core/constants/categories.dart';

class OutfitModel {
  final String id;
  final String userId;
  final String name;
  final List<ClothingItemModel> items;
  final DateTime createdAt;

  const OutfitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  ClothingItemModel? get top => items.where((i) => i.category == ClothingCategory.top).firstOrNull;
  ClothingItemModel? get bottom => items.where((i) => i.category == ClothingCategory.bottom).firstOrNull;
  ClothingItemModel? get shoes => items.where((i) => i.category == ClothingCategory.shoes).firstOrNull;

  OutfitModel copyWith({
    String? id,
    String? userId,
    String? name,
    List<ClothingItemModel>? items,
    DateTime? createdAt,
  }) {
    return OutfitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
      if (item['wardrobe_items'] != null) {
        parsedItems.add(ClothingItemModel.fromMap(item['wardrobe_items']));
      }
    }

    return OutfitModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String? ?? 'My Outfit',
      items: parsedItems,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OutfitModel &&
      other.id == id &&
      other.userId == userId &&
      other.name == name &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      createdAt.hashCode;
  }
}