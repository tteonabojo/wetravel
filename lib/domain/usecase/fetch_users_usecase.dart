import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class FetchUsersUsecase {
  FetchUsersUsecase(this._userRepository);
  final UserRepository _userRepository;

  Future<List<User>> execute() async {
    return await _userRepository.fetchUsers();
  }
}
