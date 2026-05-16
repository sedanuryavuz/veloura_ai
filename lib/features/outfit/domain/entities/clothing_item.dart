import '../../../../core/constants/enums/categories.dart';

class ClothingItem {
  final String id;
  final String userId;
  final String imageUrl;
  final String name;
  final String color;
  final String style;
  final String description;
  final ClothingCategory category;
  final DateTime createdAt;

  const ClothingItem({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.color,
    required this.style,
    required this.description,
  });
}
