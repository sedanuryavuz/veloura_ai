import '../entities/outfit.dart';
import '../repositories/outfit_repository.dart';

class GetOutfits {
  final OutfitRepository repository;

  GetOutfits(this.repository);

  Future<List<Outfit>> execute(String userId) {
    return repository.getOutfits(userId);
  }
}
