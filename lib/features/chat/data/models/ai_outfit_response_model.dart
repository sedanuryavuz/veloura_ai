import '../../domain/entities/ai_outfit_response.dart';

class AiOutfitItemModel extends AiOutfitItem {
  const AiOutfitItemModel({
    required super.id,
    required super.name,
    required super.category,
  });

  factory AiOutfitItemModel.fromJson(Map<String, dynamic> json) {
    return AiOutfitItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
    };
  }
}

class AiOutfitResponseModel extends AiOutfitResponse {
  const AiOutfitResponseModel({
    required super.title,
    required List<AiOutfitItemModel> super.outfitItems,
    required super.reason,
    required super.style,
    super.weatherNote,
  });

  factory AiOutfitResponseModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['outfit_items'] as List?;
    List<AiOutfitItemModel> items = itemsList != null
        ? itemsList.map((i) => AiOutfitItemModel.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return AiOutfitResponseModel(
      title: json['title'] as String? ?? '',
      outfitItems: items,
      reason: json['reason'] as String? ?? '',
      style: json['style'] as String? ?? '',
      weatherNote: json['weather_note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'outfit_items': outfitItems.map((e) => (e as AiOutfitItemModel).toJson()).toList(),
      'reason': reason,
      'style': style,
      'weather_note': weatherNote,
    };
  }
}
