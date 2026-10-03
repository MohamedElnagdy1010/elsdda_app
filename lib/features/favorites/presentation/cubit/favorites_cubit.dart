import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/features/favorites/domain/use_cases/add_favorite_use_case.dart';
import 'package:sufra_app/features/favorites/domain/use_cases/get_favorites_use_case.dart';
import 'package:sufra_app/features/favorites/domain/use_cases/remove_favorite_use_case.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  FavoritesCubit({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
  }) : super(const FavoritesInitial());

  List<ProductEntity> _products = [];
  Set<String> _favoriteIds = {};

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  Future<void> loadFavorites(String userId) async {
    emit(const FavoritesLoading());

    try {
      _products = await getFavoritesUseCase(userId);

      _favoriteIds = _products.map((product) => product.id).toSet();

      _emitLoaded();
    } catch (_) {
      emit(const FavoritesFailure('حدث خطأ أثناء تحميل المفضلة'));
    }
  }

  Future<void> toggleFavorite({
    required String userId,
    required ProductEntity product,
  }) async {
    final wasFavorite = isFavorite(product.id);

    // Optimistic update
    if (wasFavorite) {
      _favoriteIds.remove(product.id);
      _products.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteIds.add(product.id);

      if (!_products.any((item) => item.id == product.id)) {
        _products.add(product);
      }
    }

    _emitLoaded();

    try {
      if (wasFavorite) {
        await removeFavoriteUseCase(userId: userId, productId: product.id);
      } else {
        await addFavoriteUseCase(userId: userId, product: product);
      }
    } catch (_) {
      // لو Firestore فشل نرجع التغيير.
      if (wasFavorite) {
        _favoriteIds.add(product.id);

        if (!_products.any((item) => item.id == product.id)) {
          _products.add(product);
        }
      } else {
        _favoriteIds.remove(product.id);
        _products.removeWhere((item) => item.id == product.id);
      }

      _emitLoaded();

      rethrow;
    }
  }

  void clearFavorites() {
    _products.clear();
    _favoriteIds.clear();
    emit(const FavoritesInitial());
  }

  void _emitLoaded() {
    emit(
      FavoritesLoaded(
        products: List.unmodifiable(_products),
        favoriteIds: Set.unmodifiable(_favoriteIds),
      ),
    );
  }
}
