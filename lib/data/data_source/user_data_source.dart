import 'package:wetravel/data/dto/user_dto.dart';

abstract interface class UserDataSource {
  Future<UserDto> fetchUser();

  /// 소셜 로그인
  Future<UserDto> signInWithProvider({required provider});

  /// 로그아웃
  Future<bool> signOut();
}
