import '../../../core/constants/categories.dart';

class ClothingItemModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String name;
  final ClothingCategory category;
  final DateTime createdAt;

  const ClothingItemModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.createdAt,
  });

  ClothingItemModel copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? name,
    ClothingCategory? category,
    DateTime? createdAt,
  }) {
    return ClothingItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'name': name,
      'category': category.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ClothingItemModel.fromMap(Map<String, dynamic> map) {
    return ClothingItemModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      category: ClothingCategoryExt.fromString(map['category'] as String), 
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
