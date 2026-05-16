import 'clothing_item.dart';

class Outfit {
  final String id;
  final String userId;
  final String name;
  final List<ClothingItem> items;
  final DateTime createdAt;

  ClothingItem? get top => items.where((i) => i.category.name == 'top').firstOrNull;
  ClothingItem? get bottom => items.where((i) => i.category.name == 'bottom').firstOrNull;
  ClothingItem? get shoes => items.where((i) => i.category.name == 'shoes').firstOrNull;

  const Outfit({
    required this.id,
    required this.userId,
    required this.name,
    required this.items,
    required this.createdAt,
  });
}
