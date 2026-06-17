import 'package:flutter/material.dart';
import '../../../../core/constants/enums/categories.dart';
import '../../domain/entities/outfit.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/user_ai_limit.dart';
import '../../domain/repositories/outfit_repository.dart';
import '../../domain/usecases/get_outfits.dart';
import '../../domain/usecases/save_outfit.dart';
import '../../domain/usecases/delete_outfit.dart';
import '../../domain/usecases/generate_outfit.dart';

class OutfitProvider extends ChangeNotifier {
  final GetOutfits getOutfitsUsecase;
  final SaveOutfit saveOutfitUsecase;
  final DeleteOutfit deleteOutfitUsecase;
  final GenerateOutfit generateOutfitUsecase;
  final OutfitRepository outfitRepository;

  OutfitProvider({
    required this.getOutfitsUsecase,
    required this.saveOutfitUsecase,
    required this.deleteOutfitUsecase,
    required this.generateOutfitUsecase,
    required this.outfitRepository,
  });

  List<Outfit> _outfits = [];
  List<Outfit> get outfits => List.unmodifiable(_outfits);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? aiStyle;
  String? aiReason;
  String? aiName;

  ClothingItem? selectedTop;
  ClothingItem? selectedBottom;
  ClothingItem? selectedShoes;
  ClothingItem? selectedAccessory;

  UserAiLimit? _aiLimit;
  UserAiLimit? get aiLimit => _aiLimit;

  final List<String> _suggestedOutfitIds = [];

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

  Future<void> loadAiLimits(String userId) async {
    try {
      _aiLimit = await outfitRepository.getOrCreateAiLimit(userId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading AI limits: $e");
    }
  }

  Future<void> saveOutfit(String userId, String name) async {
    final List<ClothingItem> items = [];
    if (selectedTop != null) items.add(selectedTop!);
    if (selectedBottom != null) items.add(selectedBottom!);
    if (selectedShoes != null) items.add(selectedShoes!);
    if (selectedAccessory != null) items.add(selectedAccessory!);

    if (items.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final outfit = Outfit(
        id: editingOutfitId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: name,
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
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = wardrobe.isNotEmpty ? wardrobe.first.userId : '';
      if (userId.isEmpty) {
        throw Exception("User ID not found in wardrobe items.");
      }

      // Check limits before sending the AI request
      final currentLimit = await outfitRepository.getOrCreateAiLimit(userId);
      _aiLimit = currentLimit;

      if (currentLimit != null && !currentLimit.hasCredits) {
        throw Exception("You've reached your daily limit of 2 outfit generations today.");
      }

      final aiOutfit = await generateOutfitUsecase.execute(
        wardrobe: wardrobe,
        previousOutfitIds: _suggestedOutfitIds,
      );

      if (aiOutfit != null) {
        selectedTop = aiOutfit.items.where((i) => i.category == ClothingCategory.top).firstOrNull;
        selectedBottom = aiOutfit.items.where((i) => i.category == ClothingCategory.bottom).firstOrNull;
        selectedShoes = aiOutfit.items.where((i) => i.category == ClothingCategory.shoes).firstOrNull;
        selectedAccessory = aiOutfit.items.where((i) => i.category == ClothingCategory.accessories).firstOrNull;

        aiStyle = aiOutfit.style;
        aiReason = aiOutfit.reason;
        aiName = aiOutfit.name;

        // Add to suggestion history to avoid repetition
        final combinationId = aiOutfit.items.map((e) => e.id).join('-');
        _suggestedOutfitIds.add(combinationId);

        // Increment the daily limit count after a successful generation
        final updatedLimit = await outfitRepository.incrementAiLimit(userId);
        _aiLimit = updatedLimit;
      } else {
        _error = "AI could not generate an outfit.";
      }
    } catch (e) {
      final errorStr = e.toString();
      _error = errorStr.startsWith('Exception: ') ? errorStr.replaceFirst('Exception: ', '') : errorStr;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAccessory(ClothingItem item) {
    selectedAccessory = item;
    notifyListeners();
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
    selectedTop = outfit.items.where((i) => i.category == ClothingCategory.top).firstOrNull;
    selectedBottom = outfit.items.where((i) => i.category == ClothingCategory.bottom).firstOrNull;
    selectedShoes = outfit.items.where((i) => i.category == ClothingCategory.shoes).firstOrNull;
    selectedAccessory = outfit.items.where((i) => i.category == ClothingCategory.accessories).firstOrNull;
    notifyListeners();
  }

  void clearSelection() {
    selectedTop = null;
    selectedBottom = null;
    selectedShoes = null;
    selectedAccessory = null;
    editingOutfitId = null;
    notifyListeners();
  }
}
