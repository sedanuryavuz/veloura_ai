import 'dart:io';
import '../repositories/wardrobe_repository.dart';

class AnalyzeClothing {
  final WardrobeRepository repository;

  AnalyzeClothing(this.repository);

  Future<Map<String, dynamic>?> call(File image) {
    return repository.analyzeClothing(image);
  }
}
