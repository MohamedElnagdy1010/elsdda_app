import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<void> createOrder(OrderEntity order);

  Future<List<OrderModel>> getUserOrders(String userId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;

  OrdersRemoteDataSourceImpl({
    required this.firestore,
    required this.functions,
  });

  @override
  Future<void> createOrder(OrderEntity order) async {
    final callable = functions.httpsCallable('createOrder');

    final items = order.items.map((item) {
      return {
        'productId': item.productId,
        'quantity': item.quantity,
        'selectedOption': item.selectedOption,
      };
    }).toList();

    await callable.call({
      'items': items,
      'address': order.address.trim(),
      'paymentMethod': order.paymentMethod,
    });
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    final orders = snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();

    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return orders;
  }
}
