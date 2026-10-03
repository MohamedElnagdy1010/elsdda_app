import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';

class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phone,
    required super.whatsapp,
    required super.isActive,
    required super.sortOrder,
  });

  factory BranchModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return BranchModel(
      id: id,
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      whatsapp: map['whatsapp']?.toString() ?? '',
      isActive: map['isActive'] as bool? ?? true,
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
