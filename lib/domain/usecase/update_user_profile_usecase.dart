import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class UpdateUserProfileUseCase {
  final UserRepository _userRepository;

  UpdateUserProfileUseCase(this._userRepository);

  Future<void> execute(User user) async {
    return await _userRepository.updateUserProfile(user);
  }
}