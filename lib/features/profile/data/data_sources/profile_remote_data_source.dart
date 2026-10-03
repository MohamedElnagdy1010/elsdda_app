import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../authentication/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    required String address,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> getProfile() async {
    final currentUser = firebaseAuth.currentUser;

    if (currentUser == null) {
      throw Exception('المستخدم غير مسجل الدخول');
    }

    final document = await firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!document.exists || document.data() == null) {
      throw Exception('بيانات المستخدم غير موجودة');
    }

    return UserModel.fromMap(document.data()!);
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final currentUser = firebaseAuth.currentUser;

    if (currentUser == null) {
      throw Exception('المستخدم غير مسجل الدخول');
    }

    final userRef = firestore.collection('users').doc(currentUser.uid);

    await userRef.update({
      'name': name.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
    });

    final document = await userRef.get();

    if (!document.exists || document.data() == null) {
      throw Exception('تعذر تحميل البيانات بعد التحديث');
    }

    return UserModel.fromMap(document.data()!);
  }
}
