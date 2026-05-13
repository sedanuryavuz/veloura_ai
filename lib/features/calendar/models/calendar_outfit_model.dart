import '../../outfit/models/outfit_model.dart';

class CalendarOutfitModel {
  final String id;
  final String userId;
  final String outfitId;
  final DateTime date;
  final OutfitModel outfit;
  final DateTime createdAt;

  const CalendarOutfitModel({
    required this.id,
    required this.userId,
    required this.outfitId,
    required this.date,
    required this.outfit,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'outfit_id': outfitId,
      'selected_date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CalendarOutfitModel.fromMap(Map<String, dynamic> map) {
    return CalendarOutfitModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      outfitId: map['outfit_id'] as String,
      date: DateTime.parse(map['selected_date'] as String),
      outfit: OutfitModel.fromMap(map['outfits'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}