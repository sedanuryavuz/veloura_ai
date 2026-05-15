import 'package:flutter/material.dart';

import '../../wardrobe/data/models/clothing_model.dart';
import '../models/outfit_model.dart';
import '../repositories/outfit_repository.dart';

class OutfitProvider extends ChangeNotifier {
  final OutfitRepository _repository;

  OutfitProvider(this._repository);

  List<OutfitModel> _outfits = [];
  List<OutfitModel> get outfits => List.unmodifiable(_outfits);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ClothingModel? selectedTop;
  ClothingModel? selectedBottom;
  ClothingModel? selectedShoes;

  String? editingOutfitId;

  Future<void> loadOutfits(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _outfits = await _repository.getOutfits(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveOutfit(String userId) async {
    if (selectedTop == null && selectedBottom == null && selectedShoes == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<ClothingModel> items = [];
      if (selectedTop != null) items.add(selectedTop!);
      if (selectedBottom != null) items.add(selectedBottom!);
      if (selectedShoes != null) items.add(selectedShoes!);

      if (editingOutfitId != null) {
        final existingIndex = _outfits.indexWhere((e) => e.id == editingOutfitId);
        if (existingIndex != -1) {
          final existingOutfit = _outfits[existingIndex];
          final updatedOutfit = OutfitModel(
            id: existingOutfit.id,
            userId: userId,
            name: existingOutfit.name,
            items: items,
            createdAt: existingOutfit.createdAt,
          );
          
          await _repository.updateOutfit(updatedOutfit);
          _outfits[existingIndex] = updatedOutfit;
        }
        editingOutfitId = null;
      } else {
        final outfit = OutfitModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          name: 'My Outfit',
          items: items,
          createdAt: DateTime.now(),
        );

        final savedOutfit = await _repository.createOutfit(outfit);
        _outfits.insert(0, savedOutfit);
      }
      clearSelection();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteOutfit(String id) async {
    try {
      await _repository.deleteOutfit(id);
      _outfits.removeWhere((e) => e.id == id);
      if (editingOutfitId == id) {
        clearSelection();
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void selectTop(ClothingModel item) {
    selectedTop = item;
    notifyListeners();
  }

  void selectBottom(ClothingModel item) {
    selectedBottom = item;
    notifyListeners();
  }

  void selectShoes(ClothingModel item) {
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

  void clearSelection() {
    selectedTop = null;
    selectedBottom = null;
    selectedShoes = null;
    editingOutfitId = null;
    notifyListeners();
  }
}
