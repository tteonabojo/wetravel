import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 파일 업로드
  Future<String> uploadFile(String path, List<int> data) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putData(Uint8List.fromList(data));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // 파일 다운로드 URL 가져오기
  Future<String> getDownloadURL(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  // 파일 삭제
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}
