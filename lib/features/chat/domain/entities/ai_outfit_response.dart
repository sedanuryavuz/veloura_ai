class AiOutfitItem {
  final String id;
  final String name;
  final String category;

  const AiOutfitItem({
    required this.id,
    required this.name,
    required this.category,
  });
}

class AiOutfitResponse {
  final String title;
  final List<AiOutfitItem> outfitItems;
  final String reason;
  final String style;
  final String? weatherNote;

  const AiOutfitResponse({
    required this.title,
    required this.outfitItems,
    required this.reason,
    required this.style,
    this.weatherNote,
  });
}
