import '../../../outfit/data/models/outfit_model.dart';
import '../../domain/entities/calendar_event.dart';


class CalendarEventModel extends CalendarEvent {
  const CalendarEventModel({
    required super.id,
    required super.userId,
    required super.outfitId,
    required super.date,
    super.outfit,
    required super.createdAt,
  });

  factory CalendarEventModel.fromMap(Map<String, dynamic> map) {
    return CalendarEventModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      outfitId: map['outfit_id'] as String,
      date: DateTime.parse(map['selected_date'] as String),
      outfit: map['outfits'] != null ? OutfitModel.fromMap(map['outfits'] as Map<String, dynamic>) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'outfit_id': outfitId,
      'selected_date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'created_at': createdAt.toIso8601String(),
    };
  }

  CalendarEvent toEntity() {
    return CalendarEvent(
      id: id,
      userId: userId,
      outfitId: outfitId,
      date: date,
      outfit: outfit,
      createdAt: createdAt,
    );
  }

  factory CalendarEventModel.fromEntity(CalendarEvent entity) {
    return CalendarEventModel(
      id: entity.id,
      userId: entity.userId,
      outfitId: entity.outfitId,
      date: entity.date,
      outfit: entity.outfit,
      createdAt: entity.createdAt,
    );
  }
}
