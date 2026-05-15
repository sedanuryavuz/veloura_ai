import 'dart:io';
import '../../domain/entities/clothing_item.dart';
import '../../domain/repositories/wardrobe_repository.dart';
import '../datasources/wardrobe_remote_data_source.dart';
import '../models/clothing_model.dart';

class WardrobeRepositoryImpl implements WardrobeRepository {
  final WardrobeRemoteDataSource remoteDataSource;

  WardrobeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ClothingItem>> getItems(String userId) async {
    final models = await remoteDataSource.getItems(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ClothingItem> addItem(ClothingItem item) async {
    final model = ClothingModel.fromEntity(item);
    final addedModel = await remoteDataSource.addItem(model);
    return addedModel.toEntity();
  }

  @override
  Future<ClothingItem> updateItem(ClothingItem item) async {
    final model = ClothingModel.fromEntity(item);
    final updatedModel = await remoteDataSource.updateItem(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteItem(String id) {
    return remoteDataSource.deleteItem(id);
  }

  @override
  Future<String> uploadImage(File file, String userId) {
    return remoteDataSource.uploadImage(file, userId);
  }

  @override
  Future<void> deleteImage(String imageUrl) {
    return remoteDataSource.deleteImage(imageUrl);
  }

  @override
  Future<Map<String, dynamic>?> analyzeClothing(File image) {
    return remoteDataSource.analyzeClothing(image);
  }

  @override
  Future<File?> removeBackground(File image) {
    return remoteDataSource.removeBackground(image);
  }
}