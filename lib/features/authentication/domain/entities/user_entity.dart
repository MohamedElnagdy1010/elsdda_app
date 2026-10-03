import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;

  final String? profileImage;
  final String? avatarId;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImage,
    this.avatarId,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    address,
    profileImage,
    avatarId,
  ];
}
