import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  // 현재 로그인된 사용자 정보 불러오기
  @override
  Future<UserDto?> fetchUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 정보 가져오기
      if (user == null) {
        throw Exception('No user is currently logged in.');
      }

      final userId = user.uid;
      final docRef = _firestore.collection('users').doc(userId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        print('User Data Source Impl : ${UserDto.fromJson(snapshot.data()!)}');
        return UserDto.fromJson(snapshot.data()!);
      } else {
        throw Exception('User information not found.');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }
}
