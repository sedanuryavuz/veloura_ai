class AiOutfitResult {
  final String outfitName;
  final String style;
  final String reason;
  final List<AiOutfitItem> items;

  AiOutfitResult({
    required this.outfitName,
    required this.style,
    required this.reason,
    required this.items,
  });

  factory AiOutfitResult.fromJson(Map<String, dynamic> json) {
    return AiOutfitResult(
      outfitName: json["outfit_name"] ?? "",
      style: json["style"] ?? "",
      reason: json["reason"] ?? "",
      items: (json["items"] as List)
          .map((e) => AiOutfitItem.fromJson(e))
          .toList(),
    );
  }
}

class AiOutfitItem {
  final String id;
  final String name;
  final String category;

  AiOutfitItem({
    required this.id,
    required this.name,
    required this.category,
  });

  factory AiOutfitItem.fromJson(Map<String, dynamic> json) {
    return AiOutfitItem(
      id: json["id"],
      name: json["name"],
      category: json["category"],
    );
  }
}