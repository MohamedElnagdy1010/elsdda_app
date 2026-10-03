import 'package:sufra_app/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call({required String userId, required ProductEntity product}) {
    return repository.addFavorite(userId: userId, product: product);
  }
}
