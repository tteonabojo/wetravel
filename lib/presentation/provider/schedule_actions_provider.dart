import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';

class ScheduleActions {
  final firestoreConstants = FirestoreConstants();

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      print('Deleting schedule: $scheduleId for user: ${user.uid}');

      await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(user.uid)
          .collection(firestoreConstants.schedulesCollection)
          .doc(scheduleId)
          .delete();

      print('Schedule deleted successfully');
    } catch (e) {
      print('Schedule deletion error: $e');
      rethrow;
    }
  }
}

final scheduleActionsProvider = Provider((ref) => ScheduleActions());
