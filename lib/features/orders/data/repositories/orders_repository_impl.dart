import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../data_sources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createOrder(OrderEntity order) {
    return remoteDataSource.createOrder(order);
  }

  @override
  Future<List<OrderEntity>> getUserOrders(String userId) {
    return remoteDataSource.getUserOrders(userId);
  }
}
