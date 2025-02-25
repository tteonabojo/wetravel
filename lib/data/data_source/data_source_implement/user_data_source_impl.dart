import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/src/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wetravel/core/constants/auth_providers.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class UserDataSourceImpl extends FirestoreConstants implements UserDataSource {
  final FirebaseFirestore _firestore;
  UserDataSourceImpl(this._firestore, instance);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreConstants = FirestoreConstants();

  Future<UserDto> _fetchUserFromFirestore(String userId) async {
    try {
      final userRef = _firestore.collection(usersCollection).doc(userId);
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        return UserDto.fromJson(userDoc.data()?? {});
      } else {
        throw Exception('유저 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }

  Future<UserDto> fetchUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다.');
      }
      return await _fetchUserFromFirestore(currentUser.uid);
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }

  @override
  Future<UserDto> signInWithProvider({required provider}) async {
    try {
      UserCredential? userCredential;
      AuthCredential? credential;

      if (provider == AuthProviders.google) {
        // 구글 로그인 자격 증명 생성
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else if (provider == AuthProviders.apple) {
        // 애플 로그인 자격 증명 생성
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'com.tteonabojo.weetravel.service',
            redirectUri: kIsWeb
                ? Uri.parse('https://wetravel-bebad.web.app/__/auth/handler')
                : Uri.parse(
                    'https://wetravel-bebad.firebaseapp.com/__/auth/handler'),
          ),
        );

        final oAuthProvider = OAuthProvider(AuthProviders.apple);
        credential = oAuthProvider.credential(
          accessToken: appleCredential.authorizationCode,
          idToken: appleCredential.identityToken,
        );
      } else {
        throw Exception('지원되지 않는 제공자');
      }

      // 유저 로그인
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Firestore 사용자 정보 생성 혹은 업데이트
      if (currentUser != null) {
        final firestore = FirebaseFirestore.instance;
        final userRef =
            firestore.collection(usersCollection).doc(currentUser.uid);
        final userDoc = await userRef.get();

        if (!userDoc.exists) {
          final userData = {
            'id': currentUser.uid,
            'email': currentUser.email,
            'name': currentUser.displayName ?? '',
            'loginType': provider,
            'isAdmin': false,
            'createdAt': Timestamp.fromDate(DateTime.now()),
            'imageUrl': currentUser.photoURL ?? '',
          };

          await userRef.set(userData);
        }

        final updatedUserDoc = await userRef.get();
        return UserDto.fromJson(updatedUserDoc.data() ?? {});
      }

      throw Exception('사용자 정보를 찾을 수 없음');
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      rethrow;
    }
  }

  @override
  Future<UserDto> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('사용자 정보를 찾을 수 없습니다.');
      }

      final doc = await _firestore.collection(firestoreConstants.usersCollection).doc(user.uid).get(); // await 추가
      if (!doc.exists) {
        throw Exception('사용자 정보를 찾을 수 없습니다.');
      }
      final data = doc.data()!;
      var isAdmin = null;
      var createdAt = null;
      return UserDto(
        id: user.uid,
        name: data['name']?? '',
        introduction: data['intro']?? '',
        imageUrl: data['imageUrl'], email: '', 
        loginType: '',
        isAdmin: isAdmin, 
        createdAt: createdAt, 
        recentPackages: [],
      );
    } catch (e) {
      // 에러 처리
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserDto user) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('사용자 정보를 찾을 수 없습니다.');
      }
      _firestore.collection(firestoreConstants.usersCollection).doc(currentUser.uid).set({
        'name': user.name,
        'intro': user.introduction,
        'imageUrl': user.imageUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      // 에러 처리
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('사용자 정보를 찾을 수 없습니다.');
    }

    try {
      // 먼저 재인증 실행 (Firebase에서 필수 요구사항)
      await _reauthenticateUser(user);

      // Firestore에서 유저 데이터 삭제
      final userDoc = await FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(user.uid)
        .get();
      final profileImageUrl = userDoc.data()?['imageUrl'] ?? '';

      await FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(user.uid)
        .delete();

      // Firebase Storage에 저장된 프로필 이미지 삭제
      if (profileImageUrl.isNotEmpty) {
        try {
          final storageRef =
              FirebaseStorage.instance.refFromURL(profileImageUrl);
          await storageRef.delete();
        } catch (e) {
          print("프로필 이미지 삭제 실패: $e");
        }
      }

      // Firebase Authentication 계정 삭제
      await user.delete();
      print("회원 탈퇴 성공");
    } catch (e) {
      print("회원 탈퇴 실패: $e");
      throw FirebaseAuthException(
          code: 'reauthentication-failed', message: "재인증에 실패했습니다.");
    }
  }

  // 재인증 메서드 수정
  Future<void> _reauthenticateUser(User user) async {
    try {
      final providerData = user.providerData;
      if (providerData.isEmpty) return;

      final providerId = providerData.first.providerId;

      if (providerId == 'google.com') {
        print("Google 로그인 사용자 재인증 진행");

        // GoogleSignIn을 사용하여 새 토큰 가져오기
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(
              code: 'google-sign-in-cancelled', message: "Google 로그인 취소됨.");
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await user.reauthenticateWithCredential(credential);
      } else if (providerId == 'apple.com') {
        print("Apple 로그인 사용자 재인증 진행");
        final OAuthProvider appleProvider = OAuthProvider('apple.com');
        await user.reauthenticateWithProvider(appleProvider);
      }
    } catch (e) {
      print("재인증 실패: $e");
      throw FirebaseAuthException(
          code: 'reauthentication-failed', message: "재인증에 실패했습니다.");
    }
  }

@override
Future<bool> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      return true;
    } else {
      print("로그아웃 실패: 사용자 정보가 남아 있음.");
      return false;
    }
  } catch (e) {
    print("로그아웃 실패: $e");
    return false;
  }
}
Future<List<UserDto>> fetchUsersByIds(List<String> ids) async {
    final results = await _firestore
        .collection(usersCollection)
        .where('id', whereIn: ids)
        .get();
    return results.docs.map((e) => UserDto.fromJson(e.data())).toList();
  }
}