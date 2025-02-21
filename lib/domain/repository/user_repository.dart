import 'package:wetravel/domain/entity/user.dart';

abstract interface class UserRepository {
  Future<User> fetchUser();

  Future<List<User>> fetchUsersByIds(List<String> ids);

  // /// 일반 회원가입
  // Future<bool> signUp({required String email, required String password});

  // /// 일반 로그인
  // Future<User> signIn({required String email, required String password});

  /// 소셜 로그인
  Future<User> signInWithProvider({required provider});

  /// 로그아웃
  Future<bool> signOut();
}
