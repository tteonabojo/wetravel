import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wetravel/core/constants/auth_providers.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  Future<UserDto> fetchUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다.');
      }
      final userRef = _firestore.collection('users').doc(currentUser.uid);
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        print("Found user: ${userDoc.id}");
        print("User data: ${userDoc.data()}");
        return UserDto.fromJson(userDoc.data() ?? {});
      } else {
        print("No user found in Firestore");
        throw Exception('유저 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }

  @override
  Future<UserDto> signInWithProvider({required provider}) async {
    try {
      final userCredential = await provider.signIn();
      final user = userCredential.user;

      if (user == null) throw Exception('Failed to sign in');

      // 경로 확인을 위한 로그 추가
      print('Checking user document at path: users/${user.uid}');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      print('User document exists: ${userDoc.exists}');
      print('Current document data: ${userDoc.data()}');

      if (!userDoc.exists) {
        // 새 사용자인 경우 Firestore에 문서 생성
        final newUserData = {
          'uid': user.uid,
          'id': user.uid,
          'email': user.email,
          'name': user.displayName,
          'imageUrl': user.photoURL,
          'loginType': provider.runtimeType.toString(),
          'isGuide': false,
          'createdAt': FieldValue.serverTimestamp(),
          'schedules': [], // 빈 배열로 초기화
          'scrapList': [],
          'scrapIdList': [],
          'recentPackages': [],
        };

        print('Creating new user with data: $newUserData');
        await _firestore.collection('users').doc(user.uid).set(newUserData);

        // 생성 후 문서 확인
        final createdDoc =
            await _firestore.collection('users').doc(user.uid).get();
        print('Created document data: ${createdDoc.data()}');

        return UserDto.fromJson(newUserData);
      }

      // 기존 사용자인 경우 문서 데이터 반환
      final userData = {
        ...userDoc.data()!,
        'id': userDoc.id,
        'uid': userDoc.id,
      };

      print('Returning existing user data: $userData');
      return UserDto.fromJson(userData);
    } catch (e) {
      print('Error in signInWithProvider: $e');
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
