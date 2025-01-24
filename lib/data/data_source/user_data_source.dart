import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/data/dto/user_dto.dart';

abstract interface class UserDataSource {
  Future<List<UserDto>> fetchUsers();

  /// 소셜 로그인
  Future<UserDto> signInWithProvider({required provider});
}
