import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository _userRepository;

  GetUserDataUseCase(this._userRepository);

  Future<User> execute() async {
    return await _userRepository.getUserData();
  }
}