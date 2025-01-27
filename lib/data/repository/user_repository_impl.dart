import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this._userDataSource,
  );

  final UserDataSource _userDataSource;

  @override
  Future<User?> fetchUser() async {
    try {
      return await _userDataSource.fetchUser().then((userDto) {
        return userDto == null ? null : User.fromDto(userDto as UserDto);
      });
    } catch (e) {
      print('Error fetching user in repository: $e');
      rethrow;
    }
  }

  @override
  Future<User> signInWithProvider({required provider}) async {
    final result = await _userDataSource.signInWithProvider(provider: provider);
    return result.toEntity();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  // 추후 구현
  @override
  Future<bool> signUp({required String email, required String password}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  // 추후 구현
  @override
  Future<User> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
