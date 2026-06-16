import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

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

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ClothingColor.black:
        return l10n.colorBlack;
      case ClothingColor.white:
        return l10n.colorWhite;
      case ClothingColor.gray:
        return l10n.colorGray;
      case ClothingColor.blue:
        return l10n.colorBlue;
      case ClothingColor.red:
        return l10n.colorRed;
      case ClothingColor.green:
        return l10n.colorGreen;
      case ClothingColor.brown:
        return l10n.colorBrown;
      case ClothingColor.beige:
        return l10n.colorBeige;
      case ClothingColor.pink:
        return l10n.colorPink;
      case ClothingColor.yellow:
        return l10n.colorYellow;
    }
  }

  static ClothingColor fromString(String value) {
    return ClothingColor.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => ClothingColor.black,
    );
  }
}