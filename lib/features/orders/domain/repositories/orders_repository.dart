import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<void> createOrder(OrderEntity order);

  Future<List<OrderEntity>> getUserOrders(String userId);
}
