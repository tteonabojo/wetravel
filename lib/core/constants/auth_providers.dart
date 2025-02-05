import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthProvider {
  Future<UserCredential> signIn();
}

class GoogleAuthProvider implements AuthProvider {
  @override
  Future<UserCredential> signIn() async {
    try {
      // Google 로그인 진행
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign in cancelled');

      // 인증 정보 얻기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken ?? '',
          idToken: googleAuth.idToken ?? '',
        ),
      );

      // Firebase Auth로 로그인
      return await FirebaseAuth.instance
          .signInWithCredential(credential as AuthCredential);
    } catch (e) {
      print('Error in GoogleAuthProvider.signIn: $e');
      rethrow;
    }
  }

  static AuthCredential credential(
      {required String accessToken, required String idToken}) {
    return GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
  }
}

class AuthProviders {
  static final google = GoogleAuthProvider();
  static final apple = AppleAuthProvider();
}

class AppleAuthProvider implements AuthProvider {
  @override
  Future<UserCredential> signIn() async {
    // Apple 로그인 구현
    throw UnimplementedError('Apple sign in not implemented yet');
  }
}
