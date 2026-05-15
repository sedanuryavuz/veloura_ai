class AiOutfitModel {
  final String outfitName;
  final String style;
  final String reason;
  final List<AiOutfitItemModel> items;

  AiOutfitModel({
    required this.outfitName,
    required this.style,
    required this.reason,
    required this.items,
  });

  factory AiOutfitModel.fromMap(Map<String, dynamic> map) {
    return AiOutfitModel(
      outfitName: map['outfit_name'] ?? '',
      style: map['style'] ?? '',
      reason: map['reason'] ?? '',
      items: List<AiOutfitItemModel>.from(
        (map['items'] ?? []).map(
          (e) => AiOutfitItemModel.fromMap(e),
        ),
      ),
    );
  }
}
class AiOutfitItemModel {
  final String id;
  final String name;
  final String category;

  AiOutfitItemModel({
    required this.id,
    required this.name,
    required this.category,
  });

  factory AiOutfitItemModel.fromMap(Map<String, dynamic> map) {
    return AiOutfitItemModel(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      category: map['category'] ?? '',
    );
  }
}