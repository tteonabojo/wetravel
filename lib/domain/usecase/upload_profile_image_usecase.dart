import 'dart:io';
import 'package:wetravel/domain/repository/firebase_storage_repository.dart';

class UploadProfileImageUseCase {
  final FirebaseStorageRepository _firebaseStorageRepository;

  UploadProfileImageUseCase(this._firebaseStorageRepository);

  Future<String> execute(File imageFile) async {
    return await _firebaseStorageRepository.uploadProfileImage(imageFile);
  }
}