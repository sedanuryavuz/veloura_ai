import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/enums/categories.dart';

class ClothingFormController extends ChangeNotifier {
  File? image;
  String name = '';
  ClothingCategory category = ClothingCategory.top;

  void setImage(File file) {
    image = file;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
  }

  void setCategory(ClothingCategory value) {
    category = value;
    notifyListeners();
  }

  bool get isValid => image != null && name.trim().isNotEmpty;
}