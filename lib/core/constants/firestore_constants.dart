import 'package:flutter/foundation.dart';

/// firestore DB 분기
class FirestoreConstants {
  bool get isDebugMode => !kReleaseMode;

  String get usersCollection => isDebugMode ? 'users_test' : 'users';
  String get packagesCollection => isDebugMode ? 'packages_test' : 'packages';
  String get schedulesCollection => isDebugMode ? 'schedule_test' : 'schedule';
  String get bannersCollection => isDebugMode ? 'banners_test' : 'banners';
  String get noticesCollection => isDebugMode ? 'notices_test' : 'notices';
}
