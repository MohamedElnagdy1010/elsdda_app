import 'package:equatable/equatable.dart';

class ProductOptionEntity extends Equatable {
  final String name;
  final double additionalPrice;

  const ProductOptionEntity({required this.name, this.additionalPrice = 0});

  @override
  List<Object?> get props => [name, additionalPrice];
}
