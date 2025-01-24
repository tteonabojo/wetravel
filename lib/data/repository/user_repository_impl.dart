import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._userDataSource);
  final UserDataSource _userDataSource;

  @override
  Future<List<User>> fetchUsers() async {
    final result = await _userDataSource.fetchUsers();
    return result
        .map(
          (e) => User(
            id: e.id,
            email: e.email,
            password: e.password,
            name: e.name,
            imageUrl: e.imageUrl,
            introduction: e.introduction,
            loginType: e.loginType,
            isGuide: e.isGuide,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          ),
        )
        .toList();
  }

  @override
  Future<User> signInWithProvider({required provider}) {
    // TODO: implement signInWithProvider
    throw UnimplementedError();
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
