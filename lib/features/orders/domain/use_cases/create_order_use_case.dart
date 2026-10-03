import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class CreateOrderUseCase {
  final OrdersRepository repository;

  CreateOrderUseCase(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}
