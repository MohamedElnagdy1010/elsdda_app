import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/order_entity.dart';
import '../../../domain/use_cases/create_order_use_case.dart';
import '../../../domain/use_cases/get_user_orders_use_case.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetUserOrdersUseCase getUserOrdersUseCase;

  OrdersCubit({
    required this.createOrderUseCase,
    required this.getUserOrdersUseCase,
  }) : super(const OrdersInitial());

  Future<void> createOrder(OrderEntity order) async {
    if (state is OrdersLoading) return;

    emit(const OrdersLoading());

    try {
      await createOrderUseCase(order);

      emit(OrderCreatedSuccess(order));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Create order error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      emit(
        const OrdersFailure('تعذر إنشاء الطلب حاليًا، يرجى المحاولة مرة أخرى.'),
      );
    }
  }

  Future<void> getUserOrders(String userId) async {
    emit(const OrdersLoading());

    try {
      final orders = await getUserOrdersUseCase(userId);

      emit(OrdersLoaded(orders));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Get user orders error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      emit(
        const OrdersFailure(
          'تعذر تحميل الطلبات حاليًا، يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  void reset() {
    emit(const OrdersInitial());
  }
}
