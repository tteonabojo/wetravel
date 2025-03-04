import 'package:wetravel/data/dto/user_dto.dart';

abstract interface class UserDataSource {
  Future<UserDto> fetchUser();

  Future<List<UserDto>> fetchUsersByIds(List<String> ids);

  /// 소셜 로그인
  Future<UserDto> signInWithProvider({required provider});

  /// 로그아웃
  Future<bool> signOut();

  Future<void> updateUserProfile(UserDto userDto);

  Future<void> deleteAccount();

  
}
