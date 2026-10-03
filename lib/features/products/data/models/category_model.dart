import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.sortOrder,
    required super.isActive,
  });

  factory CategoryModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }
}
