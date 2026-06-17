import '../../domain/entities/user_ai_limit.dart';

class UserAiLimitModel extends UserAiLimit {
  UserAiLimitModel({
    required super.userId,
    required super.dailyAiOutfitCount,
    required super.lastAiResetDate,
    required super.createdAt,
  });

  factory UserAiLimitModel.fromMap(Map<String, dynamic> map) {
    return UserAiLimitModel(
      userId: map['user_id'] as String,
      dailyAiOutfitCount: map['daily_ai_outfit_count'] as int,
      lastAiResetDate: DateTime.parse(map['last_ai_reset_date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'daily_ai_outfit_count': dailyAiOutfitCount,
      'last_ai_reset_date': lastAiResetDate.toIso8601String().substring(0, 10), // DATE type formatted as yyyy-MM-dd
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserAiLimit toEntity() {
    return UserAiLimit(
      userId: userId,
      dailyAiOutfitCount: dailyAiOutfitCount,
      lastAiResetDate: lastAiResetDate,
      createdAt: createdAt,
    );
  }

  factory UserAiLimitModel.fromEntity(UserAiLimit entity) {
    return UserAiLimitModel(
      userId: entity.userId,
      dailyAiOutfitCount: entity.dailyAiOutfitCount,
      lastAiResetDate: entity.lastAiResetDate,
      createdAt: entity.createdAt,
    );
  }

  UserAiLimitModel copyWith({
    String? userId,
    int? dailyAiOutfitCount,
    DateTime? lastAiResetDate,
    DateTime? createdAt,
  }) {
    return UserAiLimitModel(
      userId: userId ?? this.userId,
      dailyAiOutfitCount: dailyAiOutfitCount ?? this.dailyAiOutfitCount,
      lastAiResetDate: lastAiResetDate ?? this.lastAiResetDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
