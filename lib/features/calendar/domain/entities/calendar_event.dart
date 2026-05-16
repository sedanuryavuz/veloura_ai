import '../../../outfit/domain/entities/outfit.dart';

class CalendarEvent {
  final String id;
  final String userId;
  final String outfitId;
  final DateTime date;
  final Outfit? outfit;
  final DateTime createdAt;

  const CalendarEvent({
    required this.id,
    required this.userId,
    required this.outfitId,
    required this.date,
    this.outfit,
    required this.createdAt,
  });

  CalendarEvent copyWith({
    String? id,
    String? userId,
    String? outfitId,
    DateTime? date,
    Outfit? outfit,
    DateTime? createdAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      outfitId: outfitId ?? this.outfitId,
      date: date ?? this.date,
      outfit: outfit ?? this.outfit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
