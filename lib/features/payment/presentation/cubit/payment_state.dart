import 'package:equatable/equatable.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_result_entity.dart';

enum PaymentProcessStatus { idle, processing, success, failure, cancelled }

class PaymentState extends Equatable {
  final PaymentMethodType selectedMethod;
  final PaymentProcessStatus status;
  final PaymentResultEntity? result;
  final String? errorMessage;

  const PaymentState({
    this.selectedMethod = PaymentMethodType.mada,
    this.status = PaymentProcessStatus.idle,
    this.result,
    this.errorMessage,
  });

  bool get isProcessing => status == PaymentProcessStatus.processing;

  PaymentState copyWith({
    PaymentMethodType? selectedMethod,
    PaymentProcessStatus? status,
    PaymentResultEntity? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return PaymentState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      status: status ?? this.status,
      result: clearResult ? null : result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedMethod, status, result, errorMessage];
}
