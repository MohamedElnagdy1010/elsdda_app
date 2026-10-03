import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sufra_app/features/branches/data/models/branch_model.dart';

abstract class BranchesRemoteDataSource {
  Future<List<BranchModel>> getBranches();
}

class BranchesRemoteDataSourceImpl implements BranchesRemoteDataSource {
  final FirebaseFirestore firestore;

  BranchesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BranchModel>> getBranches() async {
    final snapshot = await firestore.collection('branches').get();

    final branches = snapshot.docs
        .map((doc) => BranchModel.fromMap(id: doc.id, map: doc.data()))
        .where((branch) => branch.isActive)
        .toList();

    branches.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return branches;
  }
}
