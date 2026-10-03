import '../entities/payment_method_entity.dart';
import '../entities/payment_result_entity.dart';

abstract class PaymentRepository {
  Future<PaymentResultEntity> processPayment({
    required double amount,
    required PaymentMethodType method,
  });
}
