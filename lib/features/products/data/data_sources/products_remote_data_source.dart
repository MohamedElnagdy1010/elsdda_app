import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getProducts();

  Future<List<ProductModel>> getPopularProducts();

  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> getFeaturedProducts();
  Future<List<ProductModel>> getLatestProducts();
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .get();

    final categories = snapshot.docs.map((doc) {
      return CategoryModel.fromMap(id: doc.id, map: doc.data());
    }).toList();

    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return categories;
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(id: doc.id, map: doc.data());
    }).toList();
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    final snapshot = await firestore
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(id: doc.id, map: doc.data()))
        .where((product) => product.isAvailable)
        .toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final snapshot = await firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(id: doc.id, map: doc.data()))
        .where((product) => product.isAvailable)
        .toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final snapshot = await firestore
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(id: doc.id, map: doc.data()))
        .where((product) => product.isAvailable)
        .toList();
  }

  @override
  Future<List<ProductModel>> getLatestProducts() async {
    final snapshot = await firestore.collection('products').get();

    final products = snapshot.docs
        .map((doc) => ProductModel.fromMap(id: doc.id, map: doc.data()))
        .where((product) => product.isAvailable)
        .toList();

    products.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      return bDate.compareTo(aDate);
    });

    return products.take(5).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final snapshot = await firestore.collection('products').get();

    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return [];
    }

    final products = snapshot.docs
        .map((doc) => ProductModel.fromMap(id: doc.id, map: doc.data()))
        .where((product) => product.isAvailable)
        .where((product) {
          final name = product.name.toLowerCase();
          final description = product.description.toLowerCase();

          return name.contains(normalizedQuery) ||
              description.contains(normalizedQuery);
        })
        .toList();

    return products;
  }
}
