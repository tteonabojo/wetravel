import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/firebase/firebase_storage.dart';

final firebaseStorageProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});
