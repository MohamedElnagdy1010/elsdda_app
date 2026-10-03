import 'package:sufra_app/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<ProductEntity>> call(String userId) {
    return repository.getFavorites(userId);
  }
}
