import '../../../../core/constants/enums/categories.dart';
import 'clothing_item.dart';

class Outfit {
  final String id;
  final String userId;
  final String name;
  final String? style;
  final String? reason;
  final List<ClothingItem> items;
  final DateTime createdAt;

  const Outfit({
    required this.id,
    required this.userId,
    required this.name,
    this.style,
    this.reason,
    required this.items,
    required this.createdAt,
  });

  ClothingItem? get top => items.where((i) => i.category == ClothingCategory.top).firstOrNull;
  ClothingItem? get bottom => items.where((i) => i.category == ClothingCategory.bottom).firstOrNull;
  ClothingItem? get shoes => items.where((i) => i.category == ClothingCategory.shoes).firstOrNull;
  ClothingItem? get accessory => items.where((i) => i.category == ClothingCategory.accessories).firstOrNull;
}
