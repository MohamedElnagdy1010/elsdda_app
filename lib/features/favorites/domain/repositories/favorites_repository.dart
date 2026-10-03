import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

abstract class FavoritesRepository {
  Future<List<ProductEntity>> getFavorites(String userId);

  Future<void> addFavorite({
    required String userId,
    required ProductEntity product,
  });

  Future<void> removeFavorite({
    required String userId,
    required String productId,
  });

  Future<bool> isFavorite({required String userId, required String productId});
}
