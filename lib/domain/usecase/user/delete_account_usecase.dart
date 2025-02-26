import 'package:wetravel/domain/repository/user_repository.dart';

class DeleteAccountUseCase {
  final UserRepository _userRepository;

  DeleteAccountUseCase(this._userRepository);

  Future<void> execute() async {
    return await _userRepository.deleteAccount();
  }
}