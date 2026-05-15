class ClothingAnalysisModel {
  final String name;
  final String category;
  final String color;
  final String style;

  const ClothingAnalysisModel({
    required this.name,
    required this.category,
    required this.color,
    required this.style,
  });

  factory ClothingAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ClothingAnalysisModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      color: json['color'] ?? '',
      style: json['style'] ?? '',
    );
  }
}