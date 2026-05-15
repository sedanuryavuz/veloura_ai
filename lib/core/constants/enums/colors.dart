enum ClothingColor {
  black,
  white,
  gray,
  blue,
  red,
  green,
  brown,
  beige,
  pink,
  yellow,
}

extension ClothingColorExt on ClothingColor {
  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  static ClothingColor fromString(String value) {
    return ClothingColor.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => ClothingColor.black,
    );
  }
}