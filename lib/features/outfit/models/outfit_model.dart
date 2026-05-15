import '../../wardrobe/data/models/clothing_model.dart';
import '../../../core/constants/enums/categories.dart';

class OutfitModel {
  final String id;
  final String userId;
  final String name;
  final List<ClothingModel> items;
  final DateTime createdAt;

  const OutfitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  ClothingModel? get top => items.where((i) => i.category == ClothingCategory.top).firstOrNull;
  ClothingModel? get bottom => items.where((i) => i.category == ClothingCategory.bottom).firstOrNull;
  ClothingModel? get shoes => items.where((i) => i.category == ClothingCategory.shoes).firstOrNull;

  OutfitModel copyWith({
    String? id,
    String? userId,
    String? name,
    List<ClothingModel>? items,
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
    List<ClothingModel> parsedItems = [];
    
    for (var item in rawItems) {
      if (item is Map && item['wardrobe_items'] != null) {
        parsedItems.add(ClothingModel.fromMap(item['wardrobe_items']));
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