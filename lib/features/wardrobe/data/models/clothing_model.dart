import 'package:veloura_ai/core/constants/enums/categories.dart';
import '../../domain/entities/clothing_item.dart';

class ClothingModel extends ClothingItem {
  const ClothingModel({
    required super.id,
    required super.userId,
    required super.imageUrl,
    required super.name,
    required super.category,
    required super.createdAt,
    required super.color,
    required super.style,
    required super.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'name': name,
      'category': category.name,
      'created_at': createdAt.toIso8601String(),
      'color': color,
      'style': style,
      'description': description,
    };
  }

  factory ClothingModel.fromMap(Map<String, dynamic> map) {
    return ClothingModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      imageUrl: map['image_url']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unnamed',
      category: ClothingCategoryExt.fromString(map['category']?.toString() ?? ''),
      createdAt: map['created_at'] != null 
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      color: map['color']?.toString() ?? '',
      style: map['style']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
    );
  }

  factory ClothingModel.fromEntity(ClothingItem entity) {
    return ClothingModel(
      id: entity.id,
      userId: entity.userId,
      imageUrl: entity.imageUrl,
      name: entity.name,
      category: entity.category,
      createdAt: entity.createdAt,
      color: entity.color,
      style: entity.style,
      description: entity.description,
    );
  }

  ClothingItem toEntity() {
    return ClothingItem(
      id: id,
      userId: userId,
      imageUrl: imageUrl,
      name: name,
      category: category,
      createdAt: createdAt,
      color: color,
      style: style,
      description: description,
    );
  }
}