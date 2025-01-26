import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this._userDataSource,
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore,
  );

  final UserDataSource _userDataSource;
  final FirebaseAuth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  @override
  Future<User?> fetchUser() async {
    try {
      return await _userDataSource.fetchUser().then((userDto) {
        return userDto == null ? null : User.fromDto(userDto);
      });
    } catch (e) {
      print('Error fetching user in repository: $e');
      rethrow;
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = FirebaseAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDto = UserDto(
          id: user.uid,
          email: user.email ?? '',
          password: '',
          name: user.displayName ?? '',
          imageUrl: user.photoURL ?? '',
          introduction: '',
          loginType: 'google',
          isGuide: false,
          createdAt: Timestamp.now(),
          updatedAt: null,
          deletedAt: null,
        );

        // Firestore에 저장
        await _userDataSource.saveUser(userDto);

        return User.fromDto(userDto);
      }
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  @override
  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = FirebaseAuth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDto = UserDto(
          id: user.uid,
          email: user.email ?? '',
          password: '',
          name: user.displayName ?? '',
          imageUrl: user.photoURL ?? '',
          introduction: '',
          loginType: 'apple',
          isGuide: false,
          createdAt: Timestamp.now(),
          updatedAt: null,
          deletedAt: null,
        );

        // Firestore에 저장
        await _userDataSource.saveUser(userDto);

        return User.fromDto(userDto);
      }
      return null;
    } catch (e) {
      print('Error signing in with Apple: $e');
      rethrow;
    }
  }

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final userDto = await _userDataSource.fetchUserById(userId);
      return userDto != null ? User.fromDto(userDto) : null;
    } catch (e) {
      print('Error fetching user by ID: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      final userDto = user.toDto();
      final docRef = _firestore.collection('users').doc(user.id);

      // 사용자 데이터 저장
      await docRef.set(userDto.toJson(), SetOptions(merge: true));

      // scrapList를 서브컬렉션으로 저장
      final scrapListRef = docRef.collection('scrapList');

      // scrapList가 null이 아니면 서브컬렉션에 저장
      if (userDto.scrapList != null && userDto.scrapList!.isNotEmpty) {
        for (var packageDto in userDto.scrapList!) {
          await scrapListRef.doc(packageDto.id).set(packageDto.toJson());
        }
      } else if (userDto.scrapList == null || userDto.scrapList!.isEmpty) {
        // scrapList가 비어 있으면 'empty' 문서를 추가하여 서브컬렉션을 생성
        await scrapListRef
            .doc('empty')
            .set({'status': 'empty'}); // 빈 서브컬렉션을 위한 빈 문서 추가
      }
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }
}
