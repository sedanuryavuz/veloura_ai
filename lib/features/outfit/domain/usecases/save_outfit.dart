import '../entities/outfit.dart';
import '../repositories/outfit_repository.dart';

class SaveOutfit {
  final OutfitRepository repository;

  SaveOutfit(this.repository);

  Future<Outfit> execute(Outfit outfit) {
    return repository.saveOutfit(outfit);
  }
}
