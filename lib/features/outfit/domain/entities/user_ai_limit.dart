class UserAiLimit {
  final String userId;
  final int dailyAiOutfitCount;
  final DateTime lastAiResetDate;
  final DateTime createdAt;

  UserAiLimit({
    required this.userId,
    required this.dailyAiOutfitCount,
    required this.lastAiResetDate,
    required this.createdAt,
  });

  // Future-proofing for premium subscriptions
  int get maxCredits => 2; // Always 2 for now, can check user subscription in the future

  int get remainingCredits => (maxCredits - dailyAiOutfitCount).clamp(0, maxCredits);

  bool get hasCredits => dailyAiOutfitCount < maxCredits;
}
