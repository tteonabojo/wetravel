import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class FetchUserUsecase {
  FetchUserUsecase(this._userRepository);
  final UserRepository _userRepository;

  Future<User> execute() async {
    return await _userRepository.fetchUser();
  }
}
