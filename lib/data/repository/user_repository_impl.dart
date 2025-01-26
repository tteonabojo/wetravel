import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._userDataSource);
  final UserDataSource _userDataSource;

  @override
  Future<User?> fetchUser() async {
    try {
      // UserDataSource를 사용하여 사용자 정보 가져오기
      return await _userDataSource.fetchUser().then((userDto) {
        // UserDto -> User 변환
        print('User Repo Impl : $userDto');
        return userDto == null ? null : User.fromDto(userDto);
      });
    } catch (e) {
      print('Error fetching user in repository: $e');
      rethrow; // 예외 다시 throw
    }
  }
}
