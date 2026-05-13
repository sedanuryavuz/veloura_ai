import '../../wardrobe/models/clothing_item_model.dart';

class OutfitModel {
  final String id;
  final ClothingItemModel? top;
  final ClothingItemModel? bottom;
  final ClothingItemModel? shoes;
  final DateTime createdAt;

  OutfitModel({
    required this.id,
    this.top,
    this.bottom,
    this.shoes,
    required this.createdAt,
  });

  OutfitModel copyWith({
    ClothingItemModel? top,
    ClothingItemModel? bottom,
    ClothingItemModel? shoes,
  }) {
    return OutfitModel(
      id: id,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      shoes: shoes ?? this.shoes,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OutfitModel &&
      other.id == id &&
      other.top == top &&
      other.bottom == bottom &&
      other.shoes == shoes &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      top.hashCode ^
      bottom.hashCode ^
      shoes.hashCode ^
      createdAt.hashCode;
  }
}