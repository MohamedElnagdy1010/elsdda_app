import '../entities/payment_method_entity.dart';
import '../entities/payment_result_entity.dart';
import '../repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  const ProcessPaymentUseCase(this.repository);

  Future<PaymentResultEntity> call({
    required double amount,
    required PaymentMethodType method,
  }) {
    return repository.processPayment(amount: amount, method: method);
  }
}
