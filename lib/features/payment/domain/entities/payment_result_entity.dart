import 'package:equatable/equatable.dart';

enum PaymentResultStatus { success, failed, cancelled }

class PaymentResultEntity extends Equatable {
  final PaymentResultStatus status;
  final String? transactionId;
  final String? message;

  const PaymentResultEntity({
    required this.status,
    this.transactionId,
    this.message,
  });

  bool get isSuccess => status == PaymentResultStatus.success;

  @override
  List<Object?> get props => [status, transactionId, message];
}
