import 'package:sufra_app/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call({required String userId, required String productId}) {
    return repository.removeFavorite(userId: userId, productId: productId);
  }
}
