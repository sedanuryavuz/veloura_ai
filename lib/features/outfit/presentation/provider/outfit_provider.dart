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
  ClothingItem? selectedDress;
  ClothingItem? selectedOuterwear;
  List<ClothingItem> selectedAccessories = [];

  UserAiLimit? _aiLimit;
  UserAiLimit? get aiLimit => _aiLimit;

  final List<String> _suggestedOutfitIds = [];
  String? editingOutfitId;

  Map<String, dynamic>? _currentWeather;
  Map<String, dynamic>? get currentWeather => _currentWeather;

  bool _isLoadingWeather = false;
  bool get isLoadingWeather => _isLoadingWeather;

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
    if (selectedDress != null) items.add(selectedDress!);
    if (selectedOuterwear != null) items.add(selectedOuterwear!);
    items.addAll(selectedAccessories);

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
        selectedDress = aiOutfit.items.where((i) => i.category == ClothingCategory.dress).firstOrNull;
        selectedOuterwear = aiOutfit.items.where((i) => i.category == ClothingCategory.outerwear).firstOrNull;
        selectedAccessories = aiOutfit.items.where((i) => [
          ClothingCategory.accessories,
          ClothingCategory.bag,
          ClothingCategory.hat,
          ClothingCategory.socks,
          ClothingCategory.jewelry,
          ClothingCategory.watch,
          ClothingCategory.glasses,
          ClothingCategory.belt,
          ClothingCategory.accessory,
        ].contains(i.category)).toList();
        selectedAccessory = selectedAccessories.firstOrNull;

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
    toggleAccessory(item);
  }

  void selectTop(ClothingItem item) {
    selectedTop = item;
    selectedDress = null;
    notifyListeners();
  }

  void selectBottom(ClothingItem item) {
    selectedBottom = item;
    selectedDress = null;
    notifyListeners();
  }

  void selectShoes(ClothingItem item) {
    selectedShoes = item;
    notifyListeners();
  }

  void selectDress(ClothingItem item) {
    selectedDress = item;
    selectedTop = null;
    selectedBottom = null;
    notifyListeners();
  }

  void selectOuterwear(ClothingItem item) {
    selectedOuterwear = item;
    notifyListeners();
  }

  void toggleAccessory(ClothingItem item) {
    final index = selectedAccessories.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      selectedAccessories.removeAt(index);
    } else {
      selectedAccessories.add(item);
    }
    selectedAccessory = selectedAccessories.firstOrNull;
    notifyListeners();
  }

  void setEditingOutfit(Outfit outfit) {
    editingOutfitId = outfit.id;
    selectedTop = outfit.items.where((i) => i.category == ClothingCategory.top).firstOrNull;
    selectedBottom = outfit.items.where((i) => i.category == ClothingCategory.bottom).firstOrNull;
    selectedShoes = outfit.items.where((i) => i.category == ClothingCategory.shoes).firstOrNull;
    selectedDress = outfit.items.where((i) => i.category == ClothingCategory.dress).firstOrNull;
    selectedOuterwear = outfit.items.where((i) => i.category == ClothingCategory.outerwear).firstOrNull;
    selectedAccessories = outfit.items.where((i) => [
      ClothingCategory.accessories,
      ClothingCategory.bag,
      ClothingCategory.hat,
      ClothingCategory.socks,
      ClothingCategory.jewelry,
      ClothingCategory.watch,
      ClothingCategory.glasses,
      ClothingCategory.belt,
      ClothingCategory.accessory,
    ].contains(i.category)).toList();
    selectedAccessory = selectedAccessories.firstOrNull;
    notifyListeners();
  }

  void clearSelection() {
    selectedTop = null;
    selectedBottom = null;
    selectedShoes = null;
    selectedDress = null;
    selectedOuterwear = null;
    selectedAccessory = null;
    selectedAccessories = [];
    editingOutfitId = null;
    notifyListeners();
  }

  Future<void> fetchWeather() async {
    if (_currentWeather != null) return;
    _isLoadingWeather = true;
    notifyListeners();
    try {
      _currentWeather = await outfitRepository.getCurrentWeather();
    } catch (e) {
      debugPrint("Error fetching weather in provider: $e");
      _currentWeather = null;
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  bool isAiGenerated(Outfit outfit) {
    return outfit.style != null && outfit.style!.isNotEmpty;
  }

  double calculateWeatherSuitability(Outfit outfit, Map<String, dynamic> weather) {
    final category = (weather['category'] as String?)?.toLowerCase() ?? 'sunny';
    final temp = (weather['temperature'] as num?)?.toDouble() ?? 20.0;

    double score = 0.0;

    // Combine all relevant text fields of the outfit and its items to search for keywords
    final outfitText = [
      outfit.name,
      outfit.style ?? '',
      outfit.reason ?? '',
      ...outfit.items.map((i) => '${i.name} ${i.style} ${i.description}'),
    ].join(' ').toLowerCase();

    bool hasAny(List<String> keywords) {
      return keywords.any((k) => outfitText.contains(k));
    }

    // Category matching logic
    if (category == 'rainy' || category == 'stormy') {
      if (hasAny(['waterproof', 'rain', 'jacket', 'hoodie', 'coat', 'boots', 'trench', 'windbreaker', 'umbrella', 'leather'])) {
        score += 5.0;
      }
      if (hasAny(['shorts', 'sandals', 'tank top', 'slides', 'flip flops', 'skirt'])) {
        score -= 3.0;
      }
    } else if (category == 'sunny') {
      if (hasAny(['light', 'summer', 'sun', 'shorts', 'sandals', 't-shirt', 'skirt', 'linen', 'sunglasses', 'tank', 'breezy', 'cotton'])) {
        score += 5.0;
      }
      if (hasAny(['heavy coat', 'snow boots', 'puffer', 'winter coat', 'wool coat', 'cashmere'])) {
        score -= 4.0;
      }
    } else if (category == 'snowy') {
      if (hasAny(['snow', 'boots', 'heavy', 'coat', 'jacket', 'puffer', 'wool', 'gloves', 'scarf', 'knit', 'sweater', 'thermal', 'warm'])) {
        score += 6.0;
      }
      if (hasAny(['shorts', 'sandals', 't-shirt', 'skirt'])) {
        score -= 5.0;
      }
    } else if (category == 'cloudy' || category == 'foggy') {
      if (hasAny(['cardigan', 'sweater', 'jeans', 'sneakers', 'hoodie', 'jacket', 'pants'])) {
        score += 2.0;
      }
    }

    // Temperature matching logic
    if (temp < 12.0) {
      // Very cold
      if (hasAny(['coat', 'puffer', 'wool', 'sweater', 'heavy', 'boots', 'scarf', 'gloves', 'thermal', 'warm'])) {
        score += 5.0;
      }
      if (hasAny(['shorts', 'sandals', 'skirt', 'tank', 'short sleeve'])) {
        score -= 5.0;
      }
    } else if (temp < 18.0) {
      // Cool/Moderate
      if (hasAny(['jacket', 'sweater', 'cardigan', 'pants', 'jeans', 'long sleeve', 'hoodie'])) {
        score += 3.0;
      }
      if (hasAny(['sandals', 'shorts', 'tank'])) {
        score -= 2.0;
      }
    } else if (temp > 24.0) {
      // Hot
      if (hasAny(['shorts', 'sandals', 't-shirt', 'skirt', 'tank', 'linen', 'short sleeve', 'light', 'breezy'])) {
        score += 5.0;
      }
      if (hasAny(['coat', 'puffer', 'boots', 'wool', 'sweater', 'heavy', 'jacket'])) {
        score -= 5.0;
      }
    }

    return score;
  }
}
