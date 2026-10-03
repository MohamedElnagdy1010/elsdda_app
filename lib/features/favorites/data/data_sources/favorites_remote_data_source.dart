import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sufra_app/features/products/data/models/product_model.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<ProductModel>> getFavorites(String userId);

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

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore firestore;

  FavoritesRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _favoritesRef(String userId) {
    return firestore.collection('users').doc(userId).collection('favorites');
  }

  @override
  Future<List<ProductModel>> getFavorites(String userId) async {
    final snapshot = await _favoritesRef(userId).get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(id: doc.id, map: doc.data()))
        .toList();
  }

  @override
  Future<void> addFavorite({
    required String userId,
    required ProductEntity product,
  }) async {
    await _favoritesRef(userId).doc(product.id).set({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'image': product.image,
      'categoryId': product.categoryId,
      'rating': product.rating,
      'reviews': product.reviews,
      'isPopular': product.isPopular,
      'isFeatured': product.isFeatured,
      'isAvailable': product.isAvailable,
      'options': product.options
          .map(
            (option) => {
              'name': option.name,
              'additionalPrice': option.additionalPrice,
            },
          )
          .toList(),
      'createdAt': product.createdAt != null
          ? Timestamp.fromDate(product.createdAt!)
          : FieldValue.serverTimestamp(),
      'favoritedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required String productId,
  }) async {
    await _favoritesRef(userId).doc(productId).delete();
  }

  @override
  Future<bool> isFavorite({
    required String userId,
    required String productId,
  }) async {
    final document = await _favoritesRef(userId).doc(productId).get();

    return document.exists;
  }
}
