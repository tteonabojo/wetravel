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
      UserCredential? userCredential;
      AuthCredential? credential;

      if (provider == AuthProviders.google) {
        // 구글 로그인 자격 증명 생성
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) throw Exception('로그인 취소');

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

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

      // 계정 통합
      // // 유저의 provider 목록
      // final currentProviders =
      //     currentUser?.providerData.map((p) => p.providerId).toList() ?? [];
      //
      // // 유저의 provider에 선택한 provider가 없는 경우 추가
      // if (!currentProviders.contains(provider)) {
      //   await currentUser?.linkWithCredential(credential);
      // }

      // Firestore 사용자 정보 생성 혹은 업데이트
      if (currentUser != null) {
        final firestore = FirebaseFirestore.instance;
        final userRef = firestore.collection('users').doc(currentUser.uid);
        final userDoc = await userRef.get();

        if (!userDoc.exists) {
          final userData = {
            'id': currentUser.uid,
            'email': currentUser.email,
            'name': currentUser.displayName ?? '',
            'loginType': provider,
            'createdAt': Timestamp.fromDate(DateTime.now()),
            'imageUrl': currentUser.photoURL ?? '',
          };

          await userRef.set(userData);
        }
        // 계정 통합 기능이 생긴 다음 필요 할 듯, 지금은 로그인 한다 해서 업데이트 할 정보가 없음
        // }else {
        //   final userData = {
        //     'loginType': FieldValue.arrayUnion([provider]),
        //   };
        //   await userRef.set(userData, SetOptions(merge: true));
        // }

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
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
