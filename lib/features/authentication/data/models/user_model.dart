import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
    super.profileImage,
    super.avatarId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImage': profileImage,
      'avatarId': avatarId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      profileImage: map['profileImage'],
      avatarId: map['avatarId'],
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      profileImage: user.profileImage,
      avatarId: user.avatarId,
    );
  }
}
