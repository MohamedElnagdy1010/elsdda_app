import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final int sortOrder;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.sortOrder,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, image, sortOrder, isActive];
}
