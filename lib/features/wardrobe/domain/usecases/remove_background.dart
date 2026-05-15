import 'dart:io';
import '../repositories/wardrobe_repository.dart';

class RemoveBackground {
  final WardrobeRepository repository;

  RemoveBackground(this.repository);

  Future<File?> call(File image) {
    return repository.removeBackground(image);
  }
}
