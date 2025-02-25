import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wetravel/domain/repository/firebase_storage_repository.dart';

class FirebaseStorageRepositoryImpl implements FirebaseStorageRepository {
  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      // Firebase Storage에 저장 경로 지정
      final fileName = 'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);

      // 이미지 업로드
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}