import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class SignInWithProviderUsecase {
  final UserRepository _userRepository;
  SignInWithProviderUsecase(this._userRepository);

  Future<User> execute({required provider}) async {
    return await _userRepository.signInWithProvider(provider: provider);
  }
}
