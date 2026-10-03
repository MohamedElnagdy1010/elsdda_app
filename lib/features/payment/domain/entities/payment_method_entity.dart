import 'package:equatable/equatable.dart';

enum PaymentMethodType { mada, card, applePay }

class PaymentMethodEntity extends Equatable {
  final PaymentMethodType type;
  final String title;
  final String subtitle;
  final bool isAvailable;

  const PaymentMethodEntity({
    required this.type,
    required this.title,
    required this.subtitle,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [type, title, subtitle, isAvailable];
}
