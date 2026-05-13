import 'package:flutter/material.dart';
import '../models/outfit_model.dart';
import '../../wardrobe/models/clothing_item_model.dart';

class OutfitController extends ChangeNotifier {
  final List<OutfitModel> _outfits = [];
  List<OutfitModel> get outfits => List.unmodifiable(_outfits);

  ClothingItemModel? selectedTop;
  ClothingItemModel? selectedBottom;
  ClothingItemModel? selectedShoes;

  String? editingOutfitId;

  void selectTop(ClothingItemModel item) {
    selectedTop = item;
    notifyListeners();
  }

  void selectBottom(ClothingItemModel item) {
    selectedBottom = item;
    notifyListeners();
  }

  void selectShoes(ClothingItemModel item) {
    selectedShoes = item;
    notifyListeners();
  }

  void setEditingOutfit(OutfitModel outfit) {
    editingOutfitId = outfit.id;
    selectedTop = outfit.top;
    selectedBottom = outfit.bottom;
    selectedShoes = outfit.shoes;
    notifyListeners();
  }

  void saveOutfit() {
    if (selectedTop == null && selectedBottom == null && selectedShoes == null) return;

    if (editingOutfitId != null) {
      final existingIndex = _outfits.indexWhere((e) => e.id == editingOutfitId);
      if (existingIndex != -1) {
        final existingOutfit = _outfits[existingIndex];
        final updatedOutfit = OutfitModel(
          id: existingOutfit.id,
          top: selectedTop,
          bottom: selectedBottom,
          shoes: selectedShoes,
          createdAt: existingOutfit.createdAt,
        );
        _outfits[existingIndex] = updatedOutfit;
      }
      editingOutfitId = null;
    } else {
      final outfit = OutfitModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        top: selectedTop,
        bottom: selectedBottom,
        shoes: selectedShoes,
        createdAt: DateTime.now(),
      );
      _outfits.add(outfit);
    }
    
    notifyListeners();
  }

  void deleteOutfit(String id) {
    _outfits.removeWhere((e) => e.id == id);
    if (editingOutfitId == id) {
      clearSelection();
    }
    notifyListeners();
  }

  void updateOutfit(OutfitModel updated) {
    final index = _outfits.indexWhere((e) => e.id == updated.id);

    if (index != -1) {
      _outfits[index] = updated;
      notifyListeners();
    }
  }

  void clearSelection() {
    selectedTop = null;
    selectedBottom = null;
    selectedShoes = null;
    editingOutfitId = null;
    notifyListeners();
  }
}