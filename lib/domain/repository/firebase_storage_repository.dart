import 'dart:io';

abstract class FirebaseStorageRepository {
  Future<String> uploadProfileImage(File imageFile);
}