import 'package:sufra_app/features/favorites/data/data_sources/favorites_remote_data_source.dart';
import 'package:sufra_app/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getFavorites(String userId) {
    return remoteDataSource.getFavorites(userId);
  }

  @override
  Future<void> addFavorite({
    required String userId,
    required ProductEntity product,
  }) {
    return remoteDataSource.addFavorite(userId: userId, product: product);
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required String productId,
  }) {
    return remoteDataSource.removeFavorite(
      userId: userId,
      productId: productId,
    );
  }

  @override
  Future<bool> isFavorite({required String userId, required String productId}) {
    return remoteDataSource.isFavorite(userId: userId, productId: productId);
  }
}
