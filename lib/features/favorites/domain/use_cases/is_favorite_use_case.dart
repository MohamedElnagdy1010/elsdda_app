import 'package:sufra_app/features/favorites/domain/repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  final FavoritesRepository repository;

  IsFavoriteUseCase(this.repository);

  Future<bool> call({required String userId, required String productId}) {
    return repository.isFavorite(userId: userId, productId: productId);
  }
}
