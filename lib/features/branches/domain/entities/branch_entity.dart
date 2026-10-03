class BranchEntity {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String whatsapp;
  final bool isActive;
  final int sortOrder;

  const BranchEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.whatsapp,
    required this.isActive,
    required this.sortOrder,
  });
}
