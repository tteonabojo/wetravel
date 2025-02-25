import 'package:wetravel/domain/repository/user_repository.dart';

class SignOutUsecase {
  final UserRepository _userRepository;
  SignOutUsecase(this._userRepository);

  Future<bool> execute() async {
    return await _userRepository.signOut();
  }
}
