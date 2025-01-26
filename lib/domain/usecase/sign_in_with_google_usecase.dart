import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class SignInWithGoogleUseCase {
  final FirebaseAuth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final UserRepository userRepository;

  SignInWithGoogleUseCase(
      this.firebaseAuth, this.googleSignIn, this.userRepository);

  Future<User?> execute() async {
    try {
      // Google 로그인
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in failed");
      }

      final googleAuth = await googleUser.authentication;

      // Firebase 인증
      final credential = FirebaseAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception("Firebase sign-in failed");
      }

      // 기존 사용자 여부 확인 및 처리
      final existingUser =
          await userRepository.getUserById(userCredential.user!.uid);
      if (existingUser != null) {
        // 기존 사용자 존재
        return existingUser;
      } else {
        // 새로운 사용자 등록
        final newUser = User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          password: null,
          name: userCredential.user!.displayName ?? '',
          imageUrl: userCredential.user!.photoURL ?? '',
          introduction: '',
          loginType: 'google',
          isGuide: false, // 기본값
          createdAt: Timestamp.now(),
          updatedAt: null,
          deletedAt: null,
        );
        await userRepository.saveUser(newUser); // 사용자 정보 저장
        return newUser;
      }
    } catch (e) {
      print("Sign-in failed: $e");
      return null;
    }
  }
}
