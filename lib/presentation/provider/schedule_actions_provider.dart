import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';

// Firebase providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

class ScheduleActions {
  final firestoreConstants = FirestoreConstants();

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      print('Attempting to delete schedule:');
      print('User ID: ${user.uid}');
      print('Schedule ID: $scheduleId');

      await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(user.uid)
          .collection('schedule')
          .doc(scheduleId)
          .delete();

      print('Schedule deleted successfully: $scheduleId');
    } catch (e, stackTrace) {
      print('Error deleting schedule: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to delete schedule: $e');
    }
  }
}

// Provider를 단순화
final scheduleActionsProvider = Provider((ref) => ScheduleActions());
