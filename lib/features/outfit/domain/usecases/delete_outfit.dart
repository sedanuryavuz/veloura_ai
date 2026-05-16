import '../repositories/outfit_repository.dart';

class DeleteOutfit {
  final OutfitRepository repository;

  DeleteOutfit(this.repository);

  Future<void> execute(String id) {
    return repository.deleteOutfit(id);
  }
}
