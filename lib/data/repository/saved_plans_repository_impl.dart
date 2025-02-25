import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/domain/repository/saved_plans_repository.dart';

class SavedPlansRepositoryImpl extends FirestoreConstants
    implements SavedPlansRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SavedPlansRepositoryImpl(this._firestore, this._auth);

  @override
  Future<int> getSavedPlansCount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final snapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('schedule')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
