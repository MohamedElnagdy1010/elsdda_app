import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;

    final user = UserModel(
      uid: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
    );

    await firestore.collection('users').doc(uid).set({
      ...user.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;

    final document = await firestore.collection('users').doc(uid).get();

    if (!document.exists || document.data() == null) {
      throw Exception('بيانات المستخدم غير موجودة');
    }

    return UserModel.fromMap(document.data()!);
  }

  @override
  Future<void> logout() {
    return firebaseAuth.signOut();
  }
}
