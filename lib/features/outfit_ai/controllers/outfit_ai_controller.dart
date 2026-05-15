import 'package:flutter/material.dart';
import '../../../domain/usecases/generate_ai_outfit_usecase.dart';
import '../models/ai_outfit_result.dart';

class OutfitAiController extends ChangeNotifier {
  final GenerateAiOutfitUseCase generateAiOutfitUseCase;

  OutfitAiController({
    required this.generateAiOutfitUseCase,
  });

  bool isLoading = false;
  String? error;
  AiOutfitResult? result;

  Future<void> generateOutfit({
    required List wardrobe,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      result = await generateAiOutfitUseCase.execute(
        wardrobe: wardrobe,
      );

      if (result == null) {
        throw Exception("AI result null");
      }
    } catch (e) {
      error = e.toString();
      debugPrint("OUTFIT AI CONTROLLER ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}