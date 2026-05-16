import 'package:flutter/material.dart';
import '../../domain/entities/outfit.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/usecases/get_outfits.dart';
import '../../domain/usecases/save_outfit.dart';
import '../../domain/usecases/delete_outfit.dart';
import '../../domain/usecases/generate_outfit.dart';

class OutfitProvider extends ChangeNotifier {
  final GetOutfits getOutfitsUsecase;
  final SaveOutfit saveOutfitUsecase;
  final DeleteOutfit deleteOutfitUsecase;
  final GenerateOutfit generateOutfitUsecase;

  OutfitProvider({
    required this.getOutfitsUsecase,
    required this.saveOutfitUsecase,
    required this.deleteOutfitUsecase,
    required this.generateOutfitUsecase,
  });

  List<Outfit> _outfits = [];
  List<Outfit> get outfits => List.unmodifiable(_outfits);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ClothingItem? selectedTop;
  ClothingItem? selectedBottom;
  ClothingItem? selectedShoes;

  String? editingOutfitId;

  Future<void> loadOutfits(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _outfits = await getOutfitsUsecase.execute(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveOutfit(String userId) async {
    final List<ClothingItem> items = [];
    if (selectedTop != null) items.add(selectedTop!);
    if (selectedBottom != null) items.add(selectedBottom!);
    if (selectedShoes != null) items.add(selectedShoes!);

    if (items.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final outfit = Outfit(
        id: editingOutfitId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: 'My Outfit',
        items: items,
        createdAt: DateTime.now(),
      );

      final savedOutfit = await saveOutfitUsecase.execute(outfit);
      
      if (editingOutfitId != null) {
        final index = _outfits.indexWhere((e) => e.id == editingOutfitId);
        if (index != -1) {
          _outfits[index] = savedOutfit;
        }
      } else {
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
      await deleteOutfitUsecase.execute(id);
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

  Future<void> generateAiOutfit({
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final aiOutfit = await generateOutfitUsecase.execute(
        wardrobe: wardrobe,
        weather: weather,
      );

      if (aiOutfit != null) {
        selectedTop = aiOutfit.items.where((i) => i.category.name == 'top').firstOrNull;
        selectedBottom = aiOutfit.items.where((i) => i.category.name == 'bottom').firstOrNull;
        selectedShoes = aiOutfit.items.where((i) => i.category.name == 'shoes').firstOrNull;
      } else {
        _error = "AI could not generate an outfit.";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTop(ClothingItem item) {
    selectedTop = item;
    notifyListeners();
  }

  void selectBottom(ClothingItem item) {
    selectedBottom = item;
    notifyListeners();
  }

  void selectShoes(ClothingItem item) {
    selectedShoes = item;
    notifyListeners();
  }

  void setEditingOutfit(Outfit outfit) {
    editingOutfitId = outfit.id;
    selectedTop = outfit.items.where((i) => i.category.name == 'top').firstOrNull;
    selectedBottom = outfit.items.where((i) => i.category.name == 'bottom').firstOrNull;
    selectedShoes = outfit.items.where((i) => i.category.name == 'shoes').firstOrNull;
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
